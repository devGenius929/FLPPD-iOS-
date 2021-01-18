//
//  NewListingViewController.swift
//  FLPPD
//
//  Created by PC on 10/3/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import RxSwift
import KRProgressHUD

struct ListingPropertyData:Encodable{
  var price:Int
  var arv:Int
    var rehub_cost:Int?
    var street:String? {
        didSet {
            street = street?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    var city:String?{
        didSet {
            city = city?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    var state:String?{
        didSet {
            state = state?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
  var zip_code:String?
  var property_category:String?
  var number_unit:Int?
  var year_built:Int?
  var parking:String?
  var lot_size:Int?
  var zoning:String?
  var nbeds:String?
  var nbath:String?
  var sqft:Int?
  var rental_rating:Int?
  var PropertyType_id:Int
  var PropertyListing_id:Int
  var description:String?
  var defaultimage:String
  var photo_data:String?
    static func listingData(withProperty property:FLPPDProperty) -> ListingPropertyData {
        return ListingPropertyData(price: property.price!,
                                   arv: property.arv!,
                                   rehub_cost: property.rehub_cost,
                                   street: property.street!,
                                   city: property.city!,
                                   state: property.state!,
                                   zip_code:  String(property.zip_code ?? 0),
                                   property_category: property.property_category,
                                   number_unit: property.number_unit,
                                   year_built: Int(property.year_built ?? 0),
                                   parking: property.parking,
                                   lot_size: Int(property.lot_size ?? "0"),
                                   zoning: property.zoning,
                                   nbeds: property.nbeds,
                                   nbath: property.nbath,
                                   sqft: property.sqft,
                                   rental_rating:nil,
                                   PropertyType_id: property.property_type_id,
                                   PropertyListing_id: property.property_listing_id,
                                   description: property.description,
                                   defaultimage: property.default_img!,
                                   photo_data: property.photos.map({$0.image}).joined(separator: ","))
        
    }
}
struct ListingProperty:Encodable{
  var property:ListingPropertyData
}
class NewListingViewController:EvaluatePropertyViewController{
  private let navBar = UINavigationBar()
  private let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
  private let listButton = UIBarButtonItem(title: "List", style:.plain , target: nil, action: nil)
  private var price = 0
    private var rehub_cost = 0
  private var arv = 0
  private var rentalRating = 0
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    cancelButton.rx.tap.subscribe(onNext:{
      self.dismiss(animated: true, completion: nil)
    }).disposed(by: disposeBag)
  }
  private func setupView(){
    propertyFormView.rentalRatingView.isHidden = true
    propertyFormView.propertyTypeHeader.isHidden = false
    propertyFormView.listingPropertyTypeView.isHidden = false
    propertyFormView.numbersHeader.isHidden = false
    propertyFormView.purchasePriceView.isHidden = false
    propertyFormView.arvView.isHidden = false
    propertyFormView.rehabCostView.isHidden = false
    propertyFormView.listingTypeHeader.isHidden = false
    propertyFormView.listingTypeView.isHidden = false
    view.addSubview(navBar)
    view.addSubview(propertyFormView)
    navBar.barTintColor = UIColor.white
    let navBarTopConstraint = NSLayoutConstraint(item: navBar, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
    navBar.setLeadingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    navBar.setTrailingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    
    //property form
    let propertyFormTopConstraint = NSLayoutConstraint(item: propertyFormView, attribute: .top, relatedBy: .equal, toItem: navBar, attribute: .bottom, multiplier: 1, constant: 0)
    propertyFormView.setBottomInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    propertyFormView.setLeadingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    propertyFormView.setTrailingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    propertyFormView.nickNameView.isHidden = true
    propertyFormView.purchasePriceView.rightTextField.text = "0"
    propertyFormView.arvView.rightTextField.text = "0"
    propertyFormView.rehabCostView.rightTextField.text = "0"
    propertyFormView.rentalRatingView.rightTextField.text = "0"
    NSLayoutConstraint.activate([navBarTopConstraint,propertyFormTopConstraint])
    let title = "New FLPPD Listing"
    let topItem = UINavigationItem(title: title)
    cancelButton.tintColor = UIColor.darkerGold
    listButton.tintColor = UIColor.darkerGold
    topItem.leftBarButtonItem = cancelButton
    topItem.rightBarButtonItem = listButton
    navBar.items = [topItem]
    
    propertyFormView.listingPropertyTypeView.rightTextField.text = ListingPropertyType.flip
    propertyFormView.purchasePriceView.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{[unowned self] Void in
      guard let purchasePriceStr = self.propertyFormView.purchasePriceView.rightTextField.text,let purchasePrice = Int(purchasePriceStr) else{
        self.propertyFormView.purchasePriceView.rightTextField.text = "0"
        self.price = 0
        return
      }
      self.propertyFormView.purchasePriceView.rightTextField.text = purchasePrice.formatDecimal()
      self.price = purchasePrice
    }).disposed(by: disposeBag)
    
    propertyFormView.rehabCostView.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{[unowned self] Void in
        guard let PriceStr = self.propertyFormView.rehabCostView.rightTextField.text,let Price = Int(PriceStr) else{
            self.propertyFormView.rehabCostView.rightTextField.text = "0"
            self.rehub_cost = 0
            return
        }
        self.propertyFormView.rehabCostView.rightTextField.text = Price.formatDecimal()
        self.rehub_cost = Price
    }).disposed(by: disposeBag)
    
    propertyFormView.arvView.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{[unowned self] Void in
      guard let arvStr = self.propertyFormView.arvView.rightTextField.text, !arvStr.isEmpty,let arv = Int(arvStr) else{
        self.propertyFormView.arvView.rightTextField.text = "0"
        self.arv = 0
        return
      }
      self.propertyFormView.arvView.rightTextField.text = arv.formatDecimal()
      self.arv = arv
    }).disposed(by: disposeBag)
    
    propertyFormView.rentalRatingView.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{[unowned self] Void in
      guard let rentalRatingStr = self.propertyFormView.rentalRatingView.rightTextField.text,let rentalRating = Int(rentalRatingStr) else{
        self.propertyFormView.rentalRatingView.rightTextField.text = "0"
        self.rentalRating = 0
        return
      }
      self.propertyFormView.rentalRatingView.rightTextField.text = rentalRating.formatDecimal()
      self.rentalRating = rentalRating
    }).disposed(by: disposeBag)
    
    listButton.rx.tap.flatMapLatest({[unowned self]()->Observable<String?> in
      guard let _ = self.images.value.first else{
        return Observable.just("Insert at least 1 property photo")
      }
      guard let street = self.propertyFormView.streetView.textField.text,!street.isEmpty else{
        return Observable.just("Street cannot be empty!")
      }
      guard let city = self.propertyFormView.cityView.textField.text,!city.isEmpty else{
        return Observable.just("City cannot be empty!")
      }
      guard let state = self.propertyFormView.stateView.textField.text,!state.isEmpty else{
        return Observable.just("State cannot be empty!")
      }
      guard let zipcode = self.propertyFormView.zipCodeView.textField.text,!zipcode.isEmpty else{
        return Observable.just("Zipcode cannot be empty!")
      }
      var propertyCategory:String? = nil
      var numberOfUnits:Int? = nil
      var sqft:Int? = nil
      var yearBuilt:Int? = nil
      var lotSize:Int? = nil
      var description:String? = nil
      if let propertyCategoryStr = self.propertyFormView.propertyTypeView.rightTextField.text, !propertyCategoryStr.isEmpty{
        propertyCategory = propertyCategoryStr
        if propertyCategoryStr == PropertyType.multiFamily{
          if let numberOfUnitsStr = self.propertyFormView.numberOfUnitsView.rightTextField.text,let numberOfUnitsInt = Int(numberOfUnitsStr),numberOfUnitsInt > 1{
            numberOfUnits = numberOfUnitsInt
          }else{
            return Observable.just("For a multi-family property, the number of units must be greater than 1.")
          }
        }
      }
      let listingType = self.propertyFormView.listingTypeView.textField.text! == ListingType.basic ? 1 : 2
        if listingType == 2 && !InAppPurchasesController.default.consumePlatinum(){
            InAppPurchasesController.default.purchasePlatinumListing(completion: { (success, error) in
                if let error = error {
                    self.showWarningAlert(message: error.localizedDescription)
                }
                else {
                    self.showAlert(title: "Platinum", message: "Success", completion: {
                        if let sel = self.listButton.action {
                            if self.canPerformAction(sel, withSender: self.listButton){
                                self.perform(sel)
                            }
                        }
                    })
                }
            })
            return Observable.just("")
        }
      if let sqftStr = self.propertyFormView.squareFootageView.rightTextField.text, let sqftInt = Int(sqftStr){
        sqft = sqftInt
      }
      if let yearBuiltStr = self.propertyFormView.yearBuiltView.rightTextField.text, let yearBuiltInt = Int(yearBuiltStr){
        yearBuilt = yearBuiltInt
      }
      if let lotSizeStr = self.propertyFormView.lotSizeView.rightTextField.text, let lotSizeInt = Int(lotSizeStr){
        lotSize = lotSizeInt
      }
      if !self.propertyFormView.descriptionTV.text.isEmpty {
        description = self.propertyFormView.descriptionTV.text
      }
      let propertyType = self.propertyFormView.listingPropertyTypeView.rightTextField.text! == ListingPropertyType.rental ? 1 : 2
      let rentalRating:Int? = propertyType == 1 ? self.rentalRating : nil
        let images = self.images.value.map({$0.image})
        let uploader = UploadMultiImages(images: images)
        DispatchQueue.main.async {
            KRProgressHUD.show(withMessage: "Sending...", completion: nil)
        }
        uploader.start(completion: {[unowned self] (urls) in
            let image_urls = urls.filter { $0 != nil }.map({ $0!.absoluteString})
            let urls_strings = image_urls.joined(separator: ",")
            let propertyData = ListingPropertyData(price: self.price, arv: self.arv, rehub_cost: self.rehub_cost, street: street, city: city, state: state, zip_code: zipcode, property_category: propertyCategory, number_unit:numberOfUnits , year_built: yearBuilt, parking: self.propertyFormView.parkingView.rightTextField.text, lot_size: lotSize, zoning: self.propertyFormView.zoningView.rightTextField.text, nbeds: self.propertyFormView.bedsView.rightTextField.text, nbath: self.propertyFormView.bathsView.rightTextField.text, sqft:sqft , rental_rating: rentalRating, PropertyType_id:propertyType, PropertyListing_id: listingType, description:description, defaultimage: image_urls.first!, photo_data: urls_strings)
            let property = ListingProperty(property: propertyData)
            
            createPropertyListing(property: property)?.subscribe(onNext:{[unowned self](response)->Void in
                DispatchQueue.main.async {
                    KRProgressHUD.dismiss()
                }
                guard let message = response else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newProperties"), object: nil)
                    self.dismiss(animated: true, completion:nil)
                    return
                }
                if !message.isEmpty {
                    DispatchQueue.main.async(execute: {
                        self.showWarningAlert(message: message)
                    })
                }
            }).disposed(by: self.disposeBag)
            
        })

      
      return Observable.just(nil)
    }).subscribe(onNext:{[unowned self](response)->Void in
      guard let message = response else{
        return
      }
        if !message.isEmpty {
            DispatchQueue.main.async(execute: {
                self.showWarningAlert(message: message)
            })
        }
      }).disposed(by: disposeBag)
  }
  override func getSavedProperty() {
    //do nothing here
    //dont erase
  }
}
