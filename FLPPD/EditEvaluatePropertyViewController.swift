//
//  EditEvaluatePropertyViewController.swift
//  FLPPD
//
//  Created by PC on 6/15/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

class EditEvaluatePropertyViewController:EvaluatePropertyViewController{
  var property:Property!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    loadProperty()
    images.asObservable().subscribe(onNext:{[unowned self](images)->Void in
      var photos:[Photo] = []
      for image in images{
        let context = self.coreDataController.persistentContainer.viewContext
        let photo = Photo(context:context)
        photo.imageData = UIImageJPEGRepresentation(image.image, 0)
        photos.append(photo)
      }
      if !photos.isEmpty{
        self.property.thumbnail = self.images.value[0].image
        self.property.photos = NSOrderedSet(array: photos)
      }else{
        self.property.photos = nil
        self.property.thumbnail = nil
      }
    }).disposed(by: disposeBag)
    bindPropertyStringAttribute(property, textField: propertyFormView.nickNameView.textField, keyPath: "nickname", saveEmpty: true, disposeBag: disposeBag)
    bindPropertyStringAttribute(property, textField: propertyFormView.streetView.textField, keyPath: "street", saveEmpty: false, disposeBag: disposeBag)
    bindPropertyStringAttribute(property, textField: propertyFormView.cityView.textField, keyPath: "city", saveEmpty: false, disposeBag: disposeBag)
    bindPropertyStringAttribute(property, textField: propertyFormView.stateView.textField, keyPath: "state", saveEmpty: false, disposeBag: disposeBag)
    bindPropertyStringAttribute(property, textField: propertyFormView.zipCodeView.textField, keyPath: "zipcode", saveEmpty: false, disposeBag: disposeBag)
    bindPropertyStringAttribute(property, textField: propertyFormView.propertyTypeView.rightTextField, keyPath: "propertyType", saveEmpty: true, disposeBag: disposeBag)
    propertyFormView.numberOfUnitsView.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{Void in
      if self.propertyFormView.propertyTypeView.rightTextField.text == PropertyType.multiFamily{
        if let numberOfUnits = self.propertyFormView.numberOfUnitsView.rightTextField.text, let numberOfUnitsInt = Int32(numberOfUnits), numberOfUnitsInt >= 2{
          self.propertyFormView.numberOfUnitsView.rightTextField.text = String(describing:numberOfUnitsInt)
          self.property.numberOfUnits = numberOfUnitsInt
        }else{
          self.property.numberOfUnits = 2
          self.propertyFormView.numberOfUnitsView.rightTextField.text = "2"
        }
      }
    }).disposed(by: disposeBag)
    
    bindPropertyStringAttribute(property, textField: propertyFormView.bedsView.rightTextField, keyPath: "beds", saveEmpty: true, disposeBag: disposeBag)
    bindPropertyStringAttribute(property, textField: propertyFormView.bathsView.rightTextField, keyPath: "baths", saveEmpty: true, disposeBag: disposeBag)
    bindPropertyStringAttribute(property, textField: propertyFormView.squareFootageView.rightTextField, keyPath: "squareFootage", saveEmpty: true, disposeBag: disposeBag)
    bindPropertyStringAttribute(property, textField: propertyFormView.yearBuiltView.rightTextField, keyPath: "yearBuilt", saveEmpty: true, disposeBag: disposeBag)
    bindPropertyStringAttribute(property, textField: propertyFormView.parkingView.rightTextField, keyPath: "parking", saveEmpty: true, disposeBag: disposeBag)
    bindPropertyStringAttribute(property, textField: propertyFormView.lotSizeView.rightTextField, keyPath: "lotSize", saveEmpty: true, disposeBag: disposeBag)
    propertyFormView.zoningView.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{Void in
      self.property.zoning =  self.propertyFormView.zoningView.rightTextField.text == "YES" ? true : false
    }).disposed(by: disposeBag)
    propertyFormView.descriptionTV.rx.didEndEditing.subscribe(onNext:{Void in
      self.property.propertyDescription = self.propertyFormView.descriptionTV.text
    }).disposed(by: disposeBag)
  }
  private func setupView(){
    view.addSubview(propertyFormView)
    propertyFormView.pinToSuperView()
    title = evalPropertyType == .flip ? "Edit Flip" : "Edit Rental"
  }
  override func copySavedProperty(_ property:Property){
    //be careful, property is the property we are copying from
    //self.property is the current property we are editing
    //we are saving the property everytime we copy it because editingdidend will not get triggered when we set a new text value
    //saving in editingdidend will reduce lag when calling viewwilldisappear
    super.copySavedProperty(property)
    self.property.propertyType = propertyFormView.propertyTypeView.rightTextField.text
    if propertyFormView.propertyTypeView.rightTextField.text == PropertyType.multiFamily{
      self.property.numberOfUnits = Int32(propertyFormView.numberOfUnitsView.rightTextField.text!)!
    }
    self.property.beds = propertyFormView.bedsView.rightTextField.text
    self.property.baths = propertyFormView.bathsView.rightTextField.text
    self.property.squareFootage = propertyFormView.squareFootageView.rightTextField.text
    self.property.yearBuilt = propertyFormView.yearBuiltView.rightTextField.text
    self.property.parking = propertyFormView.parkingView.rightTextField.text
    self.property.lotSize = propertyFormView.lotSizeView.rightTextField.text
    self.property.zoning = propertyFormView.zoningView.rightTextField.text == "YES" ? true : false
    self.property.propertyDescription = propertyFormView.descriptionTV.text
  }
  private func loadProperty(){
    copySavedProperty(property)
    propertyFormView.nickNameView.textField.text = property.nickname
    for value in property.photos!.array{
      guard let photo = value as? Photo, let data = photo.imageData as Data?,let image = UIImage(data:data) else{
        continue
      }
      images.value.append(ImageWithUrl(image: image, url: nil))
    }
    propertyFormView.photosDisplayView.images.value = images.value
    propertyFormView.streetView.textField.text = property.street
    propertyFormView.cityView.textField.text = property.city
    propertyFormView.stateView.textField.text = property.state
    propertyFormView.zipCodeView.textField.text = property.zipcode
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    /*self.coreDataController.saveMainContext()*/
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.evalPropertyType.savedNotification), object: nil)
   }
}
