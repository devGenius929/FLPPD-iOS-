//
//  Config.swift
//  FLPPD
//
//  Created by Vlad Konon on 02/04/18.
//  Copyright © 2018 New Centuri Properties LLC. All rights reserved.
//

import Foundation
fileprivate var _lastConfig:Config?
struct Config:Codable {
    static var current:Config? {
        get {
            if _lastConfig != nil{
                return _lastConfig
            }
            else {
                let ud = UserDefaults.standard
                guard let filestack_app_secrect = ud.string(forKey: "filestack_app_secrect"),
                    let filestack_api_key = ud.string(forKey: "filestack_api_key"),
                    let pubnub_publish_key = ud.string(forKey: "pubnub_publish_key"),
                    let pubnub_subscribe_key = ud.string(forKey: "pubnub_subscribe_key") else {
                        return nil
                }
                    
                _lastConfig = Config(filestack_app_secrect: filestack_app_secrect,
                                     filestack_api_key: filestack_api_key,
                                     pubnub_publish_key: pubnub_publish_key,
                                     pubnub_subscribe_key: pubnub_subscribe_key)
                return _lastConfig
            }
        }
        set(value) {
            _lastConfig = value
            let ud = UserDefaults.standard
            if let value = value {
                ud.set(value.filestack_app_secrect, forKey: "filestack_app_secrect")
                ud.set(value.filestack_api_key, forKey: "filestack_api_key")
                ud.set(value.pubnub_publish_key, forKey: "pubnub_publish_key")
                ud.set(value.pubnub_subscribe_key, forKey: "pubnub_subscribe_key")
            }
            else {
                ud.removeObject(forKey: "filestack_app_secrect")
                ud.removeObject(forKey: "filestack_api_key")
                ud.removeObject(forKey: "pubnub_publish_key")
                ud.removeObject(forKey: "pubnub_subscribe_key")
            }
            ud.synchronize()
        }
    }
    var filestack_app_secrect:String
    var filestack_api_key:String
    var pubnub_publish_key:String
    var pubnub_subscribe_key:String
}
