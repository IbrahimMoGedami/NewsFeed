//
//  CoreDataStack.swift
//  NewsfeedMVVM
//
//  Created by Ibrahim Mo Gedami on 30.07.2020.
//  Copyright © 2020 Ibrahim Mo Gedami. All rights reserved.
//

import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "NewsfeedMVVM")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
