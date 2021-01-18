//
//  Constants.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 3/2/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation

let kDeviceKey = "device_key"

extension ClientAPI{
  struct Constants{
    
    static let privacyUrl = "http://willggrd.wixsite.com/flppdapp/privacy-policy"
    //MARK - FLPPD API -
    static let apiScheme = "https"
    static let apiHost =  "flppdappdev.com"
    static let apiPath = "/api/v1/"

    static let apiBaseUrl = "https://flppdappdev.com"
  
    //UserDefaults
    
    static let authToken = "auth_token"
    static let userInfo = "user_info"
    
    
    struct FLPPDMethods {
      
      //properties
      static let properties = "properties"
      
      //Authentication
      static let login = "authenticate"
      static let signup = "signup"
      static let recover = "recover"
      static let password_restart = "password_resets/"
      static let verify = "verify"
      static let generate = "generate"
        static let apns = "apns"
    }
    
    //MARK  - FLPPD: Headers -
    struct FLPPDHeaders {
      static let Authorization = "Authorization"
    }
    
    //MARK - FLPPD: Properties Parameter keys -
    struct FLPPDPropertyKeys {
      static let idp = "id"
      static let price = "price"
      static let rehub_cost = "rehub_cost"
      static let arv = "arv"
      static let street = "street"
      static let city = "city"
      static let state = "state"
      static let zip_code = "zip_code"
      static let nbeds = "nbeds"
      static let nbath = "nbath"
      static let description = "description"
      static let sqft = "sqft"
      static let user = "user"
      static let defaultImage = "default_img_thumb"
      static let first_name = "first_name"
      static let last_name = "last_name"
      static let email = "email"
      static let avatar = "avatar"
      static let createdAt = "created_at_in_words"
      static let propertyType = "property_type_id" //1 rental or 2 flip
      static let pubDate = "pubDate"
      static let price_currency = "price_currency"
      static let arv_currency = "arv_currency"
    }
    
    //MARK: - FLPPD: Authenticaton parameter keys -
    
    struct FLPDDAuthKeys {
      static let auth_token = "auth_token"
      static let verify = "verified"
      static let email = "email"
      static let phoneNumber = "phone_number"
      static let pin = "pin"
        static let apns_device_token = "apns_device_token"
        static let fcm_device_token = "fcm_device_token"
        static let firebase_password = "firebase_password"
    }
    

  }
}
