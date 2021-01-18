//
//  FeaturesView.swift
//  FLPPD
//
//  Created by PC on 5/15/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class FeaturesView:UIStackView{
  private let lastCell = AddNewCell()
  private let disposeBag = DisposeBag()
  let deleteFeature:Variable<TFFeaturesCell?> = Variable(nil)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  private func setupView(){
    self.axis = .vertical
    addArrangedSubview(lastCell)
    lastCell.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    lastCell.tap.rx.methodInvoked(#selector(touchesBegan(_:with:))).subscribe(onNext:{[unowned self](event)->Void in
      let indexBeforeLast = self.arrangedSubviews.endIndex - 1
      let cell = self.addNewCell(indexBeforeLast)
      cell.textField.becomeFirstResponder()
    }).disposed(by: disposeBag)
  }
  
  func syncFeatures(_ features:[String]){
    for view in self.arrangedSubviews{
      if view.isKind(of: AddNewCell.self){
        continue
      }
      self.removeArrangedSubview(view)
      view.removeFromSuperview()
    }
    for (index,feature) in features.enumerated(){
      let cell = self.addNewCell(index)
      cell.textField.text = feature
    }
  }
  func addNewCell(_ index:Int)->TFFeaturesCell{
    let cell = TFFeaturesCell()
    UIView.animate(withDuration: 0.5, animations: {
      self.insertArrangedSubview(cell, at: index)
        cell.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    })
    
    cell.accessoryButton.rx.tap.subscribe(onNext:{
      self.deleteFeature.value = cell
    }).disposed(by: self.disposeBag)
    return cell
  }
  
  func removeCell(_ cell:TFFeaturesCell){
    cell.removeFromSuperview()
    self.removeArrangedSubview(cell)
  }
  
  func getListOfFeatures()->[String]?{
    var features:[String] = []
    for view in self.arrangedSubviews{
      guard let view = view as? TFFeaturesCell else{
        continue
      }
      guard let text = view.textField.text else{
        continue
      }
      features.append(text)
    }
    return features.count == 0 ? nil : features
  }
}
