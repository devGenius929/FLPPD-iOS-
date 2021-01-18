//
//  PropertyDetailViewController.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 8/22/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import KRProgressHUD
import MapKit

class PropertyDetailViewController: UIViewController {
  
  //MARK:- properties
  
  //MARK:- IBOulets
  @IBOutlet final internal var DetailScroll: UIScrollView!
  @IBOutlet weak var avrLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var dotProType: UIImageView!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var detailProLabel: UILabel!
  @IBOutlet weak var fullName: UILabel!
  @IBOutlet weak var pudDatelabel: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var defaultImageView: UIImageView!
  @IBOutlet weak var imageContainerView: UIView!
    internal var multiImageView: ImagePagesViewController?
    
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    internal var property:PropertyViewModel? = nil
  func injectDependencies(property: PropertyViewModel, avatar: UIImage, portrait: UIImage){
    self.property = property
    configureViews = {
      [
      unowned self,
      unowned avatar,
      unowned portrait
      ] in
      
      self.defaultImageView.image = portrait
      self.priceLabel.text = property.price
      self.avrLabel.text = property.arv
      self.dotProType.image = property.iconProType
      self.addressLabel.text = property.street
      self.cityLabel.text = property.city
      self.detailProLabel.text = property.proDetails
      self.pudDatelabel.text = property.pubDate
      self.fullName.text = property.fullName
      self.avatarImageView.image = avatar
      self.descriptionLabel.text = property.descriptionText
        self.pudDatelabel.text = property.pubDate
      self.starButton.isSelected = property.property.starred ?? false
        let currentUser = ClientAPI.currentUser!
        if currentUser.user_id != property.property.user.user_id {
            self.moreButton.isHidden = true
            self.showRestrictionsIfNeeded()
            self.starButton.isHidden = false
        }
        else {
            self.moreButton.isHidden = false
            self.starButton.isHidden = true
        }
    }
    updateImages()
    setupMap()
    if InAppPurchasesController.default.investorProPriceMonthly == nil {
        InAppPurchasesController.default.getInvestorProInformation(completion: { (products, error) in
        })
    }
  }
    func updateImages() {
        if let multiImageView = multiImageView, let property = property?.property {
            multiImageView.imageURLs = property.photos.map({URL(string:$0.image)}).filter({$0 != nil}).map({$0!})
        }
    }
  private var configureViews: ( () -> Void )?
  
  override func viewWillAppear(_ animated: Bool) {
    configureViews?()
    viewConfigurations()
  }
  
  private func viewConfigurations(){
    DetailScroll.contentInset = UIEdgeInsetsMake(0, 0, 60, 0)
    avatarImageView.layer.cornerRadius = avatarImageView.frame.width*0.5
    avatarImageView.layer.masksToBounds = true
    avatarImageView.layer.borderColor = UIColor.white.cgColor
    avatarImageView.layer.borderWidth = 2
  }
  
    @IBAction func startAction(_ sender: Any) {
        if let property = self.property {
            let value = !(property.starred)
            ClientAPI.default.updatePropertyFavorites(property_id: property.propId, setFavorite: value, completion: {[weak self] (success) in
                if success {
                    if let wself = self {
                    wself.starButton.isSelected = value
                        wself.property?.starred = value
                        if value {
                            KRProgressHUD.showMessage("Property saved")
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func moreAction(_ sender: Any) {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "Edit", style: .default) { (action) in
            self.edit()
        }
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                self.warnAboutDelete()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(edit)
        ac.addAction(delete)
        ac.addAction(cancel)
        self.present(ac, animated: true, completion: nil)
        
    }
    func warnAboutDelete(){
        let ac = UIAlertController(title: "Delete", message: "Do you want to delete this property?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.delete()
        }
        ac.addAction(cancel)
        ac.addAction(delete)
        self.present(ac, animated: true, completion: nil)
    }
    func delete(){
        ClientAPI.default.deleteProperty((property?.propId)!, completion: { (success) in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    func edit(){
        let vc = EditListingViewController()
        vc.property_id = property?.propId
        vc.listing = ListingPropertyData.listingData(withProperty: property!.property)
        self.present(vc, animated: true, completion: nil)
        vc.updatedCompletion = { [unowned self] in
            self.afterUpdate()
        }
    }
    func afterUpdate(){
        ClientAPI.default.getPropertyById(property_id: (property?.propId)!) { (property, error) in
            if let property = property {
                let model = PropertyViewModel(property: property)
                self.injectDependencies(property: model,
                                        avatar: self.avatarImageView.image!,
                                        portrait: self.defaultImageView.image!)
                if let img_string = property.default_img, let url = URL(string:img_string) {
                    self.defaultImageView.af_setImage(withURL: url)
                }
            }
        }
        
    }
    @IBAction func tapAvatar(_ sender: Any) {

        if let id =  property?.property.user.user_id, let current_id = ClientAPI.currentUser?.user_id , id != current_id {
        let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            vc.loadUserWithId(id)
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func showRestrictionsIfNeeded() {
        if !InAppPurchasesController.default.proSubsciptionIsActive {
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
            visualEffectView.frame = self.view.bounds.applying(CGAffineTransform(scaleX: 1.5, y: 1.5))
            
            self.parent?.view.addSubview(visualEffectView)
            
            let ac = UIAlertController(title: nil, message: "Upgrading to Investor Pro will provide Investor Pro Privileged access and full property details", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Back", style: .cancel, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            })
            let restore = UIAlertAction(title: "Restore Subscription", style: .default, handler: { [weak self] (action) in
                KRProgressHUD.showMessage("Restoring")
                InAppPurchasesController.default.restorePurchases(completion: { (result) in
                    if result.restoredPurchases.count > 0
                        && result.restoredPurchases.filter({ (purcase) -> Bool in
                            return [InAppPurchasesController.investorProMonthly].contains(purcase.productId)
                        }).count > 0 {
                        DispatchQueue.main.async {
                            visualEffectView.removeFromSuperview()
                        }
                    }
                    else {
                        KRProgressHUD.showMessage("Failed to restore")
                        self?.parent?.navigationController?.popViewController(animated: true)
                    }
                })
            })
            let showInApp = UIAlertAction(title: "Investor Pro", style: .default, handler: { (action) in
                let vc = UIStoryboard(name: "InApps", bundle: nil).instantiateViewController(withIdentifier: "InvestorPro") as! InvestorProViewController
                self.navigationController?.pushViewController(vc, animated: true)
                vc.completion = { [weak self] (success, error) in
                    if success {
                        DispatchQueue.main.async {
                            visualEffectView.removeFromSuperview()
                        }
                    }
                    else {
                    self?.parent?.navigationController?.popViewController(animated: true)
                    }
                }
            })
            ac.addAction(cancel)
            ac.addAction(restore)
            ac.addAction(showInApp)
            self.parent?.present(ac, animated: true, completion: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedImagesView" {
            multiImageView = segue.destination as? ImagePagesViewController
            updateImages()
        }
    }
    func setupMap() {
        if let property = property?.property {
            if let street = property.street,let city = property.city,let state = property.state,let zipCode = property.zip_code{
                let address = street + " " + city + " " + state + " " + String(zipCode)
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(address, completionHandler: {(placemarks,error) -> Void in
                    if let placemark = placemarks?[0]{
                        let mkPlaceMark = MKPlacemark(placemark: placemark)
                        let region = MKCoordinateRegion(center: mkPlaceMark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                        self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                        self.mapView.setRegion(region, animated: false)
                    }
                })
            }
        }
    }
}
