//
//  CoreDataStack.swift
//  Experiences
//
//  Created by Chad Rutherford on 2/14/20.
//  Copyright © 2020 Chad Rutherford. All rights reserved.
//

import CoreData
import Foundation

class CoreDataStack {
    static let shared = CoreDataStack()
    private init() { }
    
    lazy var container: NSPersistentContainer = {
        var container = NSPersistentContainer(name: "Experiences")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
            container.viewContext.automaticallyMergesChangesFromParent = true
        }
        return container
    }()
    
    var backgroundContext: NSManagedObjectContext {
        container.newBackgroundContext()
    }
    
    var mainContext: NSManagedObjectContext {
        container.viewContext
    }
    
    func save(_ context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        
        do {
            try context.save()
        } catch let saveError as NSError {
            error = saveError
        }
        
        if let error = error { throw error }
    }
}
