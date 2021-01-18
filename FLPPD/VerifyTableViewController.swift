//
//  VerifyTableViewController.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 3/6/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class VerifyTableViewController: UITableViewController {
  
  //properties
  private let disposeBag = DisposeBag()
  private let throttleInterval = 0.1
  private var backBtn = UIBarButtonItem()
  
  //IBoutlets
  @IBOutlet weak var pinCodeTextField: UITextField!
  @IBOutlet weak var verifyBtn: BorderedButton!
  @IBOutlet weak var sendCodeBtn: UIButton!
  @IBOutlet weak var countDownLabel: AnimatedCountLabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //back button
    backBtn = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonAction(_:)))
    backBtn.image = UIImage(named: "back_button")
    self.navigationItem.leftBarButtonItem = backBtn
    
    //table extra configurations
    
    self.tableView.tableFooterView = UIView()
    verifyBtn.isEnabled = false
    verifyBtn.alpha = 0.5
    pinCodeTextField.becomeFirstResponder()
    
    setUpPinTextField()
    
    disableSendCodeBtn()
  }
  
  //senc code btn setup
  @objc func enableSendAgainBtn(){
    sendCodeBtn.alpha = 1
    sendCodeBtn.isEnabled = true
  }
  
  func disableSendCodeBtn(){
    sendCodeBtn.isEnabled = false
    sendCodeBtn.alpha = 0.5
    
    countDownLabel.count(from: 30, to: 0, duration: 30)
    
    Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.enableSendAgainBtn), userInfo: nil, repeats: false)
  }
  
  @IBAction func sendCodeAgain(sender: UIButton){

    guard let currentUser = ClientAPI.currentUser else {
        return
    }
    disableSendCodeBtn()
    
    backBtn.isEnabled = false
    let parameters: [String:AnyObject] = [ClientAPI.Constants.FLPDDAuthKeys.phoneNumber: currentUser.phone_number  as AnyObject]
    
    ClientAPI.default.postGenerate(parameters) { (result, error) in
      performUIUpdatesOnMain {
        self.backBtn.isEnabled = true
      }
      
      if error != nil{
        dprint(result?["error"] ?? "")
      }else{
        dprint(result?["message"] ?? "")
      }
      
    }
  }
  
  //RxSwift setup
  private func setUpPinTextField(){
    
    let pinCodeTextValidation = pinCodeTextField
      .rx
      .text
      .throttle(throttleInterval, scheduler: MainScheduler.instance)
      .map{ DataValidator.validTextFieldLenght($0, lenght: 3) }
    
    pinCodeTextValidation
      .subscribe(onNext:{
        self.verifyBtn.isEnabled = $0
        self.verifyBtn.opacity($0)
        self.checkMaxLength(textField: self.pinCodeTextField)
      })
      .disposed(by: disposeBag)
    
  }
  
  @objc func backButtonAction(_ sender: UIBarButtonItem){
    if let navController = navigationController{
      navController.popViewController(animated: false)
    }
  }
  
  //MARK: verify btn pressed
  @IBAction func verifyAction(sender: UIButton){
    guard let currentUser = ClientAPI.currentUser else  {
        return
    }
    disableSendCodeBtn()
    
    backBtn.isEnabled = false
    verifyBtn.isEnabled = false
    verifyBtn.alpha = 0.5
    
    /// Read user default with userInfo
    
    
    
    let parameters: [String:AnyObject] = [
        ClientAPI.Constants.FLPDDAuthKeys.phoneNumber: currentUser.phone_number as AnyObject,
      ClientAPI.Constants.FLPDDAuthKeys.pin: (self.pinCodeTextField.text as AnyObject?)!
    ]
  
    
    ClientAPI.default.postVerify(parameters) { (result, error) in
      performUIUpdatesOnMain {
        self.backBtn.isEnabled = true
        self.verifyBtn.isEnabled = true
        self.verifyBtn.alpha = 1
      }
      
      if error != nil{
        dprint(result?["error"] ?? "")
      }else{
        dprint(result?["message"] ?? "")
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainTabBarController")
        self.present(mainView, animated: false, completion:nil)
      }
    }
    
    
  }
  
  
  //MARK: validate number of elements in textfield
  func checkMaxLength(textField: UITextField){
    
    if (textField.text?.count)! > 0{
      self.countDownLabel.isHidden = true
    }else{
      self.countDownLabel.isHidden = false
    }
    
    let attributedString = NSMutableAttributedString(string: textField.text!)
    attributedString.addAttribute(NSAttributedStringKey.kern, value: 5, range: NSMakeRange(0, (textField.text?.count)!))
    attributedString.addAttribute(NSAttributedStringKey.font, value: textField.font!, range: NSMakeRange(0, (textField.text?.count)!))
    attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSMakeRange(0, (textField.text?.count)!))
    textField.attributedText = attributedString
    
    if (textField.text?.count)! > 4{
      textField.deleteBackward()
    }
    
  }
  
  
}


