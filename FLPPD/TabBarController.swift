//
//  TabBarController.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 1/19/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import CoreData

class TabBarController: UITabBarController, NSFetchedResultsControllerDelegate {
  
    var fetchedResultsController:NSFetchedResultsController<InstantMessage>! {
        didSet {
            fetchedResultsController.delegate = self
            do{
                try fetchedResultsController.performFetch()
                self.updateMessagesBadge()
            }
            catch{
                    dprint(error.localizedDescription)
            }
        }
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchedResultsController = getResultController()
  }
    private func getResultController() -> NSFetchedResultsController<InstantMessage> {
        let request:NSFetchRequest<InstantMessage> = InstantMessage.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "channel_id", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        request.predicate = NSPredicate(format: "viewed == NO")
        request.fetchLimit = 100
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.shared.context, sectionNameKeyPath: "channel_id", cacheName: nil)
        
        return controller;
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let _ = indexPath {
            updateMessagesBadge()
        }
        else if let _ = newIndexPath {
            updateMessagesBadge()
        }
    }
    func updateMessagesBadge() {
        if let button = self.tabBar.items?[3] {
            let count = fetchedResultsController.sections?.count ?? 0
            button.badgeValue = count == 0 ? nil : count <= 99 ? "\(count)" : "99+"
        }
    }
}
