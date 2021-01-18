//
//  FacebookLogin.swift
//  FLPPD
//
//  Created by Vlad Konon on 02/01/18.
//  Copyright © 2018 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

extension UIViewController{
    func loginWithFacebook(){
        let login = FBSDKLoginManager()
        login.logOut()
        login.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                self.showWarningAlert(message: error.localizedDescription)
            }
            if let result = result {
                if result.isCancelled {
                    dprint("canceled")
                }
                else {
                    if let token = result.token.tokenString {
                        ClientAPI.default.loginWithFacebook(facebookToken: token, completion: { (user, error) in
                            if let error = error {
                                self.showWarningAlert(message: error.localizedDescription)
                            }
                            else if let user = user {
                                if user.phone_number == nil || user.phone_number!.isEmpty {
                                    let vc = UIStoryboard(name: "login", bundle: nil).instantiateViewController(withIdentifier: "updatePhone") as! UpdatePhoneViewController
                                    self.present(vc, animated: true, completion: nil)
                                }
                                else {
                                    AppDelegate.current.showMainInterface()
                                }
                            }
                            else {
                                self.showWarningAlert(message: "Unexpected error")
                            }
                        })
                    }
                }
                
            }
        }
    }
}
