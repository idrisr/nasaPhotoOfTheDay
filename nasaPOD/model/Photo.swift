//
//  Photoo.swift
//  nasaPOD
//
//  Created by id on 5/24/16.
//  Copyright © 2016 id. All rights reserved.
//

import Foundation

extension NSDate {
    func toString() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.stringFromDate(self)
    }
}

class Photo {
    var explanation: String?
    var date: NSDate?
    var hdurl: String?
    var media_type: String?
    var service_version: String?
    var title: String?
    var url: String?
    var image: NSData?

    init(date: NSDate) {
        self.date = date
    }

    func updateWithDict(dict: [String: String]) {
        if let explanation = dict["explanation"] {
            self.explanation = explanation
        }

        if let url = dict["url"] {
            self.url = url
        }

        if let hdurl = dict["hdurl"] {
            self.hdurl = hdurl
        }
    }
}

typealias PhotosResult = ([Photo]?, ErrorType?) -> Void

extension Photo {
    static func allPhotos(completion: PhotosResult) {
        let startDate = NSDateComponents()

        // FIXME: get start date from plist
        startDate.year = 2016
        startDate.month = 4
        startDate.day = 20
        let calendar = NSCalendar.currentCalendar()
        let startDateNSDate = calendar.dateFromComponents(startDate)!

        let offsetComponents: NSDateComponents = NSDateComponents()
        offsetComponents.day = 1
        var nd:NSDate = startDateNSDate

        var photos = [Photo]()

        while nd.timeIntervalSince1970 <= NSDate().timeIntervalSince1970 {
            nd = calendar.dateByAddingComponents(offsetComponents, toDate: nd, options: .MatchStrictly)!;
            photos.append(Photo(date: nd))
        }

        completion(photos, nil)
    }
}