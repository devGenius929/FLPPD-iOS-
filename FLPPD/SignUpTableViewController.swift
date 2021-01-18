//
//  SignUpTableViewController.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 3/6/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SignUpTableViewController: UITableViewController {
  
  @IBOutlet weak var firstNameTextView: FloatLabelTextField!
  @IBOutlet weak var lastNameTextView: FloatLabelTextField!
  @IBOutlet weak var signUpAndAcceptBtn: BorderedButton!
  
  private let disposeBag = DisposeBag()
  private let throttleInterval = 0.1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //back button
    let backBtn = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonAction(_:)))
    backBtn.image = UIImage(named: "back_button")
    self.navigationItem.leftBarButtonItem = backBtn
    Helper.navigationWhiteStyle((self.navigationController?.navigationBar)!)
    
    //table extra configurations
    self.tableView.tableFooterView = UIView()
    
    firstNameTextView.becomeFirstResponder()
    signUpAndAcceptBtn.alpha = 0.5
    setupTextField()
  }
    @IBAction func tosAnPrivacyAction(_ sender: Any) {
        let vc = PolicyViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
  //MARK: RxSwift setup
  func setupTextField(){
    
    let validFirstName = firstNameTextView
      .rx
      .text
      .throttle(throttleInterval, scheduler: MainScheduler.instance)
      .map { DataValidator.validName($0) }
    
    validFirstName
      .subscribe(onNext: { self.firstNameTextView.valid = $0 })
      .disposed(by: disposeBag)
    
    let validLastName = lastNameTextView
      .rx
      .text
      .throttle(throttleInterval, scheduler: MainScheduler.instance)
      .map { DataValidator.validName($0) }
    
    validLastName
      .subscribe(onNext: { self.lastNameTextView.valid = $0 })
      .disposed(by: disposeBag)
    
    let everyTextFieldIsValid = Observable
      .combineLatest(validFirstName, validLastName){
        $0 && $1
    }
    
    everyTextFieldIsValid
      .asObservable()
      .subscribe(onNext: {
        self.signUpAndAcceptBtn.isEnabled = $0
        self.signUpAndAcceptBtn.opacity($0)
      })
      .disposed(by: disposeBag)
    
  }
  
  
  //back function
  @objc func backButtonAction(_ sender: UIBarButtonItem){
    if let navController = navigationController{
      navController.popViewController(animated: false)
    }
  }
  
  
  //MARK: sign up and accept btn
  @IBAction func sendToSecondViewAfterTapAccept(_ sender: UIButton){
    
    self.performSegue(withIdentifier: "afterAcepptAndSignUp", sender: sender)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let secondView = segue.destination as! SignUpSecondTableViewController
    secondView.userData = ["first_name":firstNameTextView.text!, "last_name":lastNameTextView.text!]
  }
  
  
}


class SignUpSecondTableViewController: UITableViewController{
  
  //porperties
  var userData = [String: String]()
  private let disposeBag = DisposeBag()
  private let throttleInterval = 0.1
  
  //IBOulets
  @IBOutlet weak var emailTextField: FloatLabelTextField!
  @IBOutlet weak var continueBtn: BorderedButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //back button
    let backBtn = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonAction(_:)))
    backBtn.image = UIImage(named: "back_button")
    self.navigationItem.leftBarButtonItem = backBtn
    
    //table extra configuration
    self.tableView.tableFooterView = UIView()
    
    continueBtn.alpha = 0.5
    emailTextField.becomeFirstResponder()
    
    setTextField()
    
    
  }
  
  func setTextField(){
    
    let validationEmailTextField = emailTextField
      .rx
      .text
      .throttle(throttleInterval, scheduler: MainScheduler.instance)
      .map { DataValidator.validEmail($0) }
    
    validationEmailTextField
      .subscribe(onNext: {
        self.emailTextField.valid = $0
        self.continueBtn.isEnabled = $0
        self.continueBtn.opacity($0)
      })
      .disposed(by: disposeBag)
  }
  
  
  
  //back and contniue actions
  @objc func backButtonAction(_ sender: UIBarButtonItem){
    if let navController = navigationController{
      navController.popViewController(animated: false)
    }
  }
  
  //MARK: sign up and accept btn
  @IBAction func sendToThirdViewAfterTapContinue(_ sender: UIButton){
    
    self.performSegue(withIdentifier: "afterContinueSecondView", sender: sender)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let thirdView = segue.destination as? SignUpThirdTableViewController
    self.userData.updateValue(emailTextField.text!, forKey: "email")
    thirdView?.userData = userData as [String : String]
    
  }
  
}


class SignUpThirdTableViewController: UITableViewController{
  
  //properties
  var userData = [String: String]()
  private let disposeBag = DisposeBag()
  private let throttleInterval = 0.1
  
  //IBOutlets
  @IBOutlet weak var continueBtn: BorderedButton!
  @IBOutlet weak var passwordTextField: FloatLabelTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //back button
    let backBtn = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonAction(_:)))
    backBtn.image = UIImage(named: "back_button")
    self.navigationItem.leftBarButtonItem = backBtn
    
    
    //table extra configurations
    self.tableView.tableFooterView = UIView()
    
    self.continueBtn.isEnabled = false
    self.continueBtn.alpha = 0.5
    passwordTextField.becomeFirstResponder()
    
    setTextField()
  }
  
  func setTextField(){
    
    let validPasswordText = passwordTextField
      .rx
      .text
      .throttle(throttleInterval, scheduler: MainScheduler.instance)
      .map{ DataValidator.validTextFieldLenght($0, lenght: 5) }
    
    validPasswordText
      .subscribe(onNext: {
        self.passwordTextField.valid = $0
        self.continueBtn.isEnabled = $0
        self.continueBtn.opacity($0)
      })
      .disposed(by: disposeBag)
    
  }
  
  //Continue and segue actions
  @objc func backButtonAction(_ sender: UIBarButtonItem){
    if let navController = navigationController{
      navController.popViewController(animated: false)
    }
  }
  
  @IBAction func sendToFourthViewAfterTapContinue(_ sender: UIButton){
    
    self.performSegue(withIdentifier: "afterContinueSThirdView", sender: sender)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let fourthVC = segue.destination as! SignUpFourthTableViewController
    userData.updateValue(passwordTextField.text!, forKey: "password")
    fourthVC.userData = self.userData
  }
  
}

class SignUpFourthTableViewController: UITableViewController{
  
  //properties
  var userData = [String: String]()
  private let disposeBag = DisposeBag()
  private let throttleInterval = 0.1
  private var backBtn = UIBarButtonItem()
  
  //IBOutlets
  @IBOutlet weak var continueBtn: BorderedButton!
  @IBOutlet weak var phoneNumberTextField: FloatLabelTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //back button
    backBtn = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonAction(_:)))
    backBtn.image = UIImage(named: "back_button")
    self.navigationItem.leftBarButtonItem = backBtn
    
    //table extra configurations
    self.tableView.tableFooterView = UIView()
    
    continueBtn.alpha = 0.5
    continueBtn.isEnabled = false
    phoneNumberTextField.becomeFirstResponder()
    
    setUpTextField()
    
  }
  
  func setUpTextField(){
    
    var phoneFormatter = PhoneNumberFormatter()
    
    let validPhoneNumber = phoneNumberTextField
      .rx
      .text
      .throttle(throttleInterval, scheduler: MainScheduler.instance)
      .map{ DataValidator.validPhoneNumber(value: $0) }
    
    validPhoneNumber
      .subscribe(onNext:{
        self.phoneNumberTextField.valid = $0
        
        self.phoneNumberTextField.text = phoneFormatter.format(self.phoneNumberTextField.text!)
        
        self.continueBtn.isEnabled = $0
        self.continueBtn.opacity($0)
      })
      .disposed(by: disposeBag)
    
  }
  
  
  //continue and segue actions
  @objc func backButtonAction(_ sender: UIBarButtonItem){
    if let navController = navigationController{
      navController.popViewController(animated: false)
    }
  }
  
  @IBAction func sendToVerifyViewAfterTapContinue(_ sender: UIButton){
    
    self.view.endEditing(true)
    continueBtn.isEnabled = false
    continueBtn.opacity(false)
    backBtn.isEnabled = false
    
    userData.updateValue("+1 \(self.phoneNumberTextField.text!)", forKey: "phone_number")
    let parameters = ["user": userData as AnyObject]
    
    ClientAPI.default.posSignUp(parameters) { (result, error) in
      
      performUIUpdatesOnMain {
        self.continueBtn.isEnabled = true
        self.continueBtn.opacity(true)
        self.backBtn.isEnabled = true
      }
      
      
      if error != nil{
        self.showError(error!)
      }else{
        _ = KeychainWrapper.standard.set(self.userData["password"]!, forKey: "passwordEncrypted")
        
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainTabBarController")
        UIApplication.shared.delegate?.window??.rootViewController = mainView
        
//        self.performSegue(withIdentifier: "verifyAccountFromSignUp", sender: sender)
      }
    }
    
  }
  
}
