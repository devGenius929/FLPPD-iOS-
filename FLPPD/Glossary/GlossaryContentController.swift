//
//  GlossaryContentController.swift
//  FLPPD
//
//  Created by Vlad Konon on 12/15/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import  WebKit
import CoreData

class GlossaryContentController: UIViewController, WKNavigationDelegate {
    let webView:WKWebView? = nil
    var item:GlossaryItem? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = view.subviews.map { $0.removeFromSuperview()}
        let webView = WKWebView()
        let path = item!.filename!
        let htmlPath = Bundle.main.path(forResource: "Articles/"+path, ofType: "")
        let folderPath = Bundle.main.bundlePath.appending("Articles")
        let baseUrl = URL(fileURLWithPath: folderPath, isDirectory: true)
        do {
            let htmlString = try NSString(contentsOfFile: htmlPath!, encoding: String.Encoding.utf8.rawValue)
            webView.loadHTMLString(htmlString as String, baseURL: baseUrl)
        } catch {
            // catch error
            dprint(error)
        }
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.pinToSuperView()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
