//
//  ReportViewController.swift
//  FLPPD
//
//  Created by PC on 7/22/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import Photos
import RxSwift
class ReportViewController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  var property:Property!
  private let reportView = ReportView()
  private let disposeBag = DisposeBag()
  private let image:Variable<UIImage?> = Variable(nil)
  private let report = Report()
  private let shareButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: nil, action: nil)
  let imagePicker = UIImagePickerController()
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    report.property.value = property
  }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            return
        }
        self.image.value = image
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
  private func setupView(){
    view.addSubview(reportView)
    navigationItem.setRightBarButton(shareButton, animated: false)
    title = "Report"
    reportView.pinToSuperView()
    imagePicker.allowsEditing = false

       imagePicker.delegate = self
   /* imagePicker.rx.delegate.methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:))).subscribe(onNext:{(data)->Void in
      guard let dict = data[1] as? [String:Any] else{
        return
      }
      guard let image = dict[UIImagePickerControllerOriginalImage] as? UIImage else{
        return
      }
      self.image.value = image
      self.imagePicker.dismiss(animated: true, completion: nil)
    }).disposed(by: disposeBag)
    */
    shareButton.rx.tap.subscribe(onNext:{[unowned self] Void in
      let filename = "report.pdf"
      if let file = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(filename),FileManager.default.fileExists(atPath: file.path){
        let viewController = UIActivityViewController(activityItems: [file], applicationActivities: nil)
        self.present(viewController, animated: true, completion: nil)
      }
    }).disposed(by: disposeBag)
    
    image.asObservable().subscribe(onNext:{[unowned self](image)->Void in
      self.reportView.logoView.image.value = image
      self.report.logo.value = image
    }).disposed(by: disposeBag)
    
    reportView.viewReportView.selectedGesture.rx.event.subscribe(onNext:{[unowned self] Void in
      let vc = PreviewViewController()
      vc.html = self.report.finalHtml
      self.navigationController?.present(vc, animated: true, completion: nil)
    }).disposed(by: disposeBag)
    
    //MARK:Include photos
    reportView.includeWorksheetView.rightSwitch.rx.isOn.subscribe(onNext:{[unowned self] isOn in
      self.report.includeWorksheet.value = isOn
    }).disposed(by: disposeBag)
    reportView.includePhotoView.rightSwitch.rx.isOn.subscribe(onNext:{[unowned self] isOn in
      self.report.includePhotos.value = isOn
    }).disposed(by: disposeBag)
    reportView.includeMapView.rightSwitch.rx.isOn.subscribe(onNext:{[unowned self] isOn in
      self.report.includeMaps.value = isOn
    }).disposed(by: disposeBag)
    //MARK:Prepared by
    reportView.preparedByView.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{Void in
      self.report.preparedBy.value = self.reportView.preparedByView.rightTextField.text
    }).disposed(by: disposeBag)
    reportView.contactDetailsView.rx.didEndEditing.subscribe(onNext:{Void in
      var contactDetails:String? =  self.reportView.contactDetailsView.text
      if self.reportView.contactDetailsView.showPlaceholder.value{
        contactDetails = nil
      }
      self.report.contactDetails.value = contactDetails
    }).disposed(by: disposeBag)
    reportView.logoView.cameraButton.rx.tap.subscribe(onNext:{[unowned self](event)->Void in
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
        self.launchPhotoLibrary()
      }
    }).disposed(by: disposeBag)
    reportView.logoView.deleteButton.rx.tap.subscribe(onNext:{[unowned self](event)->Void in
      self.image.value = nil
    }).disposed(by: disposeBag)
    //MARK:Hide branding
    reportView.hideBranding.rightSwitch.rx.isOn.subscribe(onNext:{isOn in
      self.report.hideBranding.value = isOn
    }).disposed(by: disposeBag)

  }
  
  private func launchPhotoLibrary(){
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
}
