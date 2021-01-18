//
//  GlossaryItem.swift
//  FLPPD
//
//  Created by Vlad Konon on 02/07/18.
//  Copyright © 2018 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import CoreData

@objc (GlossaryItem)
class GlossaryItem: NSManagedObject {
    static func updateGlossary() {
        let fm = FileManager.default
        let rootPath = Bundle.main.bundlePath.appending("/Articles")
        guard let enumerator = fm.enumerator(atPath: rootPath) else {
            return
        }
        let context = CoreDataManager.shared.context
        for item in enumerator {
            if let path = item as? String{
                var isDir:ObjCBool = false
                let fullPath = rootPath.appending("/"+path)
                _ = fm.fileExists(atPath: fullPath, isDirectory: &isDir)
                if isDir.boolValue {
                    dprint(rootPath + " is dicrectory")
                    continue
                }
                // check if item exits
                let request:NSFetchRequest<GlossaryItem> = self.fetchRequest()
                request.predicate = NSPredicate(format: "filename == %@", path)
                request.fetchLimit = 1
                let result = try? context.fetch(request)
                if result != nil && result!.count != 0 {
                    continue
                }
                let componets = path.components(separatedBy: "/")
                if componets.count < 2 {
                    continue
                }
                let folder = componets[0..<componets.count-1].joined(separator: "/")
                let title = (componets.last! as NSString).deletingPathExtension
                
                let item = NSEntityDescription.insertNewObject(forEntityName: "GlossaryItem", into: context) as! GlossaryItem
                item.filename = path
                item.folder = folder
                item.title = title
            }
        }
        CoreDataManager.shared.saveContext()
    }
}
