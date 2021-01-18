//
//  UpdatePhoneViewController.swift
//  FLPPD
//
//  Created by Vlad Konon on 02/01/18.
//  Copyright © 2018 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import KRProgressHUD

class UpdatePhoneViewController: UITableViewController{
    
    //properties
    var user = ClientAPI.currentUser
    private let disposeBag = DisposeBag()
    private let throttleInterval = 0.1
    
    //IBOutlets
    @IBOutlet weak var continueBtn: BorderedButton!
    @IBOutlet weak var phoneNumberTextField: FloatLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    @IBAction func sendToVerifyViewAfterTapContinue(_ sender: UIButton){
        user?.phone_number = "+1 \(self.phoneNumberTextField.text!)"
        if let dict = user?.getDict(), let id = user?.user_id {
            self.view.endEditing(true)
            continueBtn.isEnabled = false
            continueBtn.opacity(false)
            KRProgressHUD.show(withMessage: "Sending", completion: nil)
            ClientAPI.default.updateUser(dict, user_id: id, { [unowned self] (user, error) in
                KRProgressHUD.dismiss()
                if let error = error {
                    self.showError(error as NSError)
                }
                else if let user = user {
                    ClientAPI.currentUser = user
                    AppDelegate.current.showMainInterface()
                }
            })
        }
        
    }
    
}
