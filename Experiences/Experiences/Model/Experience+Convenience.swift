//
//  Experience+Convenience.swift
//  Experiences
//
//  Created by denis cedeno on 5/15/20.
//  Copyright © 2020 DenCedeno Co. All rights reserved.
//

import Foundation
import CoreData

extension Experience {
    @discardableResult
    convenience init(image: Data,
                     title: String,
                     uuid: UUID,
                     latitude: Double,
                     longitide: Double,
                     date: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.image = image
        self.date = date
        self.title = title
        self.uuid = uuid
        self.latitude = latitude
        self.longitude = longitide
    }
}
