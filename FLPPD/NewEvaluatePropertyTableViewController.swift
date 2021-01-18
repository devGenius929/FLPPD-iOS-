//
//  NewFlipEvalTableViewController.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 1/23/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import CoreData
import RxCocoa
import RxSwift
class NewEvaluatePropertyViewController: EvaluatePropertyViewController{
  private let navBar = UINavigationBar()
  private let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
  private let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
  //properties
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  private func setupView() {
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
    NSLayoutConstraint.activate([navBarTopConstraint,propertyFormTopConstraint])
    let title = evalPropertyType == .flip ? "New Flip" : "New Rental"
    let topItem = UINavigationItem(title: title)
    cancelButton.tintColor = UIColor.darkerGold
    saveButton.tintColor = UIColor.darkerGold
    topItem.leftBarButtonItem = cancelButton
    topItem.rightBarButtonItem = saveButton
    navBar.items = [topItem]
  }
  
  override func setupRx(){
    super.setupRx()
    //MARK: CANCEL BUTTON
    cancelButton.rx.tap.subscribe(onNext:{
      self.dismiss(animated: true, completion: nil)
    }).disposed(by: self.disposeBag)
    //MARK: - SAVE BUTTON
    saveButton.rx.tap.subscribe(onNext:{
      //core data
      let context = self.coreDataController.persistentContainer.newBackgroundContext()
      let property = self.evalPropertyType == EvalPropertyType.flip ? FlipProperty(context:context) : RentalProperty(context: context)
      
      property.nickname = self.propertyFormView.nickNameView.textField.text
      var photos:[Photo] = []
      for image in self.images.value{
        let photo = Photo(context:context)
        photo.imageData = UIImageJPEGRepresentation(image.image , 0)
        photos.append(photo)
      }
      if !photos.isEmpty{
        property.thumbnail = self.images.value[0].image
        property.photos = NSOrderedSet(array: photos)
      }
      guard let street = self.propertyFormView.streetView.textField.text, !street.isEmpty else{
        self.showWarningAlert(message: "Street field cannot be empty!")
        return
      }
      property.street = street
      guard let city = self.propertyFormView.cityView.textField.text, !city.isEmpty else{
        self.showWarningAlert(message: "City field cannot be empty!")
        return
      }
      property.city = city
      guard let state = self.propertyFormView.stateView.textField.text, !state.isEmpty else{
        self.showWarningAlert(message: "State field cannot be empty!")
        return
      }
      property.state = state
      guard let zipcode = self.propertyFormView.zipCodeView.textField.text, !zipcode.isEmpty else{
        self.showWarningAlert(message: "Zipcode field cannot be empty!")
        return
      }
      property.zipcode = zipcode
      property.propertyType = self.propertyFormView.propertyTypeView.rightTextField.text
      if self.propertyFormView.propertyTypeView.rightTextField.text == PropertyType.multiFamily{
        guard let numberOfUnits = self.propertyFormView.numberOfUnitsView.rightTextField.text, let numberOfUnitsInt = Int32(numberOfUnits), numberOfUnitsInt >= 2 else{
          self.showWarningAlert(message: "Multi-Family deal type must have more than 1 unit!")
          return
        }
        property.numberOfUnits = numberOfUnitsInt
      }
      
      property.beds = self.propertyFormView.bedsView.rightTextField.text
      property.baths = self.propertyFormView.bathsView.rightTextField.text
      property.squareFootage = self.propertyFormView.squareFootageView.rightTextField.text
      property.yearBuilt = self.propertyFormView.yearBuiltView.rightTextField.text
      property.parking = self.propertyFormView.parkingView.rightTextField.text
      property.lotSize = self.propertyFormView.lotSizeView.rightTextField.text
      property.zoning =  self.propertyFormView.zoningView.rightTextField.text == "YES" ? true : false
      property.propertyDescription = self.propertyFormView.descriptionTV.text
      
      property.worksheet = self.evalPropertyType == EvalPropertyType.flip ? generateDefaultFlipWorksheet(context: context) : generateDefaultRentalWorksheet(context: context)
      context.perform {
        do{
          try context.save()
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.evalPropertyType.savedNotification), object: nil)
        }catch{
          fatalError("Failure to save context: \(error)")
        }
      }
      self.dismiss(animated: true, completion: nil)
    }).disposed(by: self.disposeBag)
    
    
    
  }
}

