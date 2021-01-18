//
//  ProfileViewController.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 4/10/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa
import StoreKit
import KRProgressHUD

struct ProfileTableData {
    let image:UIImage
    let text:String
    let count:String?
}

class ProfileViewController: UIViewController {
    var profile = ClientAPI.currentUser
    let data = Observable.of([
        ProfileTableData(image: #imageLiteral(resourceName: "My Listings"), text: "My Listings", count: nil),
        ProfileTableData(image: #imageLiteral(resourceName: "Saved"), text: "Saved Listings", count: nil),
        //ProfileTableData(image: #imageLiteral(resourceName: "My Team"), text: "My Team", count: "2"),
        //ProfileTableData(image: #imageLiteral(resourceName: "Money"), text: "Loan Info", count: nil),
        //ProfileTableData(image: #imageLiteral(resourceName: "Events"), text: "Real Estate Training Events", count: nil),
        ProfileTableData(image: #imageLiteral(resourceName: "Glossary"), text: "Glossary", count: nil)
    ])
    let disposeBag = DisposeBag()
    @IBOutlet weak var tapToProView: UIView!
    @IBOutlet weak var profileInfoView: UIView!
    @IBOutlet weak var avatarImage: AvatarImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
    super.viewDidLoad()
        configureUI()
        
        data.asDriver(onErrorJustReturn:[])
            .drive(tableView.rx.items(cellIdentifier:ProfileViewCell.cellId)) {
                (_, data, cell:ProfileViewCell) in
                cell.configureCell(profileData: data)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ProfileTableData.self)
            .subscribe(onNext: {
                [weak self] in
                if $0.text == "My Listings" {
                    self?.performSegue(withIdentifier: "showListings", sender: $0)
                }
                if $0.text == "Saved Listings" {
                    self?.performSegue(withIdentifier: "showSaved", sender: $0)
                }
                if $0.text == "Glossary" {
                    if let wself = self {
                        let vc = UIStoryboard(name: "Glossary", bundle: nil).instantiateInitialViewController()
                        wself.navigationController?.pushViewController(vc!, animated: true)
                    }
                    
                }
            }).disposed(by: disposeBag)
        Helper.navigationWithGray(self.navigationController!.navigationBar)
        if InAppPurchasesController.default.investorProPriceMonthly == nil {
            InAppPurchasesController.default.getInvestorProInformation(completion: { (products, error) in
            })
        }
    
  }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profile = ClientAPI.currentUser
        configureUI()
    }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
    func configureUI()  {
        profileInfoView.layer.cornerRadius = 5
        profileInfoView.layer.shadowColor = UIColor.lightGray.cgColor
        profileInfoView.layer.shadowOpacity = 0.2
        profileInfoView.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        tapToProView.layer.cornerRadius = 3
        tableView.isScrollEnabled = false
        avatarImage.image = #imageLiteral(resourceName: "tabIconProfile")
        avatarImage.isPresent = false
        if let currentUser = self.profile {
            if let url = URL(string: currentUser.avatar) {
                avatarImage.isPresent = true
                avatarImage.af_setImage(withURL: url)
            }
            nameLabel.text = currentUser.fullName
            addressLabel.text = currentUser.about
            
        }
        else {
            nameLabel.text = ""
            addressLabel.text = ""
        }
        tapToProView.isHidden =  InAppPurchasesController.default.proSubsciptionIsActive
    }
  

    @IBAction func detailAction(_ sender: Any) {
    }
    @IBAction func tapToProAction(_ sender: Any) {
        if !InAppPurchasesController.default.proSubsciptionIsActive {
            byPro(isMonthly: true)
        }
    }
    func byPro(isMonthly:Bool){
        let vc = UIStoryboard(name: "InApps", bundle: nil).instantiateViewController(withIdentifier: "InvestorPro") as! InvestorProViewController
        self.navigationController?.pushViewController(vc, animated: true)
        vc.completion = { [weak self] (success, error) in
            if success {
                self?.configureUI()
            }
            else {
                self?.showWarningAlert(message: (error?.localizedDescription)!)
            }
        }
    }
    @IBAction func logout(sender: UIBarButtonItem){
        ClientAPI.default.signOut()
        AppDelegate.current.showLogin()
    }
    @IBAction func showTutorial(_ sender: Any) {
        AppDelegate.current.showTutorial(continueToLogin: false)
    }
    
}
