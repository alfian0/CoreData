//
//  CoreDataStack.swift
//  ToDo
//
//  Created by alfian0 on 12/16/17.
//  Copyright © 2017 alfian0. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack: NSObject {
    
    static let module = "ToDo"
    
    lazy var manageObjectModel: NSManagedObjectModel = {
        let URL = Bundle.main.url(forResource: CoreDataStack.module, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: URL)!
    }()
    
    lazy var applicationDocumentsDirectory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: manageObjectModel)
        let persistentStoreURL = applicationDocumentsDirectory.appendingPathComponent("\(CoreDataStack.module).sqlite")
        
        do {
            try coordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: persistentStoreURL,
                options: [
                    NSMigratePersistentStoresAutomaticallyOption: true,
                    NSInferMappingModelAutomaticallyOption: true
                ])
        } catch {
            
        }
        
        return coordinator
    }()
    
    private lazy var saveManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext.parent = saveManagedObjectContext
        
        return managedObjectContext
    }()
    
    func saveContext () {
        guard managedObjectContext.hasChanges || saveManagedObjectContext.hasChanges else { return }
        
        managedObjectContext.performAndWait {
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Error saving manage object context!")
            }
        }
        
        saveManagedObjectContext.performAndWait {
            do {
                try saveManagedObjectContext.save()
            } catch {
                fatalError("Error saving manage object context!")
            }
        }
    }
}
