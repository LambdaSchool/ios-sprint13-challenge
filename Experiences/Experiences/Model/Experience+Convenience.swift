//
//  Experience+Convenience.swift
//  Experiences
//
//  Created by Chad Rutherford on 2/14/20.
//  Copyright © 2020 Chad Rutherford. All rights reserved.
//

import CoreData
import Foundation

extension Experience {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Object Initialization Convenience Initializer
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
