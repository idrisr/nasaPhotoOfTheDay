//
//  nasaApiRequest.swift
//  NASAPhotoOfTheDay
//
//  Created by id on 5/19/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit

extension Bool {
    func toString() -> String {
        return self ? "true": "false"
    }
}

enum queryParameters: String {
    case date = "date"
    case apikey = "api_key"
    case highdef = "hd"
}


struct APIEndpointURL {
    let baseURL: NSURL!
    let APIKey: String!

    init() {
        let filePath = NSBundle.mainBundle().pathForResource("nasaAPI", ofType: "plist")!
        let dict = NSDictionary(contentsOfFile: filePath)!

        let urlComponents = NSURLComponents()

        let path = dict["urlPath"] as! String?
        urlComponents.path = "/" + path!
        urlComponents.host = dict["urlHost"] as! String?
        urlComponents.scheme = dict["urlScheme"] as! String?

        self.baseURL = urlComponents.URL!
        self.APIKey = dict["apikey"] as! String
    }
}

struct NasaAPIURL {
    let date: String!

    func url(highdef:Bool = true) -> NSURL {
        let endpoint = APIEndpointURL()
        let url = endpoint.baseURL
        let apikey = endpoint.APIKey

        let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)

        urlComponents!.queryItems = [
            NSURLQueryItem(name: queryParameters.date.rawValue, value: self.date),
            NSURLQueryItem(name: queryParameters.highdef.rawValue, value: highdef.toString()),
            NSURLQueryItem(name: queryParameters.apikey.rawValue, value: apikey)
        ]
        return urlComponents!.URL!
    }
}