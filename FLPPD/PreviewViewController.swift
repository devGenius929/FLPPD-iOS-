//
//  PreviewViewController.swift
//  FLPPD
//
//  Created by PC on 7/18/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import RxSwift
import RxCocoa
class PreviewViewController:UIViewController{
  var html:Variable<String?>!
  private let disposeBag = DisposeBag()
  private let webView = WKWebView()
  private let toolbar = UIToolbar()
  private let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: nil, action: nil)
  override func viewDidLoad(){
    super.viewDidLoad()
    setupView()
  }
  private func setupView(){
    view.backgroundColor = UIColor.white
    view.addSubview(webView)
    view.addSubview(toolbar)
    toolbar.setTopInSuperview(20, priority: UILayoutPriority(rawValue: 1000))
    toolbar.setLeadingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    toolbar.setTrailingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    toolbar.setItems([closeButton], animated: false)
    closeButton.rx.tap.subscribe(onNext:{[unowned self] Void in
      self.presentingViewController?.dismiss(animated: true, completion: nil)
    }).disposed(by: disposeBag)
    webView.setTopInSuperview(64, priority: UILayoutPriority(rawValue: 1000))
    webView.setBottomInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    webView.setLeadingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    webView.setTrailingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    html.asObservable().subscribe(onNext:{[unowned self] html in
      guard let html = html else{
        return
      }
      self.webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
    }).disposed(by: disposeBag)
  }
}

