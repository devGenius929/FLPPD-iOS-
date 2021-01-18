//
//  EvaluatePropertyViewController.swift
//  FLPPD
//
//  Created by PC on 6/15/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import CoreData
import RxCocoa
import RxSwift

struct ImageWithUrl {
    let image:UIImage
    var url:URL?
}

class EvaluatePropertyViewController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  //lets and var
  fileprivate enum PickerViewTag{
    static let from = 5
    static let propertyType = 6
    static let numberOfBeds = 7
    static let numberOfBaths = 8
    static let yearBuilt = 9
    static let parking = 10
    static let zoning = 11
    static let listingPropertyType = 12
    static let listingType = 13
  }
  enum PropertyType{
    static let singleFamily = "Single Family"
    static let townHouse = "TownHouse/Condo"
    static let lot = "Lot"
    static let multiFamily = "Multi-Family"
    static let countryHomes = "Country Homes/Acreage"
    static let midHiRise = "Mid/Hi-Rise Condo"
  }
  enum ListingPropertyType{
    static let rental = "Rental"
    static let flip  = "Flip"
  }
  enum ListingType{
    static let platinumS = "Platinum (%@)"
    static let platinumBasic = "Platinum (%@)"
    static let basic = "Basic (Free)"
    }
  var evalPropertyType = EvalPropertyType.flip
  var coreDataController:CoreDataController!
  let disposeBag = DisposeBag()
  fileprivate let propertyType = [PropertyType.singleFamily, PropertyType.townHouse, PropertyType.lot, PropertyType.multiFamily, PropertyType.countryHomes,PropertyType.midHiRise]
  fileprivate let yearBuilt = Array<String>.getYearFrom1900ToPresent()
  fileprivate let numberOfBathAndBeds = ["0", "1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5", "6", "6.5", "7", "7.5", "8", "8.5", "9", "9.5", "10", "10+"]
  fileprivate let parking = ["Attached Garage", "Detached Garage", "Oversized Garage", "Attached/Detached Garage", "Tandem", "No Parking", "Parking Lot"]
    private var platinumPrice = "$24.99"
  fileprivate let zoning = ["Yes","No"]
  fileprivate let listingPropertyType = [ListingPropertyType.rental,ListingPropertyType.flip]
    private var listingType:[String] {
        get {
            let platinum = String(format:"Platinum (%@)", platinumPrice)
            return [ListingType.basic, platinum]
        }
    }
  let propertyFormView = PropertyFormView()
  let imagePicker = UIImagePickerController()
  private let pickerView = UIPickerView()
  private let propertyTypePickerView = UIPickerView()
  let properties:Variable<[Property]> = Variable([])
  private var currentTextField: UITextField?
  let images:Variable<[ImageWithUrl]> = Variable([])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    InAppPurchasesController.default.getPlatinumListingInformation {[weak self] (product, error) in
        if let product = product {
            self?.platinumPrice = product.localizedPrice ?? "$24.99"
        }
    }
    propertyFormView.propertyTypeHeader.isHidden = true
    propertyFormView.listingPropertyTypeView.isHidden = true
    propertyFormView.numbersHeader.isHidden = true
    propertyFormView.purchasePriceView.isHidden = true
    propertyFormView.arvView.isHidden = true
    propertyFormView.rehabCostView.isHidden = true
    propertyFormView.rentalRatingView.isHidden = true
    propertyFormView.listingTypeHeader.isHidden = true
    propertyFormView.listingTypeView.isHidden = true
    view.backgroundColor = UIColor.white
    pickerView.delegate = self
    pickerView.dataSource = self
    imagePicker.allowsEditing = false
    setupRx()
    getSavedProperty()
    self.propertyFormView.numberOfUnitsView.isHidden = true
    //prepare textfield
    let textFieldsThatRespondWithPickerView:[UITextField] = [propertyFormView.fromView.rightTextField,propertyFormView.propertyTypeView.rightTextField,propertyFormView.bedsView.rightTextField,propertyFormView.bathsView.rightTextField,propertyFormView.yearBuiltView.rightTextField,propertyFormView.parkingView.rightTextField,propertyFormView.zoningView.rightTextField,propertyFormView.listingPropertyTypeView.rightTextField,propertyFormView.listingTypeView.textField]
    
    for tf in textFieldsThatRespondWithPickerView{
      tf.inputView = pickerView
    }
  }
  
  func getSavedProperty(){
    do{
      self.properties.value = try coreDataController.persistentContainer.viewContext.fetch(Property.fetchRequest())
    }catch{
      
    }
  }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            return
        }
        self.images.value.append(ImageWithUrl(image: image, url: nil))
        self.propertyFormView.photosDisplayView.images.value = self.images.value
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
  func setupRx(){
    //MARK:Copy saved properties
    properties.asObservable().subscribe(onNext:{[unowned self](properties)->Void in
      self.propertyFormView.copySavedPropertyView.isHidden = properties.isEmpty ? true : false
    }).disposed(by: disposeBag)
    
    propertyFormView.inputPhotosView.useCameraTap.rx.event.subscribe(onNext:{[unowned self] Void in
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
        self.launchCamera()
      }
    }).disposed(by: disposeBag)
    
    propertyFormView.inputPhotosView.fromFileTap.rx.event.subscribe(onNext:{[unowned self](event)->Void in
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
        self.launchPhotoLibrary()
      }
    }).disposed(by: disposeBag)
    //MARK: imagePicker delegate
    imagePicker.delegate = self
    propertyFormView.photosDisplayView.deleteButtonTap.asObservable().subscribe(onNext:{[unowned self](index)->Void in
      guard let index = index else{
        return
      }
      let confirmDelete = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
      let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      let delete = UIAlertAction(title: "Delete", style: .default, handler: {Void in
        self.images.value.remove(at: index)
        self.propertyFormView.photosDisplayView.images.value = self.images.value
      })
      confirmDelete.addAction(cancel)
      confirmDelete.addAction(delete)
      self.present(confirmDelete, animated: true, completion: nil)
    }).disposed(by: disposeBag)
    
    //MARK:Make textfield respond with pickerview
    setupTFPickerView(textField: propertyFormView.fromView.rightTextField, tag: PickerViewTag.from)
    setupTFPickerView(textField: propertyFormView.propertyTypeView.rightTextField, tag: PickerViewTag.propertyType)
    setupTFPickerView(textField: propertyFormView.bedsView.rightTextField, tag: PickerViewTag.numberOfBeds)
    setupTFPickerView(textField: propertyFormView.bathsView.rightTextField, tag: PickerViewTag.numberOfBaths)
   
    setupTFPickerView(textField: propertyFormView.yearBuiltView.rightTextField, tag: PickerViewTag.yearBuilt, selected: yearBuilt.count-1)
    
    setupTFPickerView(textField: propertyFormView.parkingView.rightTextField, tag: PickerViewTag.parking)
    setupTFPickerView(textField: propertyFormView.zoningView.rightTextField, tag: PickerViewTag.zoning)
    setupTFPickerView(textField: propertyFormView.listingPropertyTypeView.rightTextField, tag: PickerViewTag.listingPropertyType)
    setupTFPickerView(textField: propertyFormView.listingTypeView.textField, tag: PickerViewTag.listingType)
    //MARK: pickerView selected
    pickerView.rx.itemSelected.subscribe(onNext:{[unowned self](row,component)->Void in
      switch self.pickerView.tag{
      case PickerViewTag.from:
        self.propertyFormView.fromView.rightTextField.text = self.properties.value[row].street
        self.copySavedProperty(self.properties.value[row])
      case PickerViewTag.propertyType:
        self.propertyFormView.propertyTypeView.rightTextField.text = self.propertyType[row]
        self.propertyFormView.numberOfUnitsView.isHidden = self.propertyType[row] == PropertyType.multiFamily ? false : true
      case PickerViewTag.numberOfBeds:
        self.propertyFormView.bedsView.rightTextField.text = self.numberOfBathAndBeds[row]
      case PickerViewTag.numberOfBaths:
        self.propertyFormView.bathsView.rightTextField.text = self.numberOfBathAndBeds[row]
      case PickerViewTag.yearBuilt:
        self.propertyFormView.yearBuiltView.rightTextField.text = self.yearBuilt[row]
      case PickerViewTag.parking:
        self.propertyFormView.parkingView.rightTextField.text = self.parking[row]
      case PickerViewTag.zoning:
        self.propertyFormView.zoningView.rightTextField.text = self.zoning[row]
      case PickerViewTag.listingPropertyType:
        let listingPropertyType = self.listingPropertyType[row]
        self.propertyFormView.listingPropertyTypeView.rightTextField.text = listingPropertyType
        self.propertyFormView.rentalRatingView.isHidden = listingPropertyType == ListingPropertyType.flip
      case PickerViewTag.listingType:
        self.propertyFormView.listingTypeView.textField.text = self.listingType[row]
      default: return
      }
    }).disposed(by: self.disposeBag)
    
    
  }
  func copySavedProperty(_ property:Property){
    self.propertyFormView.propertyTypeView.rightTextField.text = property.propertyType
    self.propertyFormView.numberOfUnitsView.isHidden = property.propertyType == PropertyType.multiFamily ? false : true
    self.propertyFormView.numberOfUnitsView.rightTextField.text = property.numberOfUnits != 0 ? String(property.numberOfUnits) : ""
    self.propertyFormView.bedsView.rightTextField.text = property.beds
    self.propertyFormView.bathsView.rightTextField.text = property.baths
    self.propertyFormView.squareFootageView.rightTextField.text = property.squareFootage
    self.propertyFormView.yearBuiltView.rightTextField.text = property.yearBuilt
    self.propertyFormView.parkingView.rightTextField.text = property.parking
    self.propertyFormView.lotSizeView.rightTextField.text = property.lotSize
    self.propertyFormView.zoningView.rightTextField.text = property.zoning ? "Yes" : "No"
    self.propertyFormView.descriptionTV.text = property.propertyDescription
  }
    private func setupTFPickerView(textField:UITextField,tag:Int, selected:Int = 0){
    //when textfield becomes first responder, the pickerView is reloaded
    textField.rx.controlEvent([.editingDidBegin]).asObservable().subscribe(onNext:{[unowned self]()->Void in
      self.pickerView.tag = tag
        self.pickerView.reloadAllComponents()
        if selected < self.pickerView.numberOfRows(inComponent: 0) {
            self.pickerView.selectRow(selected, inComponent: 0, animated: false)
        }
    }).disposed(by: disposeBag)
  }
  
  func launchPhotoLibrary(){
    self.imagePicker.sourceType = .photoLibrary
    if PHPhotoLibrary.authorizationStatus() == .authorized {
      self.present(imagePicker, animated: true, completion: nil)
    }else{
      PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
        if status == .authorized {
          DispatchQueue.main.async(execute: {[unowned self]()->Void in
            self.present(self.imagePicker, animated: true, completion: nil)
          })
        } else {
          self.showOpenSettingsAlert(message: "FLPPD needs permission to access your photo library to select a photo. Please go to Settings > Privacy > Photos, and enable FLLPD.")
        }
      })
    }
  }
  func launchCamera(){
    let alertMessage = "FLPPD needs permission to access your device's camera to take a photo. Please go to Settings > Privacy > Camera, and enable FLLPD."
    switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video){
    case .denied :
      return self.showOpenSettingsAlert(message: alertMessage)
    case .restricted:
      self.showOpenSettingsAlert(message: alertMessage)
    case .authorized:
      self.imagePicker.sourceType = .camera
      DispatchQueue.main.async(execute: {[unowned self]()->Void in
        self.present(self.imagePicker, animated: true, completion: nil)
      })
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {Void in
        self.launchCamera()
      })
    }
  }
}
extension EvaluatePropertyViewController:UIPickerViewDataSource,UIPickerViewDelegate{
  // MARK: - pickerView
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    switch pickerView.tag{
    case PickerViewTag.from:
      return self.properties.value.count
    case PickerViewTag.propertyType:
      return self.propertyType.count
    case PickerViewTag.numberOfBeds:
      return self.numberOfBathAndBeds.count
    case PickerViewTag.numberOfBaths:
      return self.numberOfBathAndBeds.count
    case PickerViewTag.yearBuilt:
      return self.yearBuilt.count
    case PickerViewTag.parking:
      return self.parking.count
    case PickerViewTag.zoning:
      return self.zoning.count
    case PickerViewTag.listingPropertyType:
      return self.listingPropertyType.count
    case PickerViewTag.listingType:
      return self.listingType.count
    default: return 0
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    switch pickerView.tag{
    case PickerViewTag.from:
      return self.properties.value[row].street
    case PickerViewTag.propertyType:
      return self.propertyType[row]
    case PickerViewTag.numberOfBeds:
      return self.numberOfBathAndBeds[row]
    case PickerViewTag.numberOfBaths:
      return self.numberOfBathAndBeds[row]
    case PickerViewTag.yearBuilt:
      return self.yearBuilt[row]
    case PickerViewTag.parking:
      return self.parking[row]
    case PickerViewTag.zoning:
      return self.zoning[row]
    case PickerViewTag.listingPropertyType:
      return self.listingPropertyType[row]
    case PickerViewTag.listingType:
      return self.listingType[row]
    default: return nil
    }
  }
}

extension UIViewController{
  //MARK: Helper methods
  func showOpenSettingsAlert(message:String){
    let permissionRequiredAlert = UIAlertController(title: "Permission Required", message: message, preferredStyle: .alert)
    let notNow = UIAlertAction(title: "Not Now", style: .cancel, handler: nil)
    let openSettings = UIAlertAction(title: "Open Settings", style: .default, handler: {Void in
      UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
    })
    permissionRequiredAlert.addAction(notNow)
    permissionRequiredAlert.addAction(openSettings)
    DispatchQueue.main.async(execute: {[unowned self]()->Void in
      self.present(permissionRequiredAlert, animated: true, completion: nil)
    })
    
  }
  func showWarningAlert(message:String){
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(ok)
    self.present(alert, animated: true, completion: nil)
  }
    func showAlert(title:String, message:String, completion:(() -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            completion?()
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    func showError(_ error:Error){
        let message = error.localizedDescription
        if let data = message.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: data, options:
                JSONSerialization.ReadingOptions.allowFragments),
            let dict = json as? [String:String],
            let error_string = dict["error"] {
            self.showWarningAlert(message: error_string.capitalized)
        }
        else {
            self.showWarningAlert(message: error.localizedDescription)
        }
    }
}
