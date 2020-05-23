//
//  Experience+Convenience.swift
//  Experiences
//
//  Created by Joe on 5/23/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import Foundation
import CoreData

extension Experience {
    @discardableResult convenience init(title: String,
                                        timestamp: Date,
                                        image: String,
                                        audio: String,
                                        video: String,
                                        latitude: Double,
                                        longitude: Double,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.timestamp = timestamp
        self.image = image
        self.audio = audio
        self.video = video
        self.latitude = latitude
        self.longitude = longitude
    }
}
