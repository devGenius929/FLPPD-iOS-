//
//  InstantMessage.swift
//  FLPPD
//
//  Created by Vlad Konon on 01/05/18.
//  Copyright © 2018 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import CoreData
import EasyMapping
import UIKit

enum kMessageState:Int16 {
    typealias RawValue = Int16
    case `default` = 0
    case sent
    case failToSend
    case recieved
}
let timeMultipler:Double = 10000000.0
let freshMessageTimeinterval:Double = 2.5

@objc(InstantMessage)
class InstantMessage:AbstractModel {
    internal var _datetime:Date? = nil

    public override static func objectMapping() -> EKManagedObjectMapping{
        return EKManagedObjectMapping(forEntityName: self.className, with: { (mapping) in
            mapping.mapProperties(from: [
                    "channel_id",
                    "image_url",
                    "message",
                    "message_id",
                    "sender_id",
                    "time"
                ])
            mapping.primaryKey = "message_id"
        })
    }
    
    class func instantMessage(text:String?,
         image:UIImage?,
         imageURL:String?,
         forUserID:Int,
         inChannel:String,
         inContext context:NSManagedObjectContext,
         saveContext:Bool = true) -> InstantMessage{
        let message = NSEntityDescription.insertNewObject(forEntityName: self.className, into: context) as! InstantMessage
        
        message.message = text
        message.image_url = imageURL
        message.sender_id = Int32(forUserID)
        message.channel_id = inChannel
        if let image = image {
            message.image = UIImageJPEGRepresentation(image, 0.8)
        }
        else if let imageURL = imageURL, let url = URL(string:imageURL), saveContext
        {
            DispatchQueue.global(qos: .default).async {
                if let data = try? Data(contentsOf: url) {
                    message.image = data
                    CoreDataManager.shared.saveContext()
                }
            }
        }
        message.message_id = UUID().uuidString
        message.state = kMessageState.default.rawValue
        message.updateTime()
        if saveContext {
            CoreDataManager.shared.saveContext()
        }
        return message
    }
    func updateTime(){
        let timeinterval = NSDate().timeIntervalSince1970 * timeMultipler
        self.time = Int64(timeinterval)
    }
    var datetime:Date {
        get {
            if let date = _datetime {
                return date
            }
            let ti = Double(self.time) / timeMultipler
            _datetime = Date(timeIntervalSince1970: ti)
            return _datetime!
        }
    }
    var isNew:Bool {
        get {
            return abs(Date().timeIntervalSince(self.datetime)) < freshMessageTimeinterval
        }
    }
    func loadImage(forImageView imageView:UIImageView) {
        if let image = image {
            imageView.image = UIImage(data: image)
            return
        }
        if let image_url = self.image_url, let url = URL(string:image_url){
            DispatchQueue.global(qos: .background).async {
                if let data = try? Data(contentsOf: url){
                    DispatchQueue.main.async {
                        self.image = data
                        imageView.image = UIImage(data: data)
                        try? self.managedObjectContext?.save()
                    }
                    
                }
            }
        }
    }
    // payload
    func payload() -> [String:Any] {
        var payload = [String:Any]()
        payload["channel"] = channel;
        var text = self.message ?? ""
        if text.isEmpty {
            text =  self.image_url == nil ? "empty" : "image" 
        }
        let title = self.sender?.full_name ??  "FLPPD"
        payload["aps"] = [
            "alert" : ["body" : text, "title":title],
            "sound" : "\"default\"",
            "badge" : "1"
        ]
        payload["pn_gcm"] = [
            "data" : [
                "title" : title,
                "message" : text,
                "channel": self.channel_id
            ]
        ]
        return payload
    }
    var stringRepresentation:String? {
        get {
            if let data = try? JSONSerialization.data(withJSONObject: self.payload(), options: JSONSerialization.WritingOptions.init(rawValue: 0)) {
                return String(data:data, encoding:.utf8)
            }
            return nil
        }
    }

}

extension InstantMessage {
    var own:Bool {
        get {
            if let currentid = ClientAPI.currentUser?.user_id {
                return sender_id == Int32(currentid)
            }
            return false
        }
    }
}
