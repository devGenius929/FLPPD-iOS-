//
//  EvalPropertyDetailViewController.swift
//  FLPPD
//
//  Created by PC on 5/19/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import CoreData
import KRProgressHUD

class EvalDetailViewController:UIViewController{
  var editContext:NSManagedObjectContext!
  var property:Property!
  var coreDataController:CoreDataController!
  var evalPropertyType:EvalPropertyType = .flip
  private var disposeBag = DisposeBag()
  private let mainDisposeBag = DisposeBag()
  private let deleteButton = UIBarButtonItem(image: UIImage(named:"trashShape"), style: .plain, target: nil, action: nil)
  private let evalPropertyDetailView = EvalPropertyDetailView()
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    navigationItem.rightBarButtonItem = deleteButton
    navigationItem.title = evalPropertyType == EvalPropertyType.flip ? "Flip" : "Rental"
    view.addSubview(evalPropertyDetailView)
    evalPropertyDetailView.pinToSuperView()
    evalPropertyDetailView.projectionsView.isHidden = evalPropertyType == .flip ? true : false
    property.rx.observe(Any.self, "thumbnail").subscribe(onNext:{[unowned self](image)->Void in
      guard let image = image as? UIImage else{
        self.evalPropertyDetailView.thumbnailView.image = UIImage(named:"placeHolder")
        return
      }
      self.evalPropertyDetailView.thumbnailView.image = image
    }).disposed(by: mainDisposeBag)
    
    //MARK:Street
    property.rx.observe(String.self, "street").subscribe(onNext:{[unowned self](street)->Void in
      self.evalPropertyDetailView.streetAddressLabel.text = street!
    }).disposed(by: mainDisposeBag)
    //MARK:City
    property.rx.observe(String.self, "city").subscribe(onNext:{[unowned self](city)->Void in
      self.evalPropertyDetailView.cityStateLabel.text = city! + ", " + self.property.state!
    }).disposed(by: mainDisposeBag)
    
    property.rx.observe(String.self, "state").subscribe(onNext:{[unowned self](state)->Void in
      self.evalPropertyDetailView.cityStateLabel.text = self.property.city! + ", " + state!
    }).disposed(by: mainDisposeBag)
    
    evalPropertyDetailView.mapCellTap.rx.event.subscribe(onNext:{[unowned self] Void in
      let vc = EvalMapViewController()
      vc.property = self.property
      self.navigationController?.pushViewController(vc, animated: true)
    }).disposed(by: mainDisposeBag)
    evalPropertyDetailView.worksheetCellTap.rx.event.subscribe(onNext:{[unowned self] Void in
      let vc = EvalPropertyWorksheetViewController()
      vc.coreDataController = self.coreDataController
      vc.property = self.property
      self.navigationController?.pushViewController(vc, animated: true)
    }).disposed(by: mainDisposeBag)
    deleteButton.rx.tap.subscribe(onNext:{[unowned self] Void in
      let alert = UIAlertController(title: "Delete property permanently?", message: "This action cannot be undone", preferredStyle: .actionSheet)
      let delete = UIAlertAction(title: "Delete", style: .destructive, handler: {Void in
        self.coreDataController.persistentContainer.viewContext.delete(self.property)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.evalPropertyType.savedNotification), object: nil)
        self.navigationController?.popViewController(animated: true)
      })
      let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      alert.addAction(cancel)
      alert.addAction(delete)
      self.present(alert, animated: true, completion: nil)
    }).disposed(by: mainDisposeBag)
    evalPropertyDetailView.propertyMainViewTap.rx.event.subscribe(onNext:{[unowned self] Void in
      let vc = EditEvaluatePropertyViewController()
      vc.property = self.property
      vc.coreDataController = self.coreDataController
      vc.evalPropertyType = self.evalPropertyType
      self.navigationController?.pushViewController(vc, animated: true)
    }).disposed(by: mainDisposeBag)
    
    evalPropertyDetailView.summaryAnalysisCellTap.rx.event.subscribe(onNext:{[unowned self] Void in
      let vc = SummaryAnalysisViewController()
      vc.property = self.property
      self.navigationController?.pushViewController(vc, animated: true)
    }).disposed(by: mainDisposeBag)
    evalPropertyDetailView.projectionsCellTap.rx.event.subscribe(onNext:{[unowned self] Void in
      let vc = ProjectionsViewController()
      vc.property = self.property
      self.navigationController?.pushViewController(vc, animated: true)
    }).disposed(by: mainDisposeBag)
    evalPropertyDetailView.reportCellTap.rx.event.subscribe(onNext:{[unowned self] Void in
      let vc = ReportViewController()
      vc.property = self.property
      self.navigationController?.pushViewController(vc, animated: true)
    }).disposed(by: mainDisposeBag)
    evalPropertyDetailView.priceLabel.textColor = evalPropertyType == .flip ? UIColor.darkgreen : UIColor.darkerGold
    property.rx.observe(Worksheet.self, "worksheet").subscribe(onNext:{[unowned self](worksheet)->Void in
      if let worksheet = worksheet {
        self.setupWorksheet(worksheet)
      }
    }).disposed(by: mainDisposeBag)
    evalPropertyDetailView.upgradeButton.rx.tap.subscribe(onNext:{[unowned self] Void in
        self.showRestrictionsIfNeeded()
    }).disposed(by: mainDisposeBag)

    evalPropertyDetailView.upgradeButton2.rx.tap.subscribe(onNext:{[unowned self] Void in
        self.showRestrictionsIfNeeded()
    }).disposed(by: mainDisposeBag)
  }
    func showRestrictionsIfNeeded() {
        if !InAppPurchasesController.default.proSubsciptionIsActive {
            let ac = UIAlertController(title: "I want to upgrade", message: "Upgrading to Investor Pro will provide Investor Pro Privileged access and full property details", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            })
            let restore = UIAlertAction(title: "Restore Subscription", style: .default, handler: { [weak self] (action) in
                KRProgressHUD.showMessage("Restoring")
                InAppPurchasesController.default.restorePurchases(completion: { (result) in
                    if result.restoredPurchases.count > 0
                        && result.restoredPurchases.filter({ (purcase) -> Bool in
                            return [InAppPurchasesController.investorProMonthly].contains(purcase.productId)
                        }).count > 0 {
                        DispatchQueue.main.async {
                            self?.evalPropertyDetailView.setupReport(enabled: true)
                        }
                    }
                    else {
                        KRProgressHUD.showMessage("Failed...")
                    }
                })
            })
            let buyMonth = UIAlertAction(title: "Purchase Investor Pro", style: .default, handler: { [weak self] (action) in
                KRProgressHUD.showMessage("Sending request...")
                InAppPurchasesController.default.purchaseInvestorPro(isMonthly: true, completion: { (success, error) in
                    if success {
                        DispatchQueue.main.async {
                            self?.evalPropertyDetailView.setupReport(enabled: true)
                        }
                    }
                    else {
                        KRProgressHUD.showMessage("Failed...")
                    }
                })
            })
            ac.addAction(cancel)
            ac.addAction(restore)
            ac.addAction(buyMonth)
            self.parent?.present(ac, animated: true, completion: nil)
        }
    }
  func setupWorksheet(_ worksheet:Worksheet){
    disposeBag = DisposeBag()
    worksheet.rx.observe(NSDecimalNumber.self, "purchasePrice").subscribe(onNext:{[unowned self](purchasePrice)->Void in
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.evalPropertyType.savedNotification), object: nil)
      guard let purchasePrice = purchasePrice, purchasePrice.isGreaterThan(0) else{
        self.evalPropertyDetailView.priceLabel.text = nil
        return
      }
      self.evalPropertyDetailView.priceLabel.text = purchasePrice.dollarFormat()
    }).disposed(by: disposeBag)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.coreDataController.saveMainContext()
  }
}
