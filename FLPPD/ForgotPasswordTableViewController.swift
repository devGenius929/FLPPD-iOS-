//
//  ForgotPasswordTableViewController.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 3/6/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ForgotPasswordTableViewController: UITableViewController {
  
  //properties
  private let disposeBag = DisposeBag()
  private let throttleInterval = 0.1
  private var backBtn = UIBarButtonItem()
  
  //IBOutlets
  @IBOutlet weak var phoneNumberTextField: FloatLabelTextField!
  @IBOutlet weak var continueBtn: BorderedButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //back button
    backBtn = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonAction(_:)))
    backBtn.image = UIImage(named: "back_button")
    self.navigationItem.leftBarButtonItem = backBtn
    
    
    //table extra configurations
    
    self.tableView.tableFooterView = UIView()
    
    setTextField()
    
  }
  
  private func setTextField(){
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
        if $0{
          self.continueBtn.alpha = 1
        }else{
          self.continueBtn.alpha = 0.5
        }
      })
      .disposed(by: disposeBag)
  }
  
  
  //backbutton and actions methods
  
  @IBAction func requestNewPasswordAction(sender: UIButton){
    self.backBtn.isEnabled = false
    self.continueBtn.isEnabled = false
    self.continueBtn.alpha = 0.5
    
    let parameters: [String: AnyObject] = ["phone_number":"+1 \(self.phoneNumberTextField.text!)" as AnyObject]
    
    ClientAPI.default.postRecover(parameters) { (result, error) in
      performUIUpdatesOnMain {
        self.backBtn.isEnabled = true
        self.continueBtn.isEnabled = true
        self.continueBtn.alpha = 1
      }
      
      if error != nil{
        self.showError(error!)
        dprint(result?["error"] ?? "")
      }else{
        dprint(result?["message"] ?? "")
        self.performSegue(withIdentifier: "updatePassword", sender: sender)
        
      }
    }
    
  }
  
  @objc func backButtonAction(_ sender: UIBarButtonItem){
    if let navController = navigationController{
      navController.popViewController(animated: false)
    }
  }
  
}
