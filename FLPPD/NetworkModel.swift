//
//  NetworkModel.swift
//  FLPPD
//
//  Created by PC on 9/26/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import RxSwift

struct Contact{
  let name:String
  let userId:Int
  var avatar:UIImage?
  let isPendingRequest:Bool
    let user:User
}

class Network:Decodable{
  var friends:[User]
}

struct Device:Codable {
    var device_id: String
    var token: String
}
public struct UserAndMutuals: Codable {
    let user:User
    let mutualFriends:Int
}
public struct User: Codable{
  var first_name:String
  var last_name:String
    var phone_number:String?
  var about:String?
  var avatar:String
  var created_at:String
  var email:String
  var user_id:Int
    var devices:[Device]?
    var  role:String?
    var city: String?
    var state: String?
    var areas: String?
    var rank: String?
    var hauses_sold: Int?
    var friend:Bool?
    
    var fullName:String {
        get{
            return first_name.capitalized + " " + last_name.capitalized
        }
    }
    init(first_name: String, last_name: String, phone_number:String,  about: String, avatar:  String, created_at: String, email: String, user_id: Int, devices:[Device],
         role:String? = nil,
        city: String? = nil,
        state: String? = nil,
        areas: String? = nil,
        rank: String? = nil,
        hauses_sold: Int? = nil){
        self.first_name = first_name
        self.last_name = last_name
        self.about = about
        self.avatar = avatar
        self.created_at = created_at
        self.email = email
        self.user_id = user_id
        self.devices = devices
        self.phone_number = phone_number
        self.role = role
        self.city = city
        self.state = state
        self.areas = areas
        self.rank = rank
        self.hauses_sold = hauses_sold
        self.friend = false
    }
    
    init(dict:[String:Any]) {
        first_name = (dict["first_name"] as? String) ?? ""
        last_name = (dict["last_name"] as? String) ?? ""
        about = (dict["about"] as? String) ?? ""
        avatar = (dict["avatar"] as? String) ?? ""
        created_at = (dict["created_at"] as? String) ?? ""
        email = (dict["email"] as? String) ?? ""
        user_id = (dict["user_id"] as? Int) ?? 0
        phone_number = (dict["phone_number"] as? String) ?? ""
        self.role = (dict["role"] as? String) ?? "Undefined"
        self.city = (dict["city"] as? String)
        self.state = (dict["state"] as? String)
        self.areas = (dict["areas"] as? String) ?? ""
            self.rank = (dict["rank"] as? String) ?? ""
        self.hauses_sold = (dict["hauses_sold"] as? Int) ?? 0
        self.friend = (dict["friend"] as? Bool) ?? false
        guard let devs = dict["devices"]  as? [[String:AnyObject]] else {
            devices = [Device]()
            return
        }
        devices = devs.map() {
            Device(device_id: $0.valueForKeyWithDefault("device_id"),
                       token: $0.valueForKeyWithDefault("token")) }
    }
    func getDict() -> [String:Any] {
        var result = [String:Any]()
        result["first_name"] = self.first_name
        result["last_name"] = self.last_name
        result["about"] = self.about
        result["avatar"] = self.avatar
        result["created_at"] = self.created_at
        result["email"] = self.email
        result["user_id"] = self.user_id
        result["phone_number"] = self.phone_number
        result["role"] = role
        result["city"] = city
        result["state"] = state
        result["areas"] = areas
        result["rank"] = rank
        result["hauses_sold"] = hauses_sold
        return result
    }
}
func createUserObservable() -> Observable<User>? {
    let header = [
        "Authorization": ClientAPI.default.authToken,
        "Accept": "application/json"
    ]
    let urlString = (ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + "users")
    guard let url = URL(string:urlString),let urlRequest = try? URLRequest(url: url, method: .get, headers: header) else{
        return nil
    }
    
    return URLSession.shared.rx.data(request: urlRequest).flatMap { (json:Data) -> Observable<User> in
        let decoder = JSONDecoder()
        guard let users = try? decoder.decode(Array<User>.self, from: json) else
        {
            return Observable.empty()
        }
        let resultObservable:[Observable<User>] = users.map() { Observable.just($0) }
        return Observable.concat(resultObservable)
    }
}
func createNetworkObservable()->Observable<Contact>?{
  let header = [
    "Authorization": ClientAPI.default.authToken,
    "Accept": "application/json"
  ]
  let urlString = (ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + "network")
  guard let url = URL(string:urlString),let urlRequest = try? URLRequest(url: url, method: .get, headers: header) else{
    return nil
  }
  return URLSession.shared.rx.data(request:urlRequest).flatMap({(json:Data)->Observable<(Contact,Data)> in
    let decoder = JSONDecoder()
    guard let users = try? decoder.decode(Array<UserAndMutuals>.self, from: json) else{
      return Observable.empty()
    }
    var returnObservable:[Observable<(Contact,Data)>] = []
    for user in users{
        let friend = user.user
      let name = friend.first_name + " " + friend.last_name
        
        let contact = Contact(name: name, userId: friend.user_id, avatar: nil,isPendingRequest:false, user: friend)
      let avatarURL = URL(string:friend.avatar)!
      let avatarRequest = URLRequest(url: avatarURL)
      let avatarObservable = URLSession.shared.rx.data(request: avatarRequest)
        
      returnObservable.append(Observable.combineLatest(Observable.just(contact),avatarObservable))
    }
    return Observable.concat(returnObservable)
  }).map({response in
    guard let image = UIImage(data:response.1) else{
      return response.0
    }
    var contact = response.0
    contact.avatar = image
    return contact
  })
}

enum SearchError:Error{
  case generic
}

func createWaitingFriendRequestObservable()->Observable<Contact>?{
  let header = [
    "Authorization": ClientAPI.default.authToken,
    "Accept": "application/json"
  ]
  let urlString = (ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + "waitingconnections").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
  guard let url = URL(string:urlString),let urlRequest = try? URLRequest(url: url, method: .get, headers: header) else{
    return nil
  }
  return URLSession.shared.rx.data(request: urlRequest).flatMap({(json:Data)->Observable<(Contact,Data)> in
    let decoder = JSONDecoder()
    guard let network = try? decoder.decode(Array<UserAndMutuals>.self, from: json) else{
      return Observable.empty()
    }
    var returnObservable:[Observable<(Contact,Data)>] = []
    for user in network{
        let friend = user.user
      let name = friend.first_name + " " + friend.last_name
        let contact = Contact(name: name, userId: friend.user_id, avatar: nil,isPendingRequest:true, user:friend)
      let avatarURL = URL(string:friend.avatar)!
      let avatarRequest = URLRequest(url: avatarURL)
      let avatarObservable = URLSession.shared.rx.data(request: avatarRequest)
      returnObservable.append(Observable.combineLatest(Observable.just(contact),avatarObservable))
    }
    return Observable.concat(returnObservable)
  }).map({response in
    guard let image = UIImage(data:response.1) else{
      return response.0
    }
    var contact = response.0
    contact.avatar = image
    return contact
  })
}

func createPendingFriendRequestObservable()->Observable<Contact>?{
  let header = [
    "Authorization": ClientAPI.default.authToken,
    "Accept": "application/json"
  ]
  let urlString = (ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + "pendingconnections").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
  guard let url = URL(string:urlString),let urlRequest = try? URLRequest(url: url, method: .get, headers: header) else{
    return nil
  }
  return URLSession.shared.rx.data(request: urlRequest).flatMap({(json:Data)->Observable<(Contact,Data)> in
    let decoder = JSONDecoder()
    guard let users = try? decoder.decode(Array<UserAndMutuals>.self, from: json) else{
      return Observable.empty()
    }
    var returnObservable:[Observable<(Contact,Data)>] = []
    for user in users{
        let friend = user.user
      let name = friend.first_name + " " + friend.last_name
        let contact = Contact(name: name, userId: friend.user_id, avatar: nil,isPendingRequest:true, user:friend)
      let avatarURL = URL(string:friend.avatar)!
      let avatarRequest = URLRequest(url: avatarURL)
      let avatarObservable = URLSession.shared.rx.data(request: avatarRequest)
      returnObservable.append(Observable.combineLatest(Observable.just(contact),avatarObservable))
    }
    return Observable.concat(returnObservable)
  }).map({response in
    guard let image = UIImage(data:response.1) else{
      return response.0
    }
    var contact = response.0
    contact.avatar = image
    return contact
  })
}

func createAcceptFriendRequestObservable(_ id:Int)->Observable<(response: HTTPURLResponse, data: Data)>{
  let header = [
    "Authorization": ClientAPI.default.authToken,
    "Accept": "application/json"
  ]
  let urlString = (ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + "network/"+String(id)+"/accept").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
  let url = URL(string:urlString)!
  let urlRequest = try! URLRequest(url: url, method: .put, headers: header)
  return URLSession.shared.rx.response(request: urlRequest)
}
func createRejectFriendRequestObservable(_ id:Int)->Observable<(response: HTTPURLResponse, data: Data)>{
  let header = [
    "Authorization": ClientAPI.default.authToken,
    "Accept": "application/json"
  ]
  let urlString = (ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + "network/"+String(id)).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
  let url = URL(string:urlString)!
  let urlRequest = try! URLRequest(url: url, method: .delete, headers: header)
  return URLSession.shared.rx.response(request: urlRequest)
}
func createAddFriendObservable(_ id:Int)->Observable<(response: HTTPURLResponse, data: Data)>{
  let header = [
    "Authorization": ClientAPI.default.authToken,
    "Accept": "application/json"
  ]
  let urlString = (ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + "network?user_id="+String(id)).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
  let url = URL(string:urlString)!
  let urlRequest = try! URLRequest(url: url, method: .post, headers: header)
  return URLSession.shared.rx.response(request: urlRequest)
}
func createUnfriendObservable(_ id:Int)->Observable<(response: HTTPURLResponse, data: Data)>{
  let header = [
    "Authorization": ClientAPI.default.authToken,
    "Accept": "application/json"
  ]
  let urlString = (ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + "network/"+String(id)).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
  let url = URL(string:urlString)!
  let urlRequest = try! URLRequest(url: url, method: .delete, headers: header)
  return URLSession.shared.rx.response(request: urlRequest)
}
func createSearchContactsObservable(_ searchTerm:String)->Observable<Contact?>?{
  let header = [
    "Authorization": ClientAPI.default.authToken,
    "Accept": "application/json"
  ]
  let urlString = (ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + "search/users?search="+searchTerm).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
  let url = URL(string:urlString)!
  guard let urlRequest = try? URLRequest(url: url, method: .get, headers: header) else{
    return nil
  }
  
  return URLSession.shared.rx.data(request:urlRequest).flatMap({(json:Data)->Observable<(Contact,Data)> in
    let decoder = JSONDecoder()
    guard let result = try? decoder.decode(Array<User>.self, from: json),!result.isEmpty else{
      return Observable.error(SearchError.generic)
    }
    var returnObservable:[Observable<(Contact,Data)>] = []
    for user in result{
      let name = user.first_name + " " + user.last_name
        let contact = Contact(name: name, userId: user.user_id, avatar: nil,isPendingRequest:false, user:user)
      let avatarURL = URL(string:user.avatar)!
      let avatarRequest = URLRequest(url: avatarURL)
      let avatarObservable = URLSession.shared.rx.data(request: avatarRequest)
      returnObservable.append(Observable.combineLatest(Observable.just(contact),avatarObservable))
    }
    return Observable.concat(returnObservable)
  }).map({response in
    guard let image = UIImage(data:response.1) else{
      return response.0
    }
    var contact = response.0
    contact.avatar = image
    return contact
  })
}

func createPropertyListing(property:ListingProperty)->Observable<String?>?{
  let encoder = JSONEncoder()
  guard let json = try? encoder.encode(property) else{
    return nil
  }
  let header = [
    "Authorization": ClientAPI.default.authToken,
    "Content-Type": "application/json"
  ]
  let urlString = (ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + "properties").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
  let url = URL(string:urlString)!
  guard var request = try? URLRequest(url: url, method: .post, headers: header) else{
    return nil
  }
  request.httpBody = json
  return URLSession.shared.rx.response(request: request).flatMap({(response)->Observable<String?> in
    if response.0.statusCode == 201 {
        if property.property.PropertyListing_id == 2 {
            InAppPurchasesController.default.consumePlatinum()
        }
      return Observable.just(nil)
    }
    let message = String.init(data: response.1, encoding: .utf8)
    return Observable.just(message)
    })
}

func updateProperty(property_id:Int, property:ListingProperty, consumePlatinum:Bool)->Observable<String?>?{
    let encoder = JSONEncoder()
    guard let json = try? encoder.encode(property) else{
        return nil
    }
    let header = [
        "Authorization": ClientAPI.default.authToken,
        "Content-Type": "application/json"
    ]
    let urlString = (ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + "properties/\(property_id)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let url = URL(string:urlString)!
    guard var request = try? URLRequest(url: url, method: .put, headers: header) else{
        return nil
    }
    request.httpBody = json
    return URLSession.shared.rx.response(request: request).flatMap({(response)->Observable<String?> in
        if response.0.statusCode == 201 {
            if consumePlatinum {
                InAppPurchasesController.default.consumePlatinum()
            }
            return Observable.just(nil)
        }
        let message = String.init(data: response.1, encoding: .utf8)
        return Observable.just(message)
    })
}
