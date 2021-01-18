//
//  CoreDataManager.swift
//  FLPPD
//
//  Created by Vlad Konon on 01/05/18.
//  Copyright © 2018 New Centuri Properties LLC. All rights reserved.
//


import Foundation
import CoreData
private let modelName = "FLPPD"

class CoreDataManager {
    func clearStore() {
        let entities = ["Channel", "ChatUser", "InstantMessage"]
        for name in entities {
            self.deleteEntity(name)
        }
        saveContext()
    }
    static var shared = CoreDataManager()
    static var temporary = CoreDataManager.init(temorary: true)
    var context:NSManagedObjectContext {
        get{
            return persistentContainer.viewContext
        }
    }
    init() {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        persistentContainer = container
    persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.viewContext.stalenessInterval = 0

    }
    init(temorary:Bool){
        let container = NSPersistentContainer(name: modelName)
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        persistentContainer = container;
    }
    var persistentContainer: NSPersistentContainer
    func saveContext () {
        DispatchQueue.main.async {
            let context = self.persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    //let nserror = error as NSError
                    //fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }

    }
    var childContext:NSManagedObjectContext {
        get{
            let child = NSManagedObjectContext(concurrencyType:.privateQueueConcurrencyType)
            child.parent = self.context;
            return child
        }
    }
    internal func deleteEntity(_ name:String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            dprint(error)
        }
    }
}
