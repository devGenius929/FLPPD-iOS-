//
//  Channel.swift
//  FLPPD
//
//  Created by Vlad Konon on 01/05/18.
//  Copyright © 2018 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import CoreData
import EasyMapping

@objc(Channel)
class Channel:AbstractModel {
    public override static func objectMapping() -> EKManagedObjectMapping{
        return EKManagedObjectMapping(forEntityName: self.className, with: { (mapping) in
            mapping.mapProperties(from: [
                "id",
                "topic"
                ])
            mapping.primaryKey = "id"
            mapping.hasMany(ChatUser.self, forKeyPath: "users")
            mapping.hasOne(InstantMessage.self, forKeyPath: "recentMessage")
        })
    }
    public static func channel(withId channel_id:String, topic:String? = nil, users:[ChatUser]? = nil, inContext context:NSManagedObjectContext) -> Channel {
        let request:NSFetchRequest<Channel> = Channel.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", channel_id)
        guard let results = try? context.fetch(request), let channel = results.first else {
            let channel = self.object(withProperties: ["id":channel_id], in: context)
            if let users = users {
                channel.addToUsers(NSOrderedSet(array: users))
            }
            channel.topic =  topic
            return channel
        }
        return channel
    }
}
