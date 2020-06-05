//
//  Experience+CoreDataProperties.swift
//  Experiences
//
//  Created by Brandi Bailey on 1/17/20.
//  Copyright © 2020 Brandi Bailey. All rights reserved.
//
//

import Foundation
import CoreData


extension Experience {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Experience> {
        return NSFetchRequest<Experience>(entityName: "Experience")
    }

    @NSManaged public var title: String?
    @NSManaged public var mediaURL: URL?
    @NSManaged public var latitude: Double
    @NSManaged public var mediaType: String?
    @NSManaged public var longitude: Double
    @NSManaged public var date: Date?

}
