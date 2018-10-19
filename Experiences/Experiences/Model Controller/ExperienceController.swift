//
//  ExperienceController.swift
//  Experiences
//
//  Created by Linh Bouniol on 10/19/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class ExperienceController {
    
    init() {
        loadFromCoreData()
    }
    
    var experiences: [Experience] = []
    
    func createExperience(withTitle title: String, imageURL: URL, audioURL: URL, videoURL: URL, coordinate: CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid) {
        
        let _ = Experience(title: title, imageURL: imageURL, audioURL: audioURL, videoURL: videoURL, latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        saveToCoreData()
    }
    
    // MARK: - Persistence
    
    func saveToCoreData() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            NSLog("Error saving experience: \(error)")
        }
    }
    
    func loadFromCoreData() -> [Experience] {
        let fetchRequest: NSFetchRequest<Experience> = Experience.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching experiences: \(error)")
            return []
        }
    }
}
