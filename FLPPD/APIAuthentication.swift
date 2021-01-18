//
//  APIAuthentication.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 4/4/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import Alamofire
import FBSDKLoginKit

extension ClientAPI{
    static let `default` = ClientAPI()
    private static var _currentUser:User? = nil
    static var currentUser:User? {
        get{
            if let user = self._currentUser {
                return user
            }
            if let userData = UserDefaults.standard.value(forKey:ClientAPI.Constants.userInfo) as? Data{
                let userObject = NSKeyedUnarchiver.unarchiveObject(with: userData as Data) as! [String: AnyObject]
                self._currentUser =  User(dict: userObject)
                return _currentUser
            }
            return nil
        }
        set (user){
            if let user = user {
                let userData = user.getDict()
                self.default.setUserInfo(result: userData as [String : AnyObject])
                self._currentUser = user
            }
            else {
                self._currentUser = nil
            }
        }
    }
    func signOut()  {
        FBSDKLoginManager().logOut()
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.setPresence(false)
        
        UserDefaults.standard.set(nil, forKey: ClientAPI.Constants.authToken)
        UserDefaults.standard.set(nil, forKey: ClientAPI.Constants.userInfo)
        ClientAPI._currentUser = nil
        CoreDataManager.shared.clearStore()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let chatController = appDelegate.chatController{
            chatController.client?.unsubscribeFromAll()
            chatController.client?.removeListener(chatController)
            appDelegate.chatController = nil
        }

        
    }
    // MARK: set user info
   private func setUserInfo(result:[String:AnyObject]){
       
        if let auth_token = result[ClientAPI.Constants.FLPDDAuthKeys.auth_token]{
            UserDefaults.standard.set(auth_token, forKey: ClientAPI.Constants.authToken)
        }
    
    if let pass = result[ClientAPI.Constants.FLPDDAuthKeys.firebase_password], !(pass is NSNull){
        UserDefaults.standard.set(pass, forKey: ClientAPI.Constants.FLPDDAuthKeys.firebase_password)
    }
    
        UserDefaults.standard.set(result["user_id"], forKey: "user_id")
        
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: result), forKey: ClientAPI.Constants.userInfo)
        UserDefaults.standard.synchronize()
    }
  //MARK: POST login
  
  func postLogin(_ parameters: [String:AnyObject], completionHandlerForLogin: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void){
    
    let _ = taskForPOSTMethodWithoutToken(ClientAPI.Constants.FLPPDMethods.login, parameters: parameters, jsonBody: "") { (result, error) in
      
      if let error = error{
        completionHandlerForLogin(nil, error)
      }else{
        self.completeLogin(result: result)
        completionHandlerForLogin(result as? [String:AnyObject] , nil)
        KeychainWrapper.standard.removeObject(forKey: "facebookToken")
      }
      
    }
  }
    func loginWithFacebook(facebookToken:String, completion:@escaping(_ user:User?, _ error:Error?) -> Void) {
        taskForPOSTMethodWithoutToken("facebook_auth", parameters: ["access_token":facebookToken as AnyObject], jsonBody: "") { (result, error) in
            if let error = error {
                completion(nil,error)
            }
            else  {
                KeychainWrapper.standard.removeObject(forKey: "passwordEncrypted")
                KeychainWrapper.standard.set(facebookToken, forKey: "facebookToken")
                let user = self.completeLogin(result: result)
                completion(user,nil)
            }
        }
    }
    @discardableResult
    internal func completeLogin(result:AnyObject?) -> User?{
        if let result = result as? [String:AnyObject] {
            self.setUserInfo(result: result)
            self.sendDeviceToken()
            self.getConfig(completion: { (_, _) in
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                AppDelegate.current.createChatController()
            })
            return ClientAPI.currentUser
        }
        else {
            return nil
        }
    }
    func refreshToken(completionHandlerForLogin: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void){
        
        if let fb_token = KeychainWrapper.standard.string(forKey: "facebookToken") {
            self.loginWithFacebook(facebookToken: fb_token, completion: { (user, error) in
                if let error = error{
                    completionHandlerForLogin(nil, NSError(domain: "com.fb", code: 0, userInfo: [NSLocalizedDescriptionKey:error.localizedDescription]))
                }else{
                    completionHandlerForLogin(nil,nil)
                }
            })
        } else if let keychainPassword = KeychainWrapper.standard.string(forKey: "passwordEncrypted"){
            let parameters: [String:AnyObject]
            guard let currentUser = ClientAPI.currentUser else {
                return
            }
            let email = currentUser.email as AnyObject
            parameters = ["email": email, "password": keychainPassword as AnyObject]
            
            
            let _ = taskForPOSTMethodWithoutToken(ClientAPI.Constants.FLPPDMethods.login, parameters: parameters, jsonBody: "") { (result, error) in
                
                if let error = error{
                    completionHandlerForLogin(nil, error)
                }else{
                    if let userInfo = result as? [String:AnyObject]{
                        self.setUserInfo(result: userInfo)
                        completionHandlerForLogin(userInfo, nil)
                    } else {
                        completionHandlerForLogin(nil, NSError(domain: "postLogin parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse login data returned"]))
                    }
                }
            }
        }
    }
  //MARK: POST signup
  
  func posSignUp(_ parameters: [String:AnyObject], completionHandlerForSignUp: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void){
    
    let _ = taskForPOSTMethodWithoutToken(ClientAPI.Constants.FLPPDMethods.signup, parameters: parameters, jsonBody: "") {[unowned self] (result, error) in
      if let error = error{
        //can sent result intead of nil
        completionHandlerForSignUp(nil, error)
      }else{
        if let results = result as? [String:AnyObject]{
            self.setUserInfo(result: results)
            self.sendDeviceToken()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.createChatController()
          completionHandlerForSignUp(results, nil)

        }else{
          completionHandlerForSignUp(nil, NSError(domain: "postSignUp parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse signup data returned"]))
        }
      }
      
    }
    
  }
  
  //MARK: POST generate
  
  func postGenerate(_ parameters: [String:AnyObject], completionHandlerForGenerate: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void){
    
    let _ = taskForPOSTMethodWithoutToken(ClientAPI.Constants.FLPPDMethods.generate, parameters: parameters, jsonBody: "") { (result, error) in
      if let error = error{
        completionHandlerForGenerate(result as! [String : AnyObject]?, error)
      }else{
        if let results = result as? [String:AnyObject]{
          completionHandlerForGenerate(results, nil)
        }else{
          completionHandlerForGenerate(nil, NSError(domain: "postGenerate parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse generate data returned"]))
        }
      }
    }
    
  }
  
  //MARK: POST verify
  
  func postVerify(_ parameters: [String:AnyObject], completionHandlerForVerify: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void){
    
    let _ = taskForPOSTMethodWithoutToken(ClientAPI.Constants.FLPPDMethods.verify, parameters: parameters, jsonBody: "") { (result, error) in
      if let error = error{
        completionHandlerForVerify(result as! [String : AnyObject]?, error)
      }else{
        if let results = result as? [String:AnyObject]{
          completionHandlerForVerify(results, nil)
        }else{
          completionHandlerForVerify(nil, NSError(domain: "postVerify parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse verify data returned"]))
        }
      }
    }
    
  }
  
  //MARK: POST recover
  
  func postRecover(_ parameters: [String:AnyObject], completionHandlerForRecover: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void){
    
    let _ = taskForPOSTMethodWithoutToken(ClientAPI.Constants.FLPPDMethods.recover, parameters: parameters, jsonBody: "") { (result, error) in
      if let error = error{
        completionHandlerForRecover(result as! [String : AnyObject]?, error)
      }else{
        if let results = result as? [String:AnyObject]{
          completionHandlerForRecover(results, nil)
        }else{
          completionHandlerForRecover(nil, NSError(domain: "postVerify parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse verify data returned"]))
        }
      }
    }
    
  }
  
  //MARK: PUT password reset
  
  func putUpdatePass(_ parameters: [String:AnyObject], pincode: String, completionHandlerForUpdatePass: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void){
    
    let url = "\(ClientAPI.Constants.FLPPDMethods.password_restart)\(pincode)"
    
    let _ = taskForPUTMethodWithoutToken(url, parameters: parameters, jsonBody: "") { (result, error) in
      if let error = error{
        completionHandlerForUpdatePass(result as! [String : AnyObject]?, error)
      }else{
        if let results = result as? [String:AnyObject]{
          completionHandlerForUpdatePass(results, nil)
        }else{
          completionHandlerForUpdatePass(nil, NSError(domain: "putPasswordResset parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse verify data returned"]))
        }
      }
    }
    
  }
  
}
