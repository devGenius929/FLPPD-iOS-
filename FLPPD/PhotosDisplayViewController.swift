//
//  PhotosDisplayViewController.swift
//  FLPPD
//
//  Created by PC on 5/11/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class PhotosDisplayViewController:UIViewController{
  let photosDisplayView = PhotosDisplayView()
  let disposeBag = DisposeBag()
  override func loadView() {
    view = UIView()
    view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.black
    view.addSubview(photosDisplayView)
    photosDisplayView.pinToSuperView()
    //setPhotosDisplayViewPortraitFrame()
    photosDisplayView.deleteButtonTap.asObservable().subscribe(onNext:{Void in
      self.dismiss(animated: true, completion: nil)
    }).disposed(by: disposeBag)
  }
  
  func setPhotosDisplayViewPortraitFrame(){
    let photosDisplayViewHeight = self.view.bounds.width * (3/4)
    self.photosDisplayView.frame = CGRect(x: 0, y: self.view.center.y - photosDisplayViewHeight/2, width: self.view.bounds.width, height: photosDisplayViewHeight)
  }
}
