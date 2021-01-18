//
//  NewItemizeFieldView.swift
//  FLPPD
//
//  Created by PC on 6/1/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class ItemizeFieldView:UIScrollView{
  let disposeBag = DisposeBag()
  let placeholderComponents:Variable<[String]> = Variable([])
  let characteristics:[Variable<CharacteristicData?>] = [Variable(nil),Variable(nil),Variable(nil),Variable(nil)]
  let characteristicOptions:[Variable<[CharacteristicData]>] = [Variable([]),Variable([]),Variable([]),Variable([])]
  let segmentedControls = [UISegmentedControl(),UISegmentedControl(),UISegmentedControl(),UISegmentedControl()]
  let stackview = UIStackView()
  let nameView = UIView()
  let amountView = UIView()
  let nameTF = FloatLabelTextField()
  let amountTF = FloatLabelTextField()
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  private func setupView() {
    self.backgroundColor = UIColor.groupTableViewBackground
    addSubview(stackview)
    stackview.axis = .vertical
    stackview.pinToSuperView()
    let stackViewWidthConstraint = NSLayoutConstraint(item: stackview, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
    NSLayoutConstraint.activate([stackViewWidthConstraint])
    nameView.backgroundColor = UIColor.white
    amountView.backgroundColor = UIColor.white
    stackview.addArrangedSubview(nameView)
    stackview.addArrangedSubview(amountView)
    nameView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    amountView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    nameView.addSubview(nameTF)
    amountView.addSubview(amountTF)
    setupNewItemizeFieldLayout(nameTF)
    setupNewItemizeFieldLayout(amountTF)
    nameTF.placeholder = "Name"
    amountTF.placeholder = "$"
    nameView.addTopSeparator(0.5, rightInset: 0, leftInset: 0, color: UIColor.lightGray)
    amountView.addTopSeparator(0.5, rightInset: 0, leftInset: 0, color: UIColor.lightGray)
    createCharacteristicsFields()
  }
  private func createCharacteristicsFields(){
    for segmentedControl in segmentedControls{
    setupSegmentedControl(segmentedControl)
    }
    for (index,characteristicOption) in characteristicOptions.enumerated(){
      characteristicOption.asObservable().subscribe(onNext:{[unowned self](characteristics)->Void in
        self.segmentedControls[index].removeAllSegments()
        self.segmentedControls[index].isHidden = characteristics.isEmpty ? true : false
        for (characteristicDataIndex,characteristicData) in characteristics.enumerated(){
          self.segmentedControls[index].insertSegment(withTitle: characteristicData.characteristic.title, at: characteristicDataIndex, animated: false)
        }
      }).disposed(by: disposeBag)
    }

    for (segmentedControlIndex,segmentedControl) in segmentedControls.enumerated(){
      segmentedControl.rx.selectedSegmentIndex.subscribe(onNext:{[unowned self](selectedSegmentIndex)->Void in
        if self.characteristicOptions[segmentedControlIndex].value.indices.contains(selectedSegmentIndex){
          self.characteristics[segmentedControlIndex].value = self.characteristicOptions[segmentedControlIndex].value[selectedSegmentIndex]
        }
      }).disposed(by: disposeBag)
    }
    
    for (index,characteristic) in characteristics.enumerated(){
      characteristic.asObservable().subscribe(onNext:{[unowned self](characteristicData)->Void in
        guard let characteristicData = characteristicData else{
          return
        }
        for hideIndex in characteristicData.hideSegmentedControlIndex{
          if self.segmentedControls.indices.contains(hideIndex){
            self.segmentedControls[hideIndex].isHidden = true
          }
        }
        for showIndex in characteristicData.showSegmentedControlIndex{
          if self.segmentedControls.indices.contains(showIndex),!self.segmentedControls[index].isHidden{
            self.segmentedControls[showIndex].isHidden = false
          }
        }
        var text:[String] = []
      for (characteristicIndex,tempCharacteristicData) in self.characteristics.enumerated(){
        if !self.segmentedControls[characteristicIndex].isHidden,let placeholder = tempCharacteristicData.value?.characteristic.placeHolder{
            text.append(placeholder)
        }
      }
        self.placeholderComponents.value = text
      }).disposed(by: disposeBag)
    }
    
    placeholderComponents.asObservable().subscribe(onNext:{[unowned self](placeholderData)->Void in
      if placeholderData.isEmpty{
        return
      }
      var placeholder = ""
      for text in placeholderData{
        placeholder += " "+text
      }
      self.amountTF.placeholder = placeholder
    }).disposed(by: disposeBag)
    
 
  }
  private func setupSegmentedControl(_ segmentedControl:UISegmentedControl){
    stackview.addArrangedSubview(segmentedControl)
    segmentedControl.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    segmentedControl.tintColor = UIColor.clear
    segmentedControl.backgroundColor = UIColor.white
    let selectedAttributes = [NSAttributedStringKey.foregroundColor:UIColor.darkerGold,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17)]
    let normalAttributes = [NSAttributedStringKey.foregroundColor:UIColor.lightGray,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17)]
    segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
    segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
    segmentedControl.addTopSeparator(0.5, rightInset: 0, leftInset: 0, color: UIColor.lightGray)
  }

}
