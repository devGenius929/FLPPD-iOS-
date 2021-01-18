//
//  LoginViewController.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 3/5/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class AuthViewController: UIViewController {
  
  @IBOutlet weak var loginBtn: BorderedButton!
  @IBOutlet weak var signUp: GoldenBorderButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.isNavigationBarHidden = true
    UIApplication.shared.statusBarStyle = .lightContent
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.navigationController?.isNavigationBarHidden = true
    UIApplication.shared.statusBarStyle = .lightContent
  }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = .lightContent
    }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.navigationController?.navigationBar.isHidden = false
  }
  
    @IBAction func loginWithFacebookAction(_ sender: Any) {
        loginWithFacebook()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let backItem = UIBarButtonItem()
    backItem.title = ""
    navigationItem.backBarButtonItem = backItem
  }
  
}
