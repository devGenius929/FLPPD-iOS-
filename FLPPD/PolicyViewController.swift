//
//  PolicyViewController.swift
//  FLPPD
//
//  Created by Vlad Konon on 02/04/18.
//  Copyright © 2018 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import  WebKit

class PolicyViewController: UIViewController, WKNavigationDelegate {
    let webView:WKWebView? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Privacy Policy"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = view.subviews.map { $0.removeFromSuperview()}
        let webView = WKWebView()
        let url = URL(string:ClientAPI.Constants.privacyUrl)
        webView.load(URLRequest(url: url!))
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.pinToSuperView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
