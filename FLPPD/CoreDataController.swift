//
//  CoreDataHelper.swift
//  FLPPD
//
//  Created by PC on 5/20/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import CoreData

class CoreDataController:NSObject{
  // MARK: - Core Data stack
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "FLPPD")
    //let url = NSPersistentContainer.defaultDirectoryURL()
    //let description = NSPersistentStoreDescription(url: url)
    //description.shouldAddStoreAsynchronously = true
    //container.persistentStoreDescriptions = [description]
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  func saveContext () {
    persistentContainer.performBackgroundTask({ (context) in
      // save the context
      do {
        try context.save()
      } catch {
        // handle error
      }
    })
    }
  func saveMainContext(){
    do{
      try persistentContainer.viewContext.save()
    }catch{
      
    }
  }
}
