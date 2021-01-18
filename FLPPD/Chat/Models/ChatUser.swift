//
//  ChatUser.swift
//  FLPPD
//
//  Created by Vlad Konon on 01/05/18.
//  Copyright © 2018 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import CoreData
import EasyMapping

@objc(ChatUser)
class ChatUser:AbstractModel {
    public override static func objectMapping() -> EKManagedObjectMapping{
        return EKManagedObjectMapping(forEntityName: self.className, with: { (mapping) in
            mapping.mapProperties(from: [
                "user_id",
                "avatar",
                "full_name"
                ])
            mapping.primaryKey = "user_id"
        })
    }
    static func user(withId id:Any, inContext context:NSManagedObjectContext) -> ChatUser?{
        let request:NSFetchRequest<ChatUser> = ChatUser.fetchRequest()
        request.predicate = NSPredicate(format: "user_id == %@", "\(id)")
        guard let results = try? context.fetch(request), let user = results.first else {
            return nil
        }
        return user
    }
    func loadAvatar(forImageView imageView:UIImageView) {
        if let image = avatar_image {
            imageView.image = UIImage(data: image)
            return
        }
        guard let _ = self.avatar else {
            return
        }
        if let image_url = self.avatar, let url = URL(string:image_url){
            DispatchQueue.global(qos: .background).async {
                if let data = try? Data(contentsOf: url){
                    DispatchQueue.main.async {
                        self.avatar_image = data
                        imageView.image = UIImage(data: data)
                        try? self.managedObjectContext?.save()
                    }
                    
                }
            }
        }
    }
}
