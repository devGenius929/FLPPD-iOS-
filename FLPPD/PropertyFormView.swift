//
//  PropertyFormView.swift
//  FLPPD
//
//  Created by PC on 5/9/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//
//
//  PhotosDisplayView.swift
//  FLPPD
//
//  Created by PC on 5/8/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class PropertyFormView:UIScrollView{
  private enum NumberOfPhotosLimit{
    static let limit = 16
  }
  private let stackView = UIStackView()
  let nickNameView = StandardFormFieldWithNoLeftLabelAndFloatingText()
  let copySavedPropertyView = StandardFormFieldWithSwitch()
  let fromView = StandardFormFieldWithRightTextfield()
  let photosHeaderView = SectionHeaderView()
  let photosDisplayView = PhotosDisplayView()
  let inputPhotosView = InputPhotosView()
  let addressHeaderView = SectionHeaderView()
  let streetView = StandardFormFieldWithNoLeftLabelAndFloatingText()
  let cityView = StandardFormFieldWithNoLeftLabelAndFloatingText()
  let stateView = StandardFormFieldWithNoLeftLabelAndFloatingText()
  let zipCodeView = StandardFormFieldWithNoLeftLabelAndFloatingText()
  let detailsHeaderView = SectionHeaderView()
  let propertyTypeView = StandardFormFieldWithRightTextfield()
  let numberOfUnitsView = StandardFormFieldWithRightTextfield()
  let bedsView = StandardFormFieldWithRightTextfield()
  let bathsView = StandardFormFieldWithRightTextfield()
  let squareFootageView = StandardFormFieldWithFloatingText()
  let yearBuiltView = StandardFormFieldWithRightTextfield()
  let parkingView = StandardFormFieldWithRightTextfield()
  let lotSizeView = StandardFormFieldWithFloatingText()
  let zoningView = StandardFormFieldWithRightTextfield()
  let descriptionHeaderView = SectionHeaderView()
  let descriptionTV = UITextView()
  let keyboardToolbar = FormKeyboardToolbar()
  var photosDisplayViewHeightConstraint:NSLayoutConstraint!
  private let disposeBag = DisposeBag()
  let propertyTypeHeader = SectionHeaderView()
  let listingPropertyTypeView = StandardFormFieldWithDetail()
  let numbersHeader = SectionHeaderView()
  let purchasePriceView = StandardFormFieldWithFloatingText()
  let arvView = StandardFormFieldWithFloatingText()
  let rehabCostView = StandardFormFieldWithFloatingText()
  let rentalRatingView = StandardFormFieldWithFloatingText()
  let listingTypeHeader = SectionHeaderView()
  let listingTypeView = StandardFormFieldWithTextFieldAndChevron()
    var descriptionTVHeightConstraint:NSLayoutConstraint?
  var textInputs:[UIView] = []
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  func setupView() {
    addSubview(stackView)
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fill
    self.backgroundColor = UIColor.groupTableViewBackground
    stackView.pinToSuperView()
    let widthConstraint = NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
    let views:[UIView] = [nickNameView,copySavedPropertyView,fromView,photosHeaderView,photosDisplayView,inputPhotosView,addressHeaderView,streetView,cityView,stateView,zipCodeView,detailsHeaderView,propertyTypeView,numberOfUnitsView,bedsView,bathsView,squareFootageView,yearBuiltView,parkingView,lotSizeView,zoningView,descriptionHeaderView,descriptionTV,propertyTypeHeader,listingPropertyTypeView,numbersHeader,purchasePriceView,arvView,rehabCostView,rentalRatingView,listingTypeHeader,listingTypeView]
    for view in views{
      stackView.addArrangedSubview(view)
    }
    let viewsWith44HeightConstraint:[UIView] = [nickNameView,copySavedPropertyView,fromView,photosHeaderView,addressHeaderView,streetView,cityView,stateView,zipCodeView,detailsHeaderView,propertyTypeView,numberOfUnitsView,bedsView,bathsView,squareFootageView,yearBuiltView,parkingView,lotSizeView,zoningView,descriptionHeaderView,propertyTypeHeader,listingPropertyTypeView,numbersHeader,purchasePriceView,arvView,rehabCostView,rentalRatingView,listingTypeHeader,listingTypeView]
    for view in viewsWith44HeightConstraint{
      view.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    }
    inputPhotosView.setHeightConstraint(140, priority: UILayoutPriority(rawValue: 999))
    descriptionTVHeightConstraint = NSLayoutConstraint(item: descriptionTV, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44)
    descriptionTV.translatesAutoresizingMaskIntoConstraints = false
    
    nickNameView.textField.placeholder = "Nickname"
    copySavedPropertyView.leftLabel.text = "Copy saved Property"
    fromView.leftLabel.text = "From"
    fromView.rightTextField.placeholder = "--:--"
    photosHeaderView.headerLabel.text = "PHOTOS"
    addressHeaderView.headerLabel.text = "ADDRESS"
    streetView.textField.placeholder = "Street"
    cityView.textField.placeholder = "City"
    stateView.textField.placeholder = "State/Region"
    zipCodeView.textField.placeholder = "Zip/Postal Code"
    detailsHeaderView.headerLabel.text = "DETAILS"
    propertyTypeView.leftLabel.text = "Property Type"
    propertyTypeView.rightTextField.placeholder = "--:--"
    numberOfUnitsView.leftLabel.text = "Number of Units"
    numberOfUnitsView.rightTextField.placeholder = "--:--"
    numberOfUnitsView.textFieldValueType.value = .SetAmount
    bedsView.leftLabel.text = "Beds"
    bedsView.rightTextField.placeholder = "--:--"
    bathsView.leftLabel.text = "Bath"
    bathsView.rightTextField.placeholder = "--:--"
    squareFootageView.leftLabel.text = "Square Footage"
    squareFootageView.rightTextField.placeholder = "Square Feet"
    squareFootageView.textFieldValueType.value = .SetAmount
    yearBuiltView.leftLabel.text = "Year Built"
    yearBuiltView.rightTextField.placeholder = "--:--"
    parkingView.leftLabel.text = "Parking"
    parkingView.rightTextField.placeholder = "--:--"
    lotSizeView.leftLabel.text = "Lot Size"
    lotSizeView.rightTextField.placeholder = "Square Feet"
    lotSizeView.textFieldValueType.value = .SetAmount
    zoningView.leftLabel.text = "Zoning"
    zoningView.rightTextField.placeholder = "--:--"
    descriptionHeaderView.headerLabel.text = "DESCRIPTION"
    descriptionTV.isScrollEnabled = false
    propertyTypeHeader.headerLabel.text = "RENTAL OR FLIP"
    listingPropertyTypeView.leftLabel.text = "Deal Type"
    numbersHeader.headerLabel.text = "NUMBERS"
    purchasePriceView.leftLabel.text = "Purchase Price"
    purchasePriceView.textFieldValueType.value = .SetAmount
    purchasePriceView.rightTextField.placeholder = "$"
    arvView.leftLabel.text = "After Repair Value"
    arvView.textFieldValueType.value = .SetAmount
    arvView.rightTextField.placeholder = "$"
    rehabCostView.leftLabel.text = "Rehab Cost"
    rehabCostView.textFieldValueType.value = .SetAmount
    rehabCostView.rightTextField.placeholder = "$"
    rentalRatingView.leftLabel.text = "Rental Rating"
    rentalRatingView.textFieldValueType.value = .SetAmount
    rentalRatingView.rightTextField.placeholder = "$"
    listingTypeHeader.headerLabel.text = "LISTING TYPE"
    listingTypeView.textField.text = "Basic (Free)"
    let viewsWithSeparatorLeftInset:[UIView] = [copySavedPropertyView,fromView,cityView,stateView,zipCodeView,numberOfUnitsView,bedsView,bathsView,squareFootageView,yearBuiltView,parkingView,lotSizeView,zoningView,arvView,rehabCostView,rentalRatingView]
    for view in viewsWithSeparatorLeftInset{
      view.addTopSeparator(0.5, rightInset: 0, leftInset: 16, color: UIColor.lightGray)
    }
    let viewsWithoutSeparatorInset:[UIView] = [nickNameView,photosHeaderView,addressHeaderView,inputPhotosView,streetView,detailsHeaderView,propertyTypeView,descriptionHeaderView,propertyTypeHeader,listingPropertyTypeView,numbersHeader,purchasePriceView,listingTypeHeader,listingTypeView]
    for view in viewsWithoutSeparatorInset{
      view.addTopSeparator(0.5, rightInset: 0, leftInset: 0, color: UIColor.lightGray)
    }
    photosDisplayView.translatesAutoresizingMaskIntoConstraints = false
    photosDisplayViewHeightConstraint = NSLayoutConstraint(item: photosDisplayView, attribute: .height, relatedBy: .equal, toItem: self.stackView, attribute: .width, multiplier: (3/4), constant: 0)
    //lower the height priority so it doesn't conflict when we hide the view
    photosDisplayViewHeightConstraint.priority = UILayoutPriority(rawValue: 999)
    NSLayoutConstraint.activate([widthConstraint,photosDisplayViewHeightConstraint,descriptionTVHeightConstraint!])
    
    descriptionTV.rx.text.subscribe({[unowned self] event in
        self.updateDescriptionHeight()
    }).disposed(by: disposeBag)
    
    photosDisplayView.images.asObservable().subscribe(onNext:{[unowned self](images)->Void in
      if images.count == 0{
        self.photosDisplayView.isHidden = true
      }else{
        self.photosDisplayView.isHidden = false
        if images.count == NumberOfPhotosLimit.limit{
          self.inputPhotosView.isHidden = true
        }else{
          self.inputPhotosView.isHidden = false
        }
      }
    }).disposed(by: disposeBag)
    
    textInputs += [nickNameView.textField,fromView.rightTextField,streetView.textField,cityView.textField,stateView.textField,zipCodeView.textField,propertyTypeView.rightTextField,numberOfUnitsView.rightTextField,bedsView.rightTextField,bathsView.rightTextField,squareFootageView.rightTextField,yearBuiltView.rightTextField,parkingView.rightTextField,lotSizeView.rightTextField,zoningView.rightTextField,descriptionTV,listingPropertyTypeView.rightTextField,purchasePriceView.rightTextField,arvView.rightTextField,rehabCostView.rightTextField,rentalRatingView.rightTextField,listingTypeView.textField]

    //Handle keyboard popup
    NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillShow).subscribe(onNext:{[unowned self](notification)->Void in
      guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else{
        return
      }
      let contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height + 18, 0)
      self.contentInset = contentInset
      self.scrollIndicatorInsets = contentInset
    }).disposed(by: disposeBag)
    //Handle keyboard hide
    NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillHide).subscribe(onNext:{[unowned self](notification)->Void in
      let contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
      self.contentInset = contentInset
      self.scrollIndicatorInsets = contentInset
    }).disposed(by: disposeBag)
    //Mark: setup copy saved property
    copySavedPropertyView.rightSwitch.isOn = false
    copySavedPropertyView.rightSwitch.rx.isOn.subscribe(onNext:{[unowned self](isOn)->Void in
      self.fromView.isHidden = isOn ? false : true
      if !isOn{
        self.fromView.rightTextField.resignFirstResponder()
      }
    }).disposed(by: disposeBag)
    
    setupKeyboardToolbar()
  }
  
  func setupKeyboardToolbar(){
    for tf in textInputs{
      if let tf = tf as? UITextField{
        tf.inputAccessoryView = keyboardToolbar
      }else if let tv = tf as? UITextView{
        tv.inputAccessoryView = keyboardToolbar
      }
    }
    keyboardToolbar.doneButton.rx.tap.subscribe(onNext:{[unowned self] Void in
      self.endEditing(true)
    }).disposed(by: disposeBag)
    
    keyboardToolbar.previousButton.rx.tap.subscribe(onNext:{[unowned self] Void in
      var prevTF:UIView?
      for (index,tf) in self.textInputs.enumerated(){
        if tf.isFirstResponder,index != 0{
          for i in (0...(index - 1)).reversed(){
            let possiblePrevTF = self.textInputs[i]
            if let superview = possiblePrevTF.superview,!superview.isHidden,let superSuperview = superview.superview,!superSuperview.isHidden{
              prevTF = possiblePrevTF
              break
            }
          }
          break
        }
      }
      if let prevTF = prevTF{
        prevTF.becomeFirstResponder()
      }else{
        for i in (0...(self.textInputs.count - 1)).reversed(){
          let possiblePrevTF = self.textInputs[i]
          if let superview = possiblePrevTF.superview,!superview.isHidden,let superSuperview = superview.superview,!superSuperview.isHidden{
            prevTF = possiblePrevTF
            break
          }
        }
        guard let prevTF = prevTF else{
          return
        }
        prevTF.becomeFirstResponder()
      }
    }).disposed(by: disposeBag)
    
    keyboardToolbar.nextButton.rx.tap.subscribe(onNext:{[unowned self] Void in
      var nextTF:UIView?
      for (index,tf) in self.textInputs.enumerated(){
        if tf.isFirstResponder,index != self.textInputs.count - 1{
          for i in (index+1)...self.textInputs.count - 1{
            let possibleNextTF = self.textInputs[i]
            if let superview = possibleNextTF.superview,!superview.isHidden,let superSuperview = superview.superview,!superSuperview.isHidden{
              nextTF = possibleNextTF
              break
            }
          }
          break
        }
      }
      if let nextTF = nextTF{
        nextTF.becomeFirstResponder()
      }else{
        for i in 0...self.textInputs.count - 1{
          let possibleNextTF = self.textInputs[i]
          if let superview = possibleNextTF.superview,!superview.isHidden,let superSuperview = superview.superview,!superSuperview.isHidden{
            nextTF = possibleNextTF
            break
          }
        }
        guard let nextTF = nextTF else{
          return
        }
        nextTF.becomeFirstResponder()
      }
    }).disposed(by: disposeBag)
  }
  private func setupTapRx(tap:UITapGestureRecognizer,textField:UITextField){
    //when the cell is tapped
    tap.rx.event.subscribe(onNext:{(tap)->Void in
      textField.becomeFirstResponder()
    }).disposed(by: disposeBag)
  }
    func updateDescriptionHeight() {
        var size = self.descriptionTV.sizeThatFits(CGSize(width:descriptionTV.bounds.width, height:CGFloat.greatestFiniteMagnitude))
        if size.height < 44 {
            size.height = 44
        }
        descriptionTVHeightConstraint!.constant = size.height
    }
}
