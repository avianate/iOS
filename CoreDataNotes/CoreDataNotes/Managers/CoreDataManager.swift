//
//  CoreDataManager.swift
//  CoreDataNotes
//
//  Created by Nate Graham on 11/27/18.
//  Copyright © 2018 Nate Graham. All rights reserved.
//

import CoreData

// final because we don't intend for this to be subclassed
final class CoreDataManager {
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to find data model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to load data model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        
        let documentDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let persistentStoreURL = documentDirectoryURL.appendingPathComponent(storeName)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: nil)
        } catch {
            fatalError("Unable to add persistent store")
        }
        
        return persistentStoreCoordinator
    }()
}
