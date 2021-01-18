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
import RxCocoa

class PhotosDisplayView:UIView{
  let scrollView = UIScrollView()
  let stackView = UIStackView()
  private let disposeBag = DisposeBag()
  let images:Variable<[ImageWithUrl]> = Variable([])
  private let imagesView:Variable<[ImageViewWithButton]> = Variable([])
  let deleteButtonTap:Variable<Int?> = Variable(nil)
  private let indexView = UIView()
  private let indexLabel = UILabel()
  private var page = "1"
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  private func setupView() {
    addSubview(scrollView)
    addSubview(indexView)
    scrollView.addSubview(stackView)
    scrollView.pinToSuperView()
    stackView.pinToSuperView()
    //MARK:setup stackview
    let stackViewHeightConstraint = NSLayoutConstraint(item: stackView, attribute: .height, relatedBy: .equal, toItem: self.scrollView, attribute: .height, multiplier: 1, constant: 0)
    stackView.distribution = .fillEqually
    stackView.axis = .horizontal
    //MARK:setup scrollview
    scrollView.isPagingEnabled = true
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.alwaysBounceHorizontal = true
    //MARK: setup photos index label
    indexView.addSubview(indexLabel)
    indexView.backgroundColor = UIColor.imageIndexLabelBackgroundColor
    indexLabel.backgroundColor = UIColor.clear
    indexView.layer.cornerRadius = 4
    indexLabel.textColor = UIColor.white
    indexLabel.font = UIFont.systemFont(ofSize: 14)
    indexView.pinToSuperViewBottomRightCorner(16, rightMargin: 16)
    
    let indexViewHeightConstraint = NSLayoutConstraint(item: indexView, attribute: .height, relatedBy: .equal, toItem: indexLabel, attribute: .height, multiplier: 1, constant: 12)
    let indexViewWidthConstraint = NSLayoutConstraint(item: indexView, attribute: .width, relatedBy: .equal, toItem: indexLabel, attribute: .width, multiplier: 1, constant: 16)
    let indexLabelLeadingConstraint = NSLayoutConstraint(item: indexLabel, attribute: .leading, relatedBy: .equal, toItem: indexView, attribute: .leading, multiplier: 1, constant: 8)
    let indexLabelTopConstraint = NSLayoutConstraint(item: indexLabel, attribute: .top, relatedBy: .equal, toItem: indexView, attribute: .top, multiplier: 1, constant: 6)
    indexLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([stackViewHeightConstraint,indexViewWidthConstraint,indexViewHeightConstraint,indexLabelTopConstraint,indexLabelLeadingConstraint])
    
    
    images.asObservable().subscribe(onNext:{[unowned self](imagesArray)->Void in
      var imagesView:[ImageViewWithButton] = []
      if imagesArray.count != 0 {
        for (index,image) in imagesArray.enumerated(){
          let imageView = ImageViewWithButton(image:image.image)
          imageView.button.tag = index
          imagesView.append(imageView)
        }
      }
      self.imagesView.value = imagesView
    }).disposed(by: disposeBag)
    
    imagesView.asObservable().subscribe(onNext:{[unowned self](imagesView)->Void in
      for view in self.stackView.arrangedSubviews{
        self.stackView.removeArrangedSubview(view)
        view.removeFromSuperview()
      }
      if imagesView.count == 0 {
        return
      }
      
      for imageView in imagesView{
        self.stackView.addArrangedSubview(imageView)
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([widthConstraint])
          imageView.button.rx.tap.subscribe(onNext:{Void in
            self.deleteButtonTap.value = imageView.button.tag
          }).disposed(by: self.disposeBag)
      }
      self.updateIndexLabel()
    }).disposed(by: disposeBag)
    
    scrollView.rx.didEndDecelerating.subscribe(onNext:{[unowned self] Void in
      self.updateIndexLabel()
    }).disposed(by: disposeBag)
    
    self.scrollView.rx.contentOffset.subscribe(onNext:{[unowned self](contentOffset)->Void in
      if self.frame.width != 0{
        self.page = String(Int(contentOffset.x/self.frame.width) + 1)
        self.updateIndexLabel()
      }
    }).disposed(by: disposeBag)
  }
  
  func updateIndexLabel(){
    self.indexLabel.text = self.page + " of " + String(self.imagesView.value.count)
  }
}
