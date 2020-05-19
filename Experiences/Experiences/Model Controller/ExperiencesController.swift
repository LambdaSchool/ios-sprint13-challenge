//
//  ExperiencesController.swift
//  Experiences
//
//  Created by denis cedeno on 5/15/20.
//  Copyright © 2020 DenCedeno Co. All rights reserved.
//

import Foundation
import CoreData

class ExperiencesController {
    
    var experiencePosts: [Experience] = []

    @discardableResult
    func appendExperience(images: Data, title: String, latitude: Double, longitude: Double, uuid: UUID) -> Experience {
        
        let experiencePost = Experience(image: images, title: title, uuid: UUID(), latitude: latitude, longitide: longitude, date: Date())
        experiencePosts.append(experiencePost)
        do {
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        } catch {
            fatalError("Could not save image post: \(error)")
        }
        return experiencePost

    }
    
    func addExperience(experience: Experience) -> Experience {
        
        let experiencePost = experience
        experiencePosts.append(experiencePost)
        do {
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        } catch {
            fatalError("Could not save image post: \(error)")
        }
        return experiencePost

    }
}

