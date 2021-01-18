//
//  DetailPropertiesViewController.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 4/12/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit

class DetailPropertiesViewController: UITableViewController {
  
  //porperties
  var property: AnyObject?
  var viewPresented = false
  
  private let tableStreachyHeaderViewHeight: CGFloat = 145.0
  private let tableStreachyHeaderViewCutAway: CGFloat = 0.0
  var headerView: StrechyHeaderView!
  var overlay: UIView!
  var navBar: UINavigationBar!
  var statusBar: UIView!
  
  //outlets
  @IBOutlet weak var firstTableViewCell: UITableViewCell!
  @IBOutlet weak var backButtomItem: UIBarButtonItem!
  
  @IBOutlet weak var arvLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var dotImageView: UIImageView!
  @IBOutlet weak var streetLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!
  @IBOutlet weak var postedByLabel: UILabel!
  @IBOutlet weak var datePubLabel: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var informationLabel: VerticalTopAlignLabel!
  
  
  //MARK:- view methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //call set view
    if let property = property as? FLPPDPropertyViewModel{
      self.setUpViewWith(property)
    }else{
      dprint("Error")
      navigationController?.popToRootViewController(animated: false)
    }
    
    navBar = navigationController?.navigationBar
    
    //table configuration
    
    let footer = UIView()
    footer.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 69, width: tableView.frame.width, height: 69)
    footer.backgroundColor = UIColor.white
    
    navigationController?.view.addSubview(footer)
    
    //status bar
    
    statusBar = UIView()
    statusBar.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20)
    statusBar.backgroundColor = Colors.navBlackColor
    statusBar.alpha = 0
    navigationController?.view.addSubview(statusBar)
    
    //table header
    headerView = tableView.tableHeaderView as! StrechyHeaderView
    headerView.imageView.clipsToBounds = false
    tableView.tableHeaderView = nil
    tableView.addSubview(headerView)
    tableView.sendSubview(toBack: headerView)
    
    tableView.contentInset = UIEdgeInsets(top: tableStreachyHeaderViewHeight, left: 0, bottom: 0, right: 0)
    tableView.contentOffset = CGPoint(x: 0, y: -tableStreachyHeaderViewHeight)
    
    let effectiveHeight = tableStreachyHeaderViewHeight - tableStreachyHeaderViewCutAway/2
    tableView.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
    tableView.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
    
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    firstTableViewCell.roundCorners([.topLeft, .topRight], radius: 10)
  }
  
  func updateHeaderView(){
    let effectiveheight = tableStreachyHeaderViewHeight - tableStreachyHeaderViewCutAway/2
    var headerRect = CGRect(x: 0, y: -effectiveheight, width: tableView.bounds.width, height: tableStreachyHeaderViewHeight)
    
    
    if tableView.contentOffset.y < -effectiveheight{
      headerRect.origin.y = tableView.contentOffset.y
      headerRect.size.height = -tableView.contentOffset.y + tableStreachyHeaderViewCutAway/2
    }
    
    if overlay != nil{
      overlay.removeFromSuperview()
    }
    
    overlay = UIView(frame: CGRect(x: 0, y: 0, width: headerRect.width, height: headerRect.height + 50))
    overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
    headerView.addSubview(overlay)
    
    headerView.frame = headerRect
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UIApplication.shared.statusBarStyle = .default
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    Helper.navigationClearDetailVIew(navBar)
    UIApplication.shared.statusBarStyle = .lightContent
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewPresented = true
  }
  
  //MARK:- setup views
  func setUpViewWith(_ property: FLPPDPropertyViewModel){
    self.headerView.image = property.defaultImage
    //header labels (price and avr)
    priceLabel.text = "$\(property.flppdProperty.price ?? 0)"
    priceLabel.layer.zPosition = 2
    
    arvLabel.text = "ARV: $\(property.flppdProperty.arv ?? 0)"
    arvLabel.layer.zPosition = 2
    
    dotImageView.image = #imageLiteral(resourceName: "flipDealDot")
    dotImageView.layer.zPosition = 2
    
    if property.flppdProperty.property_type_id == 1{
      dotImageView.image = #imageLiteral(resourceName: "reantalDealDot")
    }else{
      dotImageView.image = #imageLiteral(resourceName: "flipDealDot")
    }
    
    //street, city and details
    
    streetLabel.text = "\(property.flppdProperty.street ?? "")"
    cityLabel.text = "\(property.flppdProperty.city ?? ""), \(property.flppdProperty.state ?? "") \(property.flppdProperty.zip_code ?? 0)"
    detailLabel.text = "\(property.flppdProperty.nbeds ?? "") beds • \(property.flppdProperty.nbath ?? "") baths • \(property.flppdProperty.sqft ?? 0) sqtf"
    
    //postedby, pubdate, avatar
    
    postedByLabel.text = "Posted by \(property.flppdProperty.first_name ?? "") \(property.flppdProperty.last_name ?? "")"
    datePubLabel.text = "\(property.flppdProperty.pudDate ?? "")"
    self.avatarImageView.image = property.avatar
    //description
    
    informationLabel.text = property.flppdProperty.description ?? "No Description."
    
  }
  
  //MARK:- Closeview
  @IBAction func closeView(sender: UIBarButtonItem){
    self.dismiss(animated: true, completion: nil)
  }
  
}

extension DetailPropertiesViewController{
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    updateHeaderView()
    
    if tableView.contentOffset.y < -UIScreen.main.bounds.height/1.9 && viewPresented == true{
      self.dismiss(animated: true, completion: nil)
    }
    
    
    if tableView.contentOffset.y > -19 && viewPresented == true{
      UIView.animate(withDuration: 0.3, animations: {
        self.statusBar.alpha = 1
        self.backButtomItem.image = #imageLiteral(resourceName: "backArrowBackgroung")
      })
    }else{
        self.statusBar.alpha = 0
        self.backButtomItem.image = #imageLiteral(resourceName: " Back Arrow")
    }
    
    //Descomment this out if you want a full navBar
    //    if tableView.contentOffset.y > -60 && viewPresented == true && navIsHidde == true{
    //      let imageColor = UIImage.imageWithColor(tintColor: UIColor.black)
    //      navBar.alpha = 0
    //
    //      UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
    //        self.navBar.setBackgroundImage(imageColor, for: .default)
    //        self.navBar.isTranslucent = false
    //        self.navBar.alpha = 1
    //      })
    //    }else{
    //      self.navIsHidde = true
    //      navBar.isTranslucent = true
    //      navBar.setBackgroundImage(UIImage(), for: .default)
    //      navBar.backgroundColor = UIColor.clear
    //    }
    
  }
  
}









