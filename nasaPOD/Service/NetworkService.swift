//
//  NetworkService.swift
//  nasaPOD
//
//  Created by id on 5/22/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit

typealias ImageResult = (UIImage?, ErrorType) -> Void
typealias NetworkResult = (AnyObject?, ErrorType) -> Void

class NetworkService: NSObject {
    var session: NSURLSession?

    func getURL(url: NSURL, completion: NetworkResult) {

    }

    func getImage(url: NSURL, completion: ImageResult) {

    }
}
