//
//  ReportView.swift
//  FLPPD
//
//  Created by PC on 7/22/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class ReportView:UIScrollView{
  private let keyboardToolbar = FormKeyboardToolbar()
  private let disposeBag = DisposeBag()
  private let stackView = UIStackView()
  private let reportDetailHeader = SectionHeaderViewWithDetail()
  let viewReportView = StandardFormFieldWithDetailAndIcon()
  private let settingsHeader = SectionHeaderView()
  let includeWorksheetView = StandardFormFieldWithSwitch()
  private let includeWorksheetFooter = SectionHeaderViewWithDetail()
  let includeMapView = StandardFormFieldWithSwitch()
  private let includeMapFooter = SectionHeaderViewWithDetail()
  let includePhotoView = StandardFormFieldWithSwitch()
  private let includePhotoFooter = SectionHeaderViewWithDetail()
  let preparedByView = StandardFormFieldWithRightTextfield()
  private let prepareByFooter = SectionHeaderViewWithDetail()
  let contactDetailsView = UITextViewWithPlaceholder()
  private let contactDetailsFooter = SectionHeaderViewWithDetail()
  let logoView = StandardFormFieldWithImageView()
  private let logoFooter = SectionHeaderViewWithDetail()
  let hideBranding = StandardFormFieldWithSwitch()
  private let hideBrandingFooter = SectionHeaderViewWithDetail()
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  func setupView() {
    self.backgroundColor = UIColor.groupTableViewBackground
    //MARK:Main Stackview
    addSubview(stackView)
    stackView.axis = .vertical
    stackView.pinToSuperView()
    stackView.pinWidthToSuperview()
    let views = [reportDetailHeader,viewReportView,settingsHeader,includeWorksheetView,includeWorksheetFooter,includeMapView,includeMapFooter,includePhotoView,includePhotoFooter,preparedByView,prepareByFooter,contactDetailsView,contactDetailsFooter,logoView,logoFooter,hideBranding,hideBrandingFooter]
    for view in views{
      stackView.addArrangedSubview(view)
      if view != reportDetailHeader{
        view.addTopSeparator(0.5, rightInset: 0, leftInset: 0, color: UIColor.lightGray)
      }
    }
    reportDetailHeader.detailLabel.text = "Create a professional PDF report to share with your lenders, partners or clients."
    reportDetailHeader.setHeightConstraint(84, priority: UILayoutPriority(rawValue: 1000))
    viewReportView.titleIcon.image = UIImage(named: "eye")
    viewReportView.leftLabel.text = "View Report"
    viewReportView.rightTextField.isUserInteractionEnabled = false
    viewReportView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    settingsHeader.headerLabel.text = "SETTINGS"
    settingsHeader.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    includeWorksheetView.leftLabel.text = "Include Worksheet"
    includeWorksheetView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    includeWorksheetFooter.detailLabel.text = "Enable to include itemize purchase costs, rehab costs, income and expenses."
    includeWorksheetFooter.setHeightConstraint(84, priority: UILayoutPriority(rawValue: 1000))
    includeMapView.leftLabel.text = "Include Maps"
    includeMapView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    includeMapFooter.detailLabel.text = "Enable to include satellite and street maps of the property address."
    includeMapFooter.setHeightConstraint(84, priority: UILayoutPriority(rawValue: 1000))
    includePhotoView.leftLabel.text = "Include Photos"
    includePhotoView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    includePhotoFooter.detailLabel.text = "Enable to include property photos"
    includePhotoFooter.headerLabel.text = "BRANDING"
    includePhotoFooter.setHeightConstraint(106, priority: UILayoutPriority(rawValue: 1000))
    preparedByView.leftLabel.text = "Prepared by:"
    preparedByView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    let leftConstraint = NSLayoutConstraint(item: preparedByView.rightTextField, attribute: .leading, relatedBy: .equal, toItem: preparedByView.leftLabel, attribute: .trailing, multiplier: 1, constant: 0)
    NSLayoutConstraint.activate([leftConstraint])
    prepareByFooter.detailLabel.text = "Fill in your personal or business name to display on the front page and in the headers of all other pages."
    prepareByFooter.setHeightConstraint(106, priority: UILayoutPriority(rawValue: 1000))
    let contactDetailsViewHeightContraint = NSLayoutConstraint(item: contactDetailsView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 120)
    contactDetailsView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([contactDetailsViewHeightContraint])
    contactDetailsView.placeholder.value = "Contact details..."
    contactDetailsFooter.detailLabel.text = "Fill in your contact information to display on the front page. Only the first 5 lines will be shown."
    contactDetailsFooter.setHeightConstraint(84, priority: UILayoutPriority(rawValue: 1000))
    logoView.leftLabel.text = "Logo:"
    logoFooter.detailLabel.text = "Select a logo to display on the front page. For best results, upload an image at least 150 px in height."
    logoFooter.setHeightConstraint(84, priority: UILayoutPriority(rawValue: 1000))
    hideBranding.leftLabel.text = "Hide FLPPD Branding"
    hideBranding.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    hideBrandingFooter.detailLabel.text = "Enable to remove all references to FLPPD from the report."
    hideBrandingFooter.setHeightConstraint(84, priority: UILayoutPriority(rawValue: 1000))
    //setup keyboard toolbar
    preparedByView.rightTextField.inputAccessoryView = keyboardToolbar
    contactDetailsView.inputAccessoryView = keyboardToolbar
    keyboardToolbar.doneButton.rx.tap.subscribe(onNext:{[unowned self] Void in
      self.endEditing(true)
    }).disposed(by: disposeBag)
    preparedByView.rightTextField.rx.controlEvent([.editingDidBegin]).subscribe(onNext:{[unowned self] Void in
      self.keyboardToolbar.nextButton.isEnabled = true
      self.keyboardToolbar.previousButton.isEnabled = false
    }).disposed(by: disposeBag)
    contactDetailsView.rx.didBeginEditing.subscribe(onNext:{[unowned self] Void in
      self.keyboardToolbar.nextButton.isEnabled = false
      self.keyboardToolbar.previousButton.isEnabled = true
    }).disposed(by: disposeBag)

    keyboardToolbar.previousButton.rx.tap.subscribe(onNext:{[unowned self] Void in
      self.preparedByView.rightTextField.becomeFirstResponder()
    }).disposed(by: disposeBag)
    
    keyboardToolbar.nextButton.rx.tap.subscribe(onNext:{[unowned self] Void in
      self.contactDetailsView.becomeFirstResponder()
    }).disposed(by: disposeBag)
    NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillShow).subscribe(onNext:{[unowned self](notification)->Void in
      guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else{
        return
      }
      let contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height + 18, 0)
      self.contentInset = contentInset
      self.scrollIndicatorInsets = contentInset
    }).disposed(by: disposeBag)
    NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillHide).subscribe(onNext:{[unowned self](notification)->Void in
      self.contentInset = .zero
      self.scrollIndicatorInsets = .zero
    }).disposed(by: disposeBag)
  }
}
