//
//  LibCoreData.swift
//  Library
//
//  Created by Vanessa Aguilar on 11/24/20.
//  Copyright © 2020 Personal Team. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
    private let modelName: String
    
    init(modelName:String){
        self.modelName = modelName
    }
    

    
// MARK: - Core Data stack

    //computed property that is returning self.persistentContainer.viewContext = which is apart of the consistent container
    //Everything that is done with core data is done using core managed ocntect, when you want to create, delete, retrieve .. an entity you use this managed context : this is our access point for the data base , this will all be done with the managed context variable
    //lazy = dont bother creating this item until ive tried to use tihs
        lazy var managedContext : NSManagedObjectContext = {
            return self.persistentContainer.viewContext
        }()

    
        lazy var persistentContainer: NSPersistentContainer = {
            /*
             The persistent container for the application. This implementation
             creates and returns a container, having loaded the store for the
             application to it. This property is optional since there are legitimate
             error conditions that could cause the creation of the store to fail.
            */
            let container = NSPersistentContainer(name: self.modelName)
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

