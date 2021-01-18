//
//  LoginViewController.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 3/5/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UITableViewController {
  
  //porperties2
  private let disposeBag = DisposeBag()
  private let throttleInterval = 0.1
  private var backBtn = UIBarButtonItem()
  
  //IBOutles
  
  @IBOutlet weak var emailTextField: FloatLabelTextField!
  @IBOutlet weak var passwordTextField: FloatLabelTextField!
  @IBOutlet weak var logInBtn: BorderedButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //back button
    backBtn = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonAction(_:)))
    backBtn.image = UIImage(named: "back_button")
    self.navigationItem.leftBarButtonItem = backBtn
    
    
    //table extra configurations
    
    tableView.tableFooterView = UIView()
    
    logInBtn.alpha = 0.5
    logInBtn.isEnabled = false
    
    Helper.navigationWhiteStyle((self.navigationController?.navigationBar)!)
    
    setTextFields()
    
  }
    override func viewDidAppear(_ animated: Bool) {
            navigationController?.isNavigationBarHidden = false
    }
  
  func setTextFields(){
  
    let validEmailTextField = emailTextField
      .rx
      .text
      .throttle(throttleInterval, scheduler: MainScheduler.instance)
      .map{ DataValidator.validEmail($0) }
    
    validEmailTextField
      .subscribe(onNext: { self.emailTextField.valid = $0 })
      .disposed(by: disposeBag)
    
    let validPasswordText = passwordTextField
      .rx
      .text
      .throttle(throttleInterval, scheduler: MainScheduler.instance)
      .map{ DataValidator.validTextFieldLenght($0, lenght: 5) }
    
    validPasswordText
      .subscribe(onNext: { self.passwordTextField.valid = $0 })
      .disposed(by: disposeBag)
    
    let everyTextFieldIsValid = Observable
      .combineLatest(validEmailTextField, validPasswordText){
        $0 && $1
    }
    
    everyTextFieldIsValid
      .asObservable()
      .subscribe(onNext: { (enable)  in
        self.logInBtn.isEnabled = enable
        if enable{
          self.logInBtn.alpha = 1
        }else{
          self.logInBtn.alpha = 0.5
        }
      })
      .disposed(by: disposeBag)
  
  }
  
  //continue button action
  @objc func backButtonAction(_ sender: UIBarButtonItem){
    if let navController = navigationController{
      navController.popToRootViewController(animated: false)
    }
  }
  
  @IBAction func logInAction(sender: UIButton){

    self.view.endEditing(true)
    logInBtn.isEnabled = false
    logInBtn.alpha = 0.5
    
    backBtn.isEnabled = false
    
    let authParameter = ["email":emailTextField.text,"password": passwordTextField.text]

    ClientAPI.default.postLogin(authParameter as [String: AnyObject]) { (result, error) in
      
      performUIUpdatesOnMain {
        self.logInBtn.isEnabled = true
        self.logInBtn.alpha = 1
        self.backBtn.isEnabled = true
      }
      
      if let error = error{
        self.showError(error)
      }else{
            _ = KeychainWrapper.standard.set(self.passwordTextField.text!, forKey: "passwordEncrypted")
            AppDelegate.current.showMainInterface()
      }
    }
    
  }

    @IBAction func loginWithFB(_ sender: Any) {
        loginWithFacebook()
    }
}
