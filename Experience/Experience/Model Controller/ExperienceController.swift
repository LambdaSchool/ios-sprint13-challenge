//
//  ExperienceController.swift
//  Experience
//
//  Created by Nikita Thomas on 1/18/19.
//  Copyright © 2019 Nikita Thomas. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class ExperienceController {
    
    var experiences: [Experience] {
        return loadFromCoreData()
    }
    
    func newExperience(title: String, imageURL: URL, audioURL: URL, videoURL: URL, locationCoordinate: CLLocationCoordinate2D) {
        
        let _ = Experience(title: title, imageURL: imageURL, audioURL: audioURL, videoURL: videoURL, latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        
        saveToCoreData()
    }
    
    
    
    
    func saveToCoreData() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            NSLog("Error saving to CoreData: \(error)")
        }
    }
    
    func loadFromCoreData() -> [Experience] {
        let fetchRequest: NSFetchRequest<Experience> = Experience.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching from CoreData: \(error)")
            return []
        }
    }
    
}


