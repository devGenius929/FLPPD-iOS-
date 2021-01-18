//
//  EditListingViewController.swift
//  FLPPD
//
//  Created by PC on 10/3/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import RxSwift
import KRProgressHUD

class EditListingViewController:EvaluatePropertyViewController{
    var listing:ListingPropertyData? = nil{
        didSet{
            setupView()
        }
    }
    var updatedCompletion:(() -> Void)? = nil
    var property_id:Int?
    private var consumePlatinum = false
    private let navBar = UINavigationBar()
    private let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    private let saveButton = UIBarButtonItem(title: "Save", style:.plain , target: nil, action: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    private func configureViews(){
        propertyFormView.rentalRatingView.isHidden = true
        propertyFormView.propertyTypeHeader.isHidden = false
        propertyFormView.listingPropertyTypeView.isHidden = false
        propertyFormView.numbersHeader.isHidden = false
        propertyFormView.purchasePriceView.isHidden = false
        propertyFormView.arvView.isHidden = false
        propertyFormView.rehabCostView.isHidden = false
        propertyFormView.listingTypeHeader.isHidden = true
        propertyFormView.listingTypeView.isHidden = true
        view.addSubview(navBar)
        view.addSubview(propertyFormView)
        navBar.barTintColor = UIColor.white
        cancelButton.rx.tap.subscribe(onNext:{
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        let navBarTopConstraint = NSLayoutConstraint(item: navBar, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        navBar.setLeadingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
        navBar.setTrailingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
        //property form
        let propertyFormTopConstraint = NSLayoutConstraint(item: propertyFormView, attribute: .top, relatedBy: .equal, toItem: navBar, attribute: .bottom, multiplier: 1, constant: 0)
        propertyFormView.setBottomInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
        propertyFormView.setLeadingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
        propertyFormView.setTrailingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
        propertyFormView.nickNameView.isHidden = true
        propertyFormView.streetView.textField.isEnabled = false
        propertyFormView.cityView.textField.isEnabled = false
        propertyFormView.stateView.textField.isEnabled = false
        propertyFormView.zipCodeView.textField.isEnabled = false
        NSLayoutConstraint.activate([navBarTopConstraint,propertyFormTopConstraint])
        let title = "Edit Listing"
        let topItem = UINavigationItem(title: title)
        cancelButton.tintColor = UIColor.darkerGold
        saveButton.tintColor = UIColor.darkerGold
        topItem.leftBarButtonItem = cancelButton
        topItem.rightBarButtonItem = saveButton
        navBar.items = [topItem]
    }
    private func setupView(){
        guard let listing = self.listing else {
            return
        }
        if let image_urls = listing.photo_data?.components(separatedBy: ",").map({URL(string:$0)}).filter({$0 != nil}), image_urls.count > 0 {
            DispatchQueue.global(qos: .background).async {
                var imagesWithUrl = [ImageWithUrl]()
                for url in image_urls {
                    if let url = url, let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            let imageWithUrl = ImageWithUrl(image: image, url: url)
                            imagesWithUrl.append(imageWithUrl)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.images.value = imagesWithUrl
                    self.propertyFormView.photosDisplayView.images.value = imagesWithUrl
                }
                
            }
        }
        propertyFormView.purchasePriceView.rightTextField.text = String(listing.price )
        propertyFormView.arvView.rightTextField.text = String(listing.arv )
        propertyFormView.rehabCostView.rightTextField.text = listing.rehub_cost != nil ? "\(listing.rehub_cost!)" : "0"
        propertyFormView.rentalRatingView.rightTextField.text = "0"
        propertyFormView.streetView.textField.text = listing.street
        propertyFormView.cityView.textField.text = listing.city
        propertyFormView.stateView.textField.text = listing.state
        propertyFormView.zipCodeView.textField.text = listing.zip_code
        propertyFormView.propertyTypeView.rightTextField.text = listing.property_category
        propertyFormView.listingPropertyTypeView.rightTextField.text = listing.PropertyType_id == 1 ? ListingPropertyType.rental :  ListingPropertyType.flip
        propertyFormView.bedsView.rightTextField.text = listing.nbeds
        propertyFormView.bathsView.rightTextField.text = listing.nbath
        propertyFormView.squareFootageView.rightTextField.text = "\(listing.sqft ?? 0)"
        propertyFormView.yearBuiltView.rightTextField.text = "\(listing.year_built ?? 0)"
        propertyFormView.parkingView.rightTextField.text = listing.parking
        propertyFormView.zoningView.rightTextField.text = listing.zoning
        propertyFormView.descriptionTV.text = listing.description
        propertyFormView.lotSizeView.rightTextField.text = "\(listing.lot_size ?? 0)"
        propertyFormView.purchasePriceView.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{[unowned self] Void in
            guard let purchasePriceStr = self.propertyFormView.purchasePriceView.rightTextField.text,let purchasePrice = Int(purchasePriceStr) else{
                self.propertyFormView.purchasePriceView.rightTextField.text = "0"
                self.listing?.price = 0
                return
            }
            self.propertyFormView.purchasePriceView.rightTextField.text = purchasePrice.formatDecimal()
            self.listing?.price = purchasePrice
        }).disposed(by: disposeBag)
        
        propertyFormView.rehabCostView.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{[unowned self] Void in
            guard let Str = self.propertyFormView.rehabCostView.rightTextField.text,let Price = Int(Str) else{
                self.propertyFormView.rehabCostView.rightTextField.text = "0"
                self.listing?.rehub_cost = 0
                return
            }
            self.propertyFormView.rehabCostView.rightTextField.text = Price.formatDecimal()
            self.listing?.rehub_cost = Price
        }).disposed(by: disposeBag)
        
        propertyFormView.arvView.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{[unowned self] Void in
            guard let arvStr = self.propertyFormView.arvView.rightTextField.text, !arvStr.isEmpty,let arv = Int(arvStr) else{
                self.propertyFormView.arvView.rightTextField.text = String(listing.arv )
                return
            }
            self.propertyFormView.arvView.rightTextField.text = arv.formatDecimal()
            self.listing?.arv = arv
        }).disposed(by: disposeBag)
        
        propertyFormView.rentalRatingView.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{[unowned self] Void in
            guard let rentalRatingStr = self.propertyFormView.rentalRatingView.rightTextField.text,let rentalRating = Int(rentalRatingStr) else{
                self.propertyFormView.rentalRatingView.rightTextField.text = String(listing.rental_rating!)
                return
            }
            self.propertyFormView.rentalRatingView.rightTextField.text = rentalRating.formatDecimal()
            self.listing?.rental_rating = rentalRating
        }).disposed(by: disposeBag)
        
        saveButton.rx.tap.flatMapLatest({[unowned self]()->Observable<String?> in
            guard let listing = self.listing else {
                return Observable.just(nil)
            }
            guard let _ = self.images.value.first else{
                return Observable.just("Insert at least 1 property photo")
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
            let _listingType = listing.PropertyListing_id
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
            var price:Int = 0
            if let priceStr = self.propertyFormView.purchasePriceView.rightTextField.text, let priceStrInt = Int(priceStr){
                price = priceStrInt
            }
            var rehub_cost:Int = 0
            if let rehubStr = self.propertyFormView.rehabCostView.rightTextField.text, let rehubStrInt = Int(rehubStr){
                rehub_cost = rehubStrInt
            }
            var arv:Int = 0
            if let arvStr = self.propertyFormView.arvView.rightTextField.text, let arvStrInt = Int(arvStr){
                arv = arvStrInt
            }
            let propertyType = self.propertyFormView.listingPropertyTypeView.rightTextField.text! == ListingPropertyType.rental ? 1 : 2
            let rentalRating:Int? = listing.rental_rating == 1 ? listing.rental_rating : nil
            let images = self.images.value.filter({$0.url == nil}).map({$0.image})
            let uploader = UploadMultiImages(images: images)
            DispatchQueue.main.async {
                KRProgressHUD.showMessage("Updating...")
            }
            uploader.start(completion: {[unowned self] (urls) in
                var image_urls = urls.filter { $0 != nil }.map({$0!})
                if image_urls.count > 0 {
                    // places this urls to imageAndUrl's array
                    var i = 0
                    for (index, imageAndUrl) in self.images.value.enumerated() {
                        if imageAndUrl.url == nil {
                            self.images.value[index].url = image_urls[i]
                            i += 1
                        }
                    }
                }
                let urls_strings = self.images.value.map({$0.url!.absoluteString}).joined(separator: ",")
                let defaultImage = self.images.value.first!.url!.absoluteString
                let propertyData = ListingPropertyData(price: price,
                                                       arv: arv,
                                                       rehub_cost: rehub_cost,
                                                       street: listing.street,
                                                       city: listing.city,
                                                       state: listing.street,
                                                       zip_code: listing.zip_code,
                                                       property_category: propertyCategory,
                                                       number_unit:numberOfUnits,
                                                       year_built: yearBuilt,
                                                       parking: self.propertyFormView.parkingView.rightTextField.text,
                                                       lot_size: lotSize,
                                                       zoning: self.propertyFormView.zoningView.rightTextField.text,
                                                       nbeds: self.propertyFormView.bedsView.rightTextField.text, nbath: self.propertyFormView.bathsView.rightTextField.text, sqft:sqft , rental_rating: rentalRating, PropertyType_id:propertyType, PropertyListing_id: _listingType, description:description, defaultimage: defaultImage, photo_data: urls_strings)
                
                let property = ListingProperty(property: propertyData)
                
                updateProperty(property_id: self.property_id!, property: property, consumePlatinum:self.consumePlatinum)?.subscribe(onNext:{[unowned self](response)->Void in
                    DispatchQueue.main.async {
                        KRProgressHUD.dismiss()
                    }
                    guard let message = response else{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newProperties"), object: nil)
                        if let completion = self.updatedCompletion {
                            completion()
                        }
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
