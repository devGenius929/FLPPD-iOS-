//
//  InitialViewController.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 3/5/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Storyboard
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    if UserDefaults.standard.string(forKey: ClientAPI.Constants.authToken) != nil {
      
      //TODO: remove login
      let eventsTableVC = storyboard.instantiateViewController(withIdentifier: "mainTabBarController")
      
      appdelegate.window?.rootViewController = eventsTableVC
      
    } else {
      
      let loginVC = storyboard.instantiateViewController(withIdentifier: "loginController")
      
      appdelegate.window?.rootViewController = loginVC
    }
    
  }
  
  
}
