//
//  ExperienceController.swift
//  Experiences
//
//  Created by Marlon Raskin on 10/5/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import CoreData

class ExperienceController {

    func createExperience(title: String, imageURL: URL, audioURL: URL, videoURL: URL, latitude: Double, longitude: Double, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            // Do something here.
        }
    }
}
