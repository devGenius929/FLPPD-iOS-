//
//  RecoverPassTableViewController.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 3/13/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RecoverPassTableViewController: UITableViewController {
  
  //outlets
  @IBOutlet weak var pinCodeTextField: UITextField!
  @IBOutlet weak var newPasswordTextField: FloatLabelTextField!
  @IBOutlet weak var continueBtn: BorderedButton!
  
  
  //properties
  private let disposeBag = DisposeBag()
  private let throttleInterval = 0.1
  private var backBtn = UIBarButtonItem()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //back button
    backBtn = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonAction(_:)))
    backBtn.image = UIImage(named: "back_button")
    self.navigationItem.leftBarButtonItem = backBtn
    
    //table extra configurations
    self.tableView.tableFooterView = UIView()
    
    pinCodeTextField.becomeFirstResponder()
    pinCodeTextField.autocapitalizationType = .allCharacters
    continueBtn.alpha = 0.5
    setupTextField()
  }
  
  //MARK: RxSwift setup
  func setupTextField(){
    
    let validPinCode = pinCodeTextField
      .rx
      .text
      .throttle(throttleInterval, scheduler: MainScheduler.instance)
      .map { DataValidator.validTextFieldLenght($0, lenght: 5) }
    
    validPinCode
      .subscribe(onNext: { (response) in
        self.checkMaxLength(textField: self.pinCodeTextField)
      })
      .disposed(by: disposeBag)
    
    let validNewPassword = newPasswordTextField
      .rx
      .text
      .throttle(throttleInterval, scheduler: MainScheduler.instance)
      .map { DataValidator.validTextFieldLenght($0, lenght: 5) }
    
    validNewPassword
      .subscribe(onNext: {
        self.newPasswordTextField.valid = $0
      })
      .disposed(by: disposeBag)
    
    let everyTextFieldIsValid = Observable
      .combineLatest(validPinCode, validNewPassword){
        $0 && $1
    }
    
    everyTextFieldIsValid
      .asObservable()
      .subscribe(onNext: {
        self.continueBtn.isEnabled = $0
        self.continueBtn.opacity($0)
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
  @IBAction func updatedPasswordActionBtn(_ sender: UIButton){
    
    backBtn.isEnabled = false
    continueBtn.isEnabled = false
    continueBtn.alpha = 0.5
    
    let pinCode = pinCodeTextField.text!
    
    let parameters = ["user": ["password":newPasswordTextField.text!]]
    
    ClientAPI.default.putUpdatePass(parameters as [String : AnyObject], pincode: pinCode) { (result, error) in
      performUIUpdatesOnMain {
        self.backBtn.isEnabled = true
        self.continueBtn.isEnabled = true
        self.continueBtn.alpha = 1
      }
      
      if error != nil{
        self.showError(error!)
        dprint(result?["message"] ?? "")
      }else{
        dprint(result?["message"] ?? "")
        if let navController = self.navigationController{
          navController.popToRootViewController(animated: false)
        }
      }
    }
    
  }
  
  //MARK: validate number of elements in textfield
  func checkMaxLength(textField: UITextField){
    
    let attributedString = NSMutableAttributedString(string: textField.text!)
    attributedString.addAttribute(NSAttributedStringKey.kern, value: 5, range: NSMakeRange(0, (textField.text?.count)!))
    attributedString.addAttribute(NSAttributedStringKey.font, value: textField.font!, range: NSMakeRange(0, (textField.text?.count)!))
    attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSMakeRange(0, (textField.text?.count)!))
    textField.attributedText = attributedString
    
    if (textField.text?.count)! > 6{
      textField.deleteBackward()
    }
    
  }
  
}
