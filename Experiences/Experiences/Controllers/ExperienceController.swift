//
//  ExperienceController.swift
//  Experiences
//
//  Created by Joel Groomer on 1/25/20.
//  Copyright © 2020 Julltron. All rights reserved.
//

import Foundation
import CoreData

class ExperienceController {
    
    var experiences: [Experience] = []
    
    init() {
        
    }
    
    func createExperience(id: UUID = UUID(), title: String, subtitle: String, date: Date = Date(), latitude: Double, longitude: Double, text: String?, audio: URL?, photo: URL?, video: URL?, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let experience = Experience(id: id, title: title, subtitle: subtitle, date: date, latitude: latitude, longitude: longitude, text: text, audio: audio, photo: photo, video: video)
        context.perform {
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("Unable to save new entry: \(error)")
                context.reset()
            }
        }
    //    put(experience: experience)
    }

    func updateExperience(_ experience: Experience, title: String, subtitle: String, date: Date = Date(), latitude: Double, longitude: Double, text: String?, audio: URL?, photo: URL?, video: URL?, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard !title.isEmpty else { return }
        experience.title = title
        experience.subtitle = subtitle
        experience.date = date
        experience.latitude = latitude
        experience.longitude = longitude
        experience.text = text
        experience.audio = audio
        experience.photo = photo
        experience.video = video
        
        context.perform {
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("Could not save after updating: \(error)")
                context.reset()
            }
        }
    //    put(experience: experience)
    }

    func deleteExperience(_ experience: Experience, context: NSManagedObjectContext = CoreDataStack.shared.mainContext, completion: @escaping (Error?) -> Void = { _ in }) {
    //    deleteFromServer(entry: entry) { (error) in
    //        if let _ = error {
    //            print("Will not delete local copy")
    //            completion(nil)
    //            return
    //        } else {
                context.perform {
                    do {
                        context.delete(experience)
                        try CoreDataStack.shared.save(context: context)
                    } catch {
                        print("Could not save after deleting: \(error)")
                        context.reset()
                        completion(error)
                    }
                }
                completion(nil)
            }
    //    }
    //}

    //func update(entry: JournalEntry, with representation: JournalEntryRepresentation) {
    //    entry.bodyText = representation.bodyText
    //    entry.mood = representation.mood
    //    entry.timestamp = representation.timestamp
    //    entry.title = representation.title
    //}
    //
    //func updateEntries(with representations: [JournalEntryRepresentation]) {
    //
    //    // Create a dictionary of Representations keyed by their UUID
    //      // filter out entries with no UUID
    //    let entriesWithID = representations.filter({ $0.identifier != nil })
    //      // create array of just the UUIDs (string form)
    //    let identifiersToFetch = entriesWithID.compactMap({ $0.identifier })
    //      // creates the dictionary
    //    let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
    //
    //    var entriesToCreate = representationsByID   // holds all entries now, but will be whittled down
    //
    //    let fetchRequest: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
    //    fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
    //
    //    let context = CoreDataStack.shared.container.newBackgroundContext()
    //    context.perform {
    //        do {
    //            let existingEntries = try context.fetch(fetchRequest)
    //
    //            for entry in existingEntries {
    //                guard let id = entry.identifier, let representation = representationsByID[id] else { continue }
    //
    //                self.update(entry: entry, with: representation)
    //                entriesToCreate.removeValue(forKey: id)
    //                try CoreDataStack.shared.save(context: context)
    //            }
    //
    //            for representation in entriesToCreate.values {
    //                let _ = JournalEntry(representation: representation)
    //                try CoreDataStack.shared.save(context: context)
    //            }
    //        } catch {
    //            print("Error fetching tasks for UUIDs: \(error)")
    //        }
    //    }
    //}
}
