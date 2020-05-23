//
//  CoreDataStack.swift
//  Experiences
//
//  Created by Joe on 5/23/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Experiences")
        container.loadPersistentStores { (_, error)  in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
                
            }
        }
        return container
    }()
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    // Saves content to Core Data
    func save() {
        let moc = CoreDataStack.shared.mainContext
        do {
          try moc.save()
        } catch {
            print("There was a problem saving: \(error)")
        }
    }
}
