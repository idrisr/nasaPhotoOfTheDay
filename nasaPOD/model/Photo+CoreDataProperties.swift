//
//  Photo+CoreDataProperties.swift
//  nasaPOD
//
//  Created by id on 5/22/16.
//  Copyright © 2016 id. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {

    @NSManaged var explanation: String?
    @NSManaged var date: NSDate?
    @NSManaged var hdurl: String?
    @NSManaged var media_type: String?
    @NSManaged var service_version: String?
    @NSManaged var title: String?
    @NSManaged var url: String?
    @NSManaged var image: NSData?

}
