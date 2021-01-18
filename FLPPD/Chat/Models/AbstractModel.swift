//
//  AbstractModel.swift
//  FLPPD
//
//  Created by Vlad Konon on 11/18/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//


// this class is only for referense 
import Foundation
import EasyMapping
import CoreData

@objc(AbstractModel)
class AbstractModel: EKManagedObjectModel {
    static var className: String {
        return NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
    }


 /*
    public override static func objectMapping() -> EKManagedObjectMapping{
        return EKManagedObjectMapping(forEntityName: NSStringFromClass(self.classForCoder()), with: { (mapping) in
            mapping.mapProperties(from: ["id":"id"])
            mapping.primaryKey = "id"
        })
    }
 */
 }
