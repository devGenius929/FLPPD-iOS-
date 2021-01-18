//
//  ChatController.swift
//  FLPPD
//
//  Created by Vlad Konon on 01/05/18.
//  Copyright © 2018 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import CoreData
import PubNub

struct ChatConst{
    static let conversationPrefix = "conversation"
    static let message_id = "message_id"
}

class ChatController:NSObject, PNObjectEventListener  {
    let user_id:Int32
    let context:NSManagedObjectContext
    let commonPresenceChannel = "user_presence_channel"
    func inboundChannel(forUserId id:Int32) -> String{
        return "user_\(id)_inbound"
    }
    internal var _client:PubNub? = nil
    var client: PubNub? {
        get {
            if _client != nil {
                return _client
            }
            guard let pubKey = Config.current?.pubnub_publish_key, let subKey = Config.current?.pubnub_subscribe_key else {
                return nil
            }
            let configuration = PNConfiguration(publishKey:   pubKey,
                                                subscribeKey: subKey)
            configuration.TLSEnabled = true
            configuration.uuid = "\(user_id)"
            configuration.stripMobilePayload = false
            configuration.presenceHeartbeatInterval = 60
            let client  =  PubNub.clientWithConfiguration(configuration)
            client.addListener(self)
            client.subscribeToChannels([self.inboundChannel(forUserId: user_id)], withPresence: false)
            _client = client
            return client
        }
    }

    init(forUser user_id:Int32, inContext context:NSManagedObjectContext) {
        self.user_id = user_id
        self.context = context
    }
    func joinToPresence() {
        client?.subscribeToChannels([commonPresenceChannel], withPresence: true)
    }
    func leavePresence() {
        client?.unsubscribeFromChannels([commonPresenceChannel], withPresence: true)
    }
    // add device id to personal channell
    func add(deviceToken:Data) {
        client?.addPushNotificationsOnChannels([inboundChannel(forUserId: user_id)], withDevicePushToken: deviceToken) { (result) in
            dprint("added token for inbound channel")
        }
    }
    func removePushToken(deviceToken:Data) {
        client?.removePushNotificationsFromChannels([inboundChannel(forUserId: user_id)], withDevicePushToken: deviceToken, andCompletion: nil)
    }
    // add messages to db
    func proccessMessage(_ message:PNMessageResult, saveContext:Bool = true){
        let data = message.data
        guard let content = data.message as? [String:Any] else {
            dprint("no content in message:\(message)")
            return
        }
        guard (content[ChatConst.message_id] as? String) != nil else {
            dprint("no message id for message:\(message)")
            return
        }
        let instantMessage = InstantMessage.object(withProperties: content, in: context)
        updateOrCreateChannelByLastMesssage(instantMessage)
        if saveContext && (instantMessage.isUpdated || instantMessage.isInserted) {
            CoreDataManager.shared.saveContext()
            
        }
    }
    static func channelName(forUsedIds ids:[Int32], withTopic topic:String) -> String{
        let sorted = ids.sorted() {$0 > $1}.map() {"user_"+String($0)}.joined(separator: "-")
        return [ChatConst.conversationPrefix, sorted, topic].joined(separator: "#")
    }
    func getUserIds(fromChannelId channel_id:String?) -> [Int32]? {
        // channel id format
        // conversation#user_id1-user_id2-...#topic_name
        guard let channel_id = channel_id, channel_id.hasPrefix(ChatConst.conversationPrefix) else {
            dprint("isn't conversation message")
            return nil
        }
        let components = channel_id.components(separatedBy: "#")
        guard components.count > 2  else {
            dprint("wrong channel id format")
            return nil
        }
        let users = components[1].components(separatedBy: "-")
        guard users.count >= 1 else {
            dprint("no users for channel")
            return nil
        }
        let user_ids = users.map({Int32($0.components(separatedBy: "_").last ?? "0") ?? 0})
        return user_ids
    }
    func updateOrCreateChannelByLastMesssage(_ message:InstantMessage, saveContext:Bool = true) {

       guard let channel_id = message.channel_id, channel_id.hasPrefix(ChatConst.conversationPrefix) else {
            dprint("isn't conversation message")
            return
        }
       let components = channel_id.components(separatedBy: "#")
        guard components.count > 2  else {
            dprint("wrong channel id format")
            return
        }
        guard var user_ids = getUserIds(fromChannelId: message.channel_id) else {
            return
        }
        let request:NSFetchRequest<Channel> = Channel.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", channel_id)

        if let result = try? context.fetch(request),  let channel = result.first {
            // if we have channel let try update recent message
            if updateRecentMessage(forChannel: channel, message: message) {
                if saveContext {
                    CoreDataManager.shared.saveContext()
                }
            }
            // all done
            return
        }
        // no channel - let create
        let channel = Channel(context: context)
        channel.id = channel_id
        channel.topic = components[2]
        channel.recentMessage = message
        let userRequest:NSFetchRequest<ChatUser> = ChatUser.fetchRequest()
        userRequest.predicate = NSPredicate(format: "user_id IN %@", user_ids)
        let result = try? context.fetch(userRequest)
        if result != nil{
                if result!.count == user_ids.count {
                    channel.users = NSOrderedSet(array: result!.sorted(){ $0.user_id > $1.user_id })
                user_ids.removeAll()
            }
                else {
                    let in_db = result!.map({$0.user_id})
                    user_ids = user_ids.filter({ !in_db.contains($0)})
            }
        }
        if user_ids.count > 0 {
            for id in user_ids {
                ClientAPI.default.getUserWithId(Int(id), completion: {(user, success) in
                    if let user = user {
                       let chatuser = self.createUserBy(user: user)
                        channel.addToUsers(chatuser)
                        try? self.context.save()
                    }
                })
            }
        }
        if saveContext {
            CoreDataManager.shared.saveContext()
        }
    }
    // result changed or not
    internal func updateRecentMessage(forChannel channel:Channel, message:InstantMessage) -> Bool{
        if let recentMessage = channel.recentMessage {
            if recentMessage.time < message.time {
                channel.recentMessage = message
                return true
            }
        }
        else {
            channel.recentMessage = message
            return true
        }
        return false
    }
    func publishMessage(forChannel channel:Channel, message:InstantMessage, context _context:NSManagedObjectContext? = nil){
        let context = _context ?? self.context
        let messageDict = message.serializedObject(in: context) as! [String:Any]
        let payload = message.payload()
        guard let channel_name1 = channel.id else {
            dprint("no channel id!")
            return
        }
        guard var users = channel.users?.array as? [ChatUser]
        else  {
            dprint("no users to send")
            return
        }
        if users.count == 0 {
            // try to extract users from channel's name
            guard let ids = getUserIds(fromChannelId: channel_name1) else {
                dprint("no users to send")
                return
            }
            for id in ids {
                let request:NSFetchRequest<ChatUser> = ChatUser.fetchRequest()
                request.predicate = NSPredicate(format: "user_id == %@", "\(id)")
                if let result = try? context.fetch(request), let user = result.first {
                    users.append(user)
                }
                else {
                    var dict = [AnyHashable:Any] ()
                    dict["avatar"] = ""
                    dict["full_name"] = "loading"
                    dict["user_id"] = id
                    let user = ChatUser.object(withProperties: dict, in: context)
                    users.append(user)
                    ClientAPI.default.getUserWithId(Int(id), completion: { (user, success) in
                        if let user = user {
                            self.createUserBy(user: user)
                            try? self.context.save()
                        }
                    })
                }
            }
            channel.addToUsers(NSOrderedSet(array: users))
            CoreDataManager.shared.saveContext()
            
        }
        let not_me = users.filter(){ $0.user_id != self.user_id}.sorted(){ $0.user_id > $1.user_id }
        guard not_me.count > 0 else {
            dprint("no users to send")
            return
        }
        // posted me
        channel.recentMessage = message
        let inbound_channels = not_me.map(){self.inboundChannel(forUserId: $0.user_id)}
        // sending to all users in chat except me with push notifications
        for in_channel in inbound_channels {
                self.client?.publish(messageDict, toChannel: in_channel, mobilePushPayload: payload, storeInHistory: true, withCompletion: { (status) in
                    if !status.isError {
                    }
                    else {
                        dprint("send error: \(status.errorData)")
                    }
                })
        }
        // send to channel for history
        self.client?.publish(messageDict, toChannel: channel_name1, storeInHistory: true) { (status) in
            if !status.isError {
                message.state = kMessageState.sent.rawValue
            }
            else {
                message.state = kMessageState.failToSend.rawValue
                dprint("send error: \(status.errorData)")
            }
            DispatchQueue.main.async {
                do{
                    try self.context.save()
                }
                catch let error {
                    dprint(error.localizedDescription)
                }
            }
        }
        
    }
    @discardableResult
    func createUserBy(user:User) -> ChatUser{
        var dict = [AnyHashable:Any] ()
        dict["avatar"] = user.avatar
        dict["full_name"] = user.fullName
        dict["user_id"] = user.user_id
        let chatUser = ChatUser.object(withProperties: dict, in: context)
        return chatUser
    }
    // history
    func history(forChannel channelId:String){
        //[_client historyForChannel:channel start:nil end:nil limit:200 reverse:NO includeTimeToken:YES withCompletion:
        client?.historyForChannel(channelId, start: nil, end: nil, limit: 50, includeTimeToken: true) { (result, status) in
            if let status = status, !status.isError {
                dprint("error:\(status)")
                return
            }
            guard let messages = result?.data.messages as? [[AnyHashable:Any]], messages.count > 0 else {
                return
            }
            let context = CoreDataManager.shared.context
            let request:NSFetchRequest<Channel> = Channel.fetchRequest()
            let channels = (try! context.fetch(request)).map({$0.id!})
            
            for info in messages {
                guard let message = info["message"] as? [AnyHashable:Any] else {
                    continue
                }
                let im = InstantMessage.object(withProperties: message , in: context)
                im.time = info["timetoken"] as! Int64
                im.state = kMessageState.recieved.rawValue
                // do not allow bad messages
                if im.channel_id == nil {
                    context.delete(im)
                }
                else if !channels.contains(im.channel_id!) {
                    self.updateOrCreateChannelByLastMesssage(im)
                }
            }
            CoreDataManager.shared.saveContext()
        }
    }
    // presence
    func setPresence(_ value:Bool) {
        if value {
            joinToPresence()
        }
        else {
            leavePresence()
        }
    }
    func updatePresence() {
        self.client?.hereNowForChannel(commonPresenceChannel) {[unowned self] (result, status) in
            if status == nil {
                if let uuids =  result?.data.uuids as? [[String:Any]] {
                    let ids = uuids.map({ $0["uuid"] as! String}).map({Int32($0)!})
                    DispatchQueue.main.async {
                        let request:NSFetchRequest<ChatUser> = ChatUser.fetchRequest()
                        request.predicate = NSPredicate(format: "user_id IN %@", ids)
                        if let result = try? self.context.fetch(request), result.count > 0 {
                            _ = result.map{ $0.presence = true}
                        }
                        let inverseRequest:NSFetchRequest<ChatUser> = ChatUser.fetchRequest()
                        inverseRequest.predicate = NSPredicate(format: "NOT (user_id  IN %@)", ids)
                        if let result = try? self.context.fetch(inverseRequest), result.count > 0 {
                            _ = result.map{ $0.presence = false}
                        }
                        if self.context.hasChanges {
                            try? self.context.save()
                        }
                    }
                    dprint("ids: \(ids)")
                }
            }
            else {
                dprint("update presence error:\(status!.debugDescription)")
            }
        }
    }
    func isUserHere(user:ChatUser, completion:@escaping (_ isPresent:Bool) -> Void){
        client?.whereNowUUID("\(user.user_id)") { (result, error) in
            if error == nil {
                if let data = result?.data, data.channels.count > 0 {
                    DispatchQueue.main.async {
                        user.presence = true
                        self.saveContext()
                        completion(true)
                    }
                    return
                }
            }
            else {
                print ("error user is here \(error!.debugDescription)" )
            }
            user.presence = false
            self.saveContext()
            completion(false)
        }
    }
    func proccessPresence(event: PNPresenceEventResult) {
        // Handle presence event event.data.presenceEvent (one of: join, leave, timeout, state-change).
        if event.data.presenceEvent != "state-change" {
            if let id = event.data.presence.uuid, let user_id = Int32(id), user_id != self.user_id {
                if let user = ChatUser.user(withId: user_id, inContext: context){
                    let presenceEvent =  event.data.presenceEvent
                    if  presenceEvent == "join" {
                        user.presence = true
                    }
                    else if presenceEvent == "timeout" || presenceEvent == "leave"{
                        user.presence = false
                    }
                    self.saveContext()
                }
            }
            dprint("\(event.data.presence.uuid ?? "no uuid") \"\(event.data.presenceEvent)'ed\"\n" +
                "at: \(event.data.presence.timetoken) on \(event.data.channel) " +
                "(Occupancy: \(event.data.presence.occupancy))");
        }
    }
    // listener
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        proccessMessage(message)
    }
    func client(_ client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        proccessPresence(event: event)
    }
    func client(_ client: PubNub, didReceive status: PNStatus) {
        dprint("status:\(status.debugDescription) ")
    }
    func saveContext(){
        DispatchQueue.main.async {
            if self.context.hasChanges {
                do {
                    try self.context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
}

