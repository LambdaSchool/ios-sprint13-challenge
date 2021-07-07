//
//  MomentController.swift
//  MediaProgrammingSprintChallenge
//
//  Created by Nathanael Youngren on 3/29/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import CoreData

class MomentController {
    
    func createMoment(caption: String, imageURL: Data, audioURL: URL, videoURL: URL, longitude: Double, latitude: Double) {
        _ = Moment(caption: caption, imageURL: imageURL, videoURL: videoURL, audioURL: audioURL, longitude: longitude, latitude: latitude)
        saveToCoreData()
    }
    
    func saveToCoreData(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        context.perform {
            do {
                try context.save()
            } catch {
                context.reset()
                print("Error saving to core data.")
            }
        }
    }
    
    func fetchMoments(completion: @escaping ([Moment]?, Error?) -> Void) {
        
        let fetchRequest: NSFetchRequest<Moment> = Moment.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            let moments = try moc.fetch(fetchRequest)
            completion(moments, nil)
        } catch {
            completion(nil, NSError())
        }
    }
}
