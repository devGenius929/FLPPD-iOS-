//
//  InvestorProViewController.swift
//  FLPPD
//
//  Created by Vlad Konon on 02/16/18.
//  Copyright © 2018 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import StoreKit
// - Trials will be 7 days, after which the subscription will auto-renew
fileprivate let subText = """
Investor Pro subscription:
- You can subscribe for unlimited access to FLPPD services
- FLPPD offers monthly subscription
- Monthly subscription will be charged at %MONTH_PRICE%/month
- You'll be able to access unlimited for the duration of your subscription
- Payment will be charged to iTunes Account at confirmation of purchase
- Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period
- Account will be charged for renewal within 24-hours prior to the end of the current period
- Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase
- No cancellation of the current subscription is allowed during active subscription period
- Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication

By using FLPPD, you agree to our Terms of Use and Privacy Policy: \(ClientAPI.Constants.privacyUrl)
"""

class InvestorProViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    var price = "$9.99"
    override func viewDidLoad() {
        super.viewDidLoad()
        price = InAppPurchasesController.default.investorProPriceMonthly ?? price
        let text = subText.replacingOccurrences(of: "%MONTH_PRICE%", with: self.price)
        textView.text = text
        InAppPurchasesController.default.getInvestorProInformation { (products, error) in
            if let product = products?.first(where: {[] (product) -> Bool in
                return product.productIdentifier == InAppPurchasesController.investorProMonthly
            }) {
                    self.price = product.localizedPrice ?? self.price
                DispatchQueue.main.async {
                    self.textView.text = subText.replacingOccurrences(of: "%MONTH_PRICE%", with: self.price)
                }
                }
        }
    }
    var completion:((_ success:Bool, _ error:SKError?) -> Void)? = nil

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func termsAction(_ sender: Any) {
        let vc = PolicyViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func buyAction(_ sender: Any) {
        InAppPurchasesController.default.purchaseInvestorPro(isMonthly: true) { (success, error) in
            self.navigationController?.popViewController(animated: false)
            if self.completion != nil{
                self.completion!(success, error)
            }
        }
    }
    

}
