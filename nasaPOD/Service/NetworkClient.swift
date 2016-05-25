//
//  NetworkService.swift
//  nasaPOD
//
//  Created by id on 5/22/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit

typealias ImageResult = (UIImage?, ErrorType?) -> Void
typealias NetworkResult = (AnyObject?, ErrorType?) -> Void

enum NetworkClientError: ErrorType {
    case ImageData
}

class NetworkClient: NSObject {
    private var urlSession: NSURLSession
    private var completionHandlers = [NSURL: ImageResult]()
    static let sharedInstance = NetworkClient()

    override init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSession = NSURLSession(configuration: configuration)

        super.init()
    }

    func getURL(url: NSURL, completion: NetworkResult) {
        let request = NSURLRequest(URL: url)
        let task = urlSession.dataTaskWithRequest(request) { [unowned self] (data, response, error) in
            guard let data = data else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    print(httpResponse.statusCode)
                }

                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(nil, error)
                }
                return
            }
            self.parseJSON(data, completion: completion)
        }
        task.resume()
    }

    private func parseJSON(data: NSData, completion: NetworkResult) {
        do {
            let parseResults = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            if let dictionary = parseResults as? NSDictionary {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(dictionary, nil)
                }
            } else if let array = parseResults as? [NSDictionary] {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(array, nil)
                }
            }
        } catch let parseError {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completion(nil, parseError)
            }
        }
    }

    func getImage(url: NSURL, completion: ImageResult) {
        let request = NSURLRequest(URL: url)
        let task = urlSession.downloadTaskWithRequest(request) { (fileUrl, response, error) in
            guard let fileUrl = fileUrl else {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(nil, error)
                }
                return
            }
            // You must move the file or open it for reading before this closure returns or it will be deleted
            if let data = NSData(contentsOfURL: fileUrl), image = UIImage(data: data) {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(image, nil)
                }
            } else {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(nil, NetworkClientError.ImageData)
                }
            }
        }
        task.resume()
    }
}

extension NetworkClient: NSURLSessionDelegate, NSURLSessionDownloadDelegate {
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if let error = error, url = task.originalRequest?.URL, completion = completionHandlers[url] {
            completionHandlers[url] = nil
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completion(nil, error)
            }
        }
    }

    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        // You must move the file or open it for reading before this closure returns or it will be deleted
        if let data = NSData(contentsOfURL: location), image = UIImage(data: data), request = downloadTask.originalRequest, response = downloadTask.response {
            let cachedResponse = NSCachedURLResponse(response: response, data: data)
            self.urlSession.configuration.URLCache?.storeCachedResponse(cachedResponse, forRequest: request)
            if let url = downloadTask.originalRequest?.URL, completion = completionHandlers[url] {
                completionHandlers[url] = nil
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(image, nil)
                }
            }
        } else {
            if let url = downloadTask.originalRequest?.URL, completion = completionHandlers[url] {
                completionHandlers[url] = nil
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(nil, NetworkClientError.ImageData)
                }
            }
        }
    }
}