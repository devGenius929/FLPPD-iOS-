//
//  Client.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 3/2/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import Firebase

private typealias JSONObject = [String: AnyObject]


final class ClientAPI: NSObject{
  
  override init(){
    super.init()
  }
    var hasAuthKey:Bool {
        return !self.authToken.isEmpty
    }
    var authToken:String {
        get{
            return UserDefaults.standard.string(forKey: ClientAPI.Constants.FLPDDAuthKeys.auth_token) ?? ""
        }
        set (value){
                UserDefaults.standard.set(value, forKey: ClientAPI.Constants.FLPDDAuthKeys.auth_token)
        }
    }
    var authHeader:[String:String] {
        get {
            return [
                "Authorization": self.authToken,
                "Accept": "application/json"
            ]
        }
    }
    static let defautPropertImageUrl:URL = Bundle.main.url(forResource: "def_property", withExtension: "jpg")!
    /*
  func taskForGETImage(_ filePath: String, completionHandlerForImage: @escaping(_ imageData: DataResponse<Image>?, _ error: NSError?) -> Void){
    
    /* build the URL */
    let baseURL = URL(string: ClientAPI.Constants.imageBaseURL)!
    let url = baseURL.appendingPathComponent(filePath)
    let request = URLRequest(url: url)

    /* make the request */
    Alamofire.request(request.url!).responseImage { response in
      func sendError(_ error: String) {
        dprint(error)
        let userInfo = [NSLocalizedDescriptionKey : error]
        completionHandlerForImage(nil, NSError(domain: "taskForGETImage", code: 1, userInfo: userInfo))
      }
      
      /* GUARD: Was there an error? */
      guard (response.error == nil) else {
        sendError("There was an error with your request: \(String(describing: response.error))")
        return
      }
      
      /* GUARD: Did we get a successful 2XX response? */
      guard let statusCode = response.response?.statusCode, statusCode >= 200 && statusCode <= 299 else {
        sendError("Your request returned a status code other than 2xx!")
        return
      }
      
      /* 5/6. Parse the data and use the data (happens in completion handler) */
      completionHandlerForImage(response, nil)
    }
  }
 */
  
  //avatar
  func taskForGETAvatar(_ url: String, completionHandlerForImage: @escaping(_ imageData: DataResponse<Image>?, _ error: NSError?) -> Void){
    
    /* build the URL */
    
    /* make the request */
    Alamofire.request(url).responseImage { response in
      func sendError(_ error: String) {
        let userInfo = [NSLocalizedDescriptionKey : error]
        completionHandlerForImage(nil, NSError(domain: "taskForGETAvatar", code: (response.response?.statusCode)!, userInfo: userInfo))
      }
      
      /* GUARD: Was there an error? */
      guard (response.error == nil) else {
        sendError("There was an error with your request: \(String(describing: response.error))")
        return
      }
      
      /* GUARD: Did we get a successful 2XX response? */
      guard let statusCode = response.response?.statusCode, statusCode >= 200 && statusCode <= 299 else {
        sendError("Your request returned a status code other than 2xx!")
        return
      }
      
      /* 5/6. Parse the data and use the data (happens in completion handler) */
      completionHandlerForImage(response, nil)
    }
  }
  
  
  // Perform a request on an API endpoint using Alamofire.
  
  //MARK: GET
  func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void){
    
    let request = NSMutableURLRequest(url: owappURLFromParameters(parameters, withPathExtension: method))
    
    let headers: HTTPHeaders = [
      "Authorization": ClientAPI.default.authToken,
      "Accept": "application/json"
        
    ]
    
    /* make the resques */
   Alamofire.request(request.url!, method: .get, parameters: parameters, headers: headers).responseJSON { response in
      
      func sendError(_ error: String) {
        let userInfo = [NSLocalizedDescriptionKey : error]
        
        if let statusCode = response.response?.statusCode {
          completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: statusCode, userInfo: userInfo))
        }else{
          completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1009, userInfo: userInfo))
        }
        
        
      }
      /* GUARD: was there an error? */
      guard (response.error == nil) else{
        sendError("There was an error with your request, \(String(describing: response.error?.localizedDescription ?? " "))")
        return
      }
      
      /* GUARD: Did we get a 401 response? */
      guard let statusCode401 = response.response?.statusCode, statusCode401 != 401 else{
        sendError("Your request returned a status code other than 401")
        return
      }
      
      /* GUARD: Did we get a successful 2XX response */
      guard let statusCode200 = response.response?.statusCode, statusCode200 >= 200 && statusCode200 <= 299 else{
        sendError("Your request returned a status code other than 2xx!")
        return
      }
      
      /* GUARD: Was there any data returned? */
      guard let data = response.data else{
        sendError("No data was returned")
        return
      }
      
      /* 5/6. Parse the data and use the data (happens in completion handler) */
      self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
      
    }
    
  }
  
  //MARK: POST
  
  //MARK: - PLEASE VALIDATE STATUS CODE ERROR (LIKE 401) AND SEND 1099 IN CASE THE CONNECTION APPEARS TO BE OFFLINE
  func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> Void {
    
    let request = NSMutableURLRequest(url: owappURLFromParameters(parameters, withPathExtension: method))
    
    
    let headers: HTTPHeaders = [
      "Authorization": ClientAPI.default.authToken,
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Charset": "UTF-8"
    ]
    
    Alamofire.request(request.url!,
                      method: .post,
                      parameters: parameters,
                      encoding: JSONEncoding.default,
                      headers: headers)
        .responseJSON { response in
      
      func sendError(_ error: String) {
        dprint(error)
        let userInfo = [NSLocalizedDescriptionKey : error]
        completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
      }
      
      /* GUARD: was there an error? */
      guard (response.error == nil) else{
        sendError("There was an error with your request: \(String(describing: response.error))")
        return
      }
      
      /* GUARD: Did we get a 401 response? */
      guard let statusCode401 = response.response?.statusCode, statusCode401 != 401 else{
        sendError("Your request returned a status code other than 401")
        return
      }
      
      /* GUARD: Did we get a successful 2XX response */
      guard let statusCode200 = response.response?.statusCode, statusCode200 >= 200 && statusCode200 <= 299 else{
        sendError("Your request returned a status code other than 2xx!")
        return
      }
      
      /* GUARD: Was there any data returned? */
      guard let data = response.data else{
        sendError("No data was returned")
        return
      }
      
      /* 5/6. Parse the data and use the data (happens in completion handler) */
      self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
      
    }
    
  }
  
  //POST without token
  func taskForPOSTMethodWithoutToken(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> Void {
    
    let request = NSMutableURLRequest(url: owappURLFromParameters(parameters, withPathExtension: method))
    
    let headers: HTTPHeaders = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Charset": "UTF-8"
    ]
    
    Alamofire.request(request.url!,
                      method: .post,
                      parameters: parameters,
                      encoding: JSONEncoding.default,
                      headers: headers).responseJSON { response in
      
      func sendError(_ error: String, data: Data?) {
        dprint(error)
        var userInfo = [NSLocalizedDescriptionKey : error]
        if let data = data {
            if  let message = String(data:data, encoding:.utf8) {
                dprint("error data:" + message)
                userInfo[NSLocalizedDescriptionKey] = message
            }
        }
        completionHandlerForPOST(self.converDataErrorWith(data!), NSError(domain: "taskForPOSTMethodWithoutToken", code: 1, userInfo: userInfo))
      }
      
      /* GUARD: was there an error? */
      guard (response.error == nil) else{
        sendError("There was an error with your request: \(String(describing: response.error))", data: response.data)
        return
      }
      
      /* GUARD: Did we get a 401 response? */
      guard let statusCode401 = response.response?.statusCode, statusCode401 != 401 else{
        sendError("Your request returned a status code 401", data: response.data)
        return
      }
      
      /* GUARD: Did we get a successful 2XX response */
      guard let statusCode200 = response.response?.statusCode, statusCode200 >= 200 && statusCode200 <= 299 else{
        sendError("Your request returned a status code other than 2xx!", data: response.data)

        return
      }
      
      /* GUARD: Was there any data returned? */
      guard let data = response.data else{
        sendError("No data was returned", data: nil)
        return
      }
      
      /* 5/6. Parse the data and use the data (happens in completion handler) */
      self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
      
    }
    
  }
  
  //PUT without token
  func taskForPUTMethodWithoutToken(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPUT: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> Void {
    
    let request = NSMutableURLRequest(url: owappURLFromParameters(parameters, withPathExtension: method))
    
    let headers: HTTPHeaders = [
      "Accept": "application/json",
      "Content-Type":"application/json",
      "Charset": "UTF-8"
    ]
    
    Alamofire.request(request.url!, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
      
      func sendError(_ error: String, data: Data?) {
        dprint(error)
        let userInfo = [NSLocalizedDescriptionKey : error]
        completionHandlerForPUT(self.converDataErrorWith(data!), NSError(domain: "taskForPUTMethodWithoutToken", code: 1, userInfo: userInfo))
      }
      
      /* GUARD: was there an error? */
      guard (response.error == nil) else{
        sendError("There was an error with your request: \(String(describing: response.error))", data: response.data)
        return
      }
      
      /* GUARD: Did we get a 401 response? */
      guard let statusCode401 = response.response?.statusCode, statusCode401 != 401 else{
        sendError("Your request returned a status code 401", data: response.data)
        return
      }
      
      /* GUARD: Did we get a successful 2XX response */
      guard let statusCode200 = response.response?.statusCode, statusCode200 >= 200 && statusCode200 <= 299 else{
        sendError("Your request returned a status code other than 2xx!", data: response.data)
        return
      }
      
      /* GUARD: Was there any data returned? */
      guard let data = response.data else{
        sendError("No data was returned", data: nil)
        return
      }
      
      /* 5/6. Parse the data and use the data (happens in completion handler) */
      self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPUT)
      
    }
    
  }
  
  
  //MARK: helper methods
  
  // create a URL from parameters
  private func owappURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
    
    var components = URLComponents()
    components.scheme = ClientAPI.Constants.apiScheme
    components.host = ClientAPI.Constants.apiHost
    //components.port = Client.Constants.apiPort
    components.path = ClientAPI.Constants.apiPath + (withPathExtension ?? "")
    
    return components.url!
  }
  
  // given raw JSON, return a usable Foundation object
  private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
    
    var parsedResult: AnyObject! = nil
    do {
      parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
    } catch {
      let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
      completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
    }
    
    completionHandlerForConvertData(parsedResult, nil)
  }
  
  private func converDataErrorWith(_ data: Data) -> AnyObject?{
    var parsedResult: AnyObject! = nil
    do {
      parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
    } catch {
      dprint("JSON Processing Failed")
    }
    return parsedResult
  }
  
    public func sendDeviceToken(){
        if let deviceTokenString = UserDefaults.standard.string(forKey: ClientAPI.Constants.FLPDDAuthKeys.fcm_device_token) {
            // Messaging.messaging().apnsToken = deviceTokenString.data(using: .utf8)
            var dev_id:String? = KeychainWrapper.standard.string(forKey: kDeviceKey)
            if dev_id == nil {
                dev_id = UUID().uuidString
                KeychainWrapper.standard.set(dev_id!, forKey: kDeviceKey)
            }

            if ClientAPI.default.hasAuthKey {
                ClientAPI.default.taskForPOSTMethod("apns",
                                                          parameters: ["device_id":dev_id! as AnyObject,
                                                                       "device_token": deviceTokenString as AnyObject],
                                                          jsonBody:"{}") { (obj, error) in
                                                            if error != nil {
                                                                dprint("APNS error:\(error!.description)")
                                                            }
                }
            }
        }
    }
    
    func loadUsers(_ completion: @escaping (_ users:[User]?, _ success :Bool) -> Void){
        let header = [
            "Authorization": self.authToken,
            "Accept": "application/json"
        ]
        let urlString = (ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + "users")
        guard let url = URL(string:urlString), let urlRequest = try? URLRequest(url: url, method: .get, headers: header) else{
            return
        }
        Alamofire.request(urlRequest).responseData { (response) in
            if let data = response.data {
                let decoder = JSONDecoder()
                if let data = try? decoder.decode([User].self, from: data) {
                    completion(data, true)
                    return
                }
                
            }
            completion(nil, false)
        }
    }
    
    func updateUser(_ userDict:[String:Any], user_id:Int, _ completion:@escaping (_ user:User?, _ error:Error?) -> Void){
        let header = [
            "Authorization": self.authToken,
            "Accept": "application/json"
        ]
        let urlString = (ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + "users/\(user_id)/profile")
        guard let url = URL(string:urlString), var urlRequest = try? URLRequest(url: url, method: .put, headers: header) else{
            return
        }
        urlRequest = try! JSONEncoding.default.encode(urlRequest, with: userDict)
        Alamofire.request(urlRequest)
            .validate()
            .responseJSON { (response) in
                switch  response.result {
                case let .success(json):
                    completion(User(dict: json as! [String : AnyObject]), nil)
                case let .failure(error):
                    completion(nil, error)
                }
        }
    }
    func getUserWithId(_ user_id:Int, completion:@escaping (_ user:User?, _ success:Bool) -> Void){
        let header = [
            "Authorization": self.authToken,
            "Accept": "application/json"
        ]
        let urlString = (ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + "users/\(user_id)/profile")
        guard let url = URL(string:urlString), let urlRequest = try? URLRequest(url: url, method: .get, headers: header) else{
            return
        }
        Alamofire.request(urlRequest)
            .validate()
            .responseJSON { (response) in
                switch  response.result {
                case let .success(json):
                    completion(User(dict: json as! [String : AnyObject]), true)
                case .failure:
                    completion(nil, false)
                }
        }
    }
    func getFriensForUser(withId user_id:Int, completion:@escaping (_ users:[UserAndMutuals]?, _ error:Error?) -> Void){
        let header = [
            "Authorization": self.authToken,
            "Accept": "application/json"
        ]
        let urlString = (ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + "network/\(user_id)")
        guard let url = URL(string:urlString), let urlRequest = try? URLRequest(url: url, method: .get, headers: header) else{
            return
        }
        Alamofire.request(urlRequest)
            .validate()
            .responseData {
                (response) in
                switch  response.result {
                case let .success(json):
                    let decoder = JSONDecoder()
                    do {
                        let users = try decoder.decode(Array<UserAndMutuals>.self, from: json)
                        completion(users, nil)
                    }
                    catch let error {
                        completion(nil,error)
                    }
                case .failure(let error):
                    completion(nil,error)
                }
        }
    }
    
    func deleteProperty(_ property_id:Int, completion: @escaping (_ success:Bool) -> Void)  {
        let urlString = (ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + "properties/\(property_id)")
        guard let url = URL(string:urlString), let urlRequest = try? URLRequest(url: url, method: .delete, headers: authHeader) else{
            return
        }
        Alamofire.request(urlRequest)
            .validate()
            .responseJSON { (respose) in
                switch respose.result{
                case .success:
                    completion(true)
                    break
                case .failure:
                    completion(false)
                    break
                }
        }
    }
    
    func updatePropertyFavorites(property_id:Int, setFavorite:Bool, completion: @escaping (_ success:Bool) -> Void)  {
        let urlString = (ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + "favorites/\(property_id)")
        guard let url = URL(string:urlString), let urlRequest = try? URLRequest(url: url, method: setFavorite ? .post : .delete, headers: authHeader) else{
            return
        }
        Alamofire.request(urlRequest)
            .validate()
            .responseJSON { (respose) in
                switch respose.result{
                case .success:
                    completion(true)
                    break
                case .failure:
                    completion(false)
                    break
                }
        }
    }
    func getPropertyById(property_id:Int, completion: @escaping (_ property:FLPPDProperty?, _ error:Error?) -> Void){
        let header = [
            "Authorization": self.authToken,
            "Accept": "application/json"
        ]
        let urlString = (ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + "properties/\(property_id)")
        guard let url = URL(string:urlString), let urlRequest = try? URLRequest(url: url, method: .get, headers: header) else{
            return
        }
        Alamofire.request(urlRequest)
            .validate()
            .responseData {
                (response) in
                switch  response.result {
                case let .success(json):
                    let decoder = JSONDecoder()
                    do {
                        let property = try decoder.decode(FLPPDProperty.self, from: json)
                        completion(property, nil)
                    }
                    catch let error {
                        completion(nil,error)
                    }
                case .failure(let error):
                    completion(nil,error)
                }
        }
    }
    func getConfig(completion: @escaping (_ property:Config?, _ error:Error?) -> Void){
        let header = [
            "Authorization": self.authToken,
            "Accept": "application/json"
        ]
        let urlString = (ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + "cfg")
        guard let url = URL(string:urlString), let urlRequest = try? URLRequest(url: url, method: .get, headers: header) else{
            return
        }
        Alamofire.request(urlRequest)
            .validate()
            .responseData {
                (response) in
                switch  response.result {
                case let .success(json):
                    let decoder = JSONDecoder()
                    do {
                        let config = try decoder.decode(Config.self, from: json)
                        Config.current = config
                        completion(config, nil)
                    }
                    catch let error {
                        completion(nil,error)
                    }
                case .failure(let error):
                    completion(nil,error)
                }
        }
    }
}
