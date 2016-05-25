//
//  Photoo.swift
//  nasaPOD
//
//  Created by id on 5/24/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit

extension NSDate {
    func toString() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.stringFromDate(self)
    }
}

enum MediaType: String {
    case image = "image"
    case video = "video"
}

enum DefaultImages: String {
    case broken = "broken"
    case downloading = "downloading"
}


class Photo {
    var explanation: String?
    var date: NSDate?
    var hdurl: String?
    var media_type: MediaType?
    var service_version: String?
    var title: String?
    var url: String?
    var image: UIImage?

    init(date: NSDate) {
        self.date = date
    }

    func updateWithDict(dict: NSDictionary) {
        if let explanation = dict["explanation"] as? String {
            self.explanation = explanation
        }

        if let url = dict["url"] as? String {
            self.url = url
        }

        if let hdurl = dict["hdurl"] as? String{
            self.hdurl = hdurl
        }

        if let media_type = dict["media_type"] as? String{
            self.media_type = MediaType(rawValue: media_type)
       }
    }
}

typealias PhotosResult = ([Photo]?, ErrorType?) -> Void

extension Photo {
    static func allPhotos(completion: PhotosResult) {
        // FIXME: dont load the min date from the plist more than once
        let path = NSBundle.mainBundle().pathForResource("nasaAPI", ofType: "plist")!
        let dict = NSDictionary(contentsOfFile: path)!
        let formatter = NSDateFormatter()
        let minimumDateString = dict["minimumDate"] as! String
        formatter.dateFormat = "yyyyMMdd"

        var nd = formatter.dateFromString(minimumDateString)!
        let calendar = NSCalendar.currentCalendar()

        let offsetComponents: NSDateComponents = NSDateComponents()
        offsetComponents.day = 1

        var photos = [Photo]()

        while nd.timeIntervalSince1970 <= NSDate().timeIntervalSince1970 {
            photos.append(Photo(date: nd))
            nd = calendar.dateByAddingComponents(offsetComponents, toDate: nd, options: .MatchStrictly)!;
        }

        photos = photos.reverse()

        completion(photos, nil)
    }
}