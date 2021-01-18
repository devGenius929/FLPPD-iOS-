//
//  InAppPurchasesController.swift
//  FLPPD
//
//  Created by Vlad Konon on 12/27/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import StoreKit

fileprivate let platinumKey = "plCount"
fileprivate let prokey = "proKey"
class InAppPurchasesController {
    static let `default` = InAppPurchasesController()
    private var _proSubsciptionIsActive:Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: prokey)
            UserDefaults.standard.synchronize()
            if newValue != _proSubsciptionIsActive {
                NotificationCenter.default.post(Notification.init(name: Notification.Name("InvestorProWillChange"), object: nil, userInfo: ["value":newValue]))
            }
        }
        get {
            return UserDefaults.standard.bool(forKey: prokey)
        }

    }
    var proSubsciptionIsActive:Bool {
        get {
            #if DEBUG
            return true
            #else
            return _proSubsciptionIsActive
            #endif
            
        }
    }
    internal func addPlatinumListing() {
        let count = UserDefaults.standard.integer(forKey: platinumKey)
        UserDefaults.standard.set(count+1, forKey: platinumKey)
        UserDefaults.standard.synchronize()
    }
    func canConsumePlatinum() -> Bool {
        return UserDefaults.standard.integer(forKey: platinumKey) > 0
    }
    @discardableResult
    func consumePlatinum() -> Bool {
        let count = UserDefaults.standard.integer(forKey: platinumKey)
        if count > 0 {
            UserDefaults.standard.set(count-1, forKey: platinumKey)
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
    static let platinumListing = "com.flppd.platinum_listing"
    static let investorProMonthly = "com.flppd.investor_pro"
    var investorProPriceMonthly:String?
    init() {
        shouldAddStorePaymentHandler()
    }
    func shouldAddStorePaymentHandler() {
        SwiftyStoreKit.shouldAddStorePaymentHandler = { payment, product in
            return true
        }
    }
    func observerTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        if [InAppPurchasesController.investorProMonthly].contains(purchase.productId) {
                            self._proSubsciptionIsActive = true
                        }
                        if [InAppPurchasesController.platinumListing].contains(purchase.productId){
                            self.addPlatinumListing()
                        }
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
    }
    func printError(_ error:SKError) {
        switch error.code {
        case .unknown: dprint("Unknown error. Please contact support")
        case .clientInvalid: dprint("Not allowed to make the payment")
        case .paymentCancelled: break
        case .paymentInvalid: dprint("The purchase identifier was invalid")
        case .paymentNotAllowed: dprint("The device is not allowed to make the payment")
        case .storeProductNotAvailable: dprint("The product is not available in the current storefront")
        case .cloudServicePermissionDenied: dprint("Access to cloud service information is not allowed")
        case .cloudServiceNetworkConnectionFailed: dprint("Could not connect to the network")
        case .cloudServiceRevoked: dprint("User has revoked permission to use this cloud service")
        }
    }
    func restorePurchases(completion: @escaping (RestoreResults) -> Void) {
        SwiftyStoreKit.restorePurchases(atomically: false) { results in
            if results.restoreFailedPurchases.count > 0 {
                dprint("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                dprint("Restore Success: \(results.restoredPurchases)")
            }
            else {
                dprint("Nothing to Restore")
            }
            completion(results)
        }
    }
    private func getPlatinumID() -> String{
        return InAppPurchasesController.platinumListing
    }
    func getPlatinumListingInformation(completion:@escaping (_ product:SKProduct?, _ error:Error? ) -> Void){
        SwiftyStoreKit.retrieveProductsInfo([getPlatinumID()]) { result in
            if let product = result.retrievedProducts.first {
                completion(product, nil)
            }
            else {
                completion(nil,result.error)
            }
        }
    }
    func getInvestorProInformation(completion:@escaping (_ product:Set<SKProduct>?, _ error:Error? ) -> Void){
        SwiftyStoreKit.retrieveProductsInfo([InAppPurchasesController.investorProMonthly]) { result in
            if let _ = result.retrievedProducts.first {
                completion(result.retrievedProducts, nil)
                if let product = result.retrievedProducts.first(where: {[] (product) -> Bool in
                    return product.productIdentifier == InAppPurchasesController.investorProMonthly
                }) {
                    self.investorProPriceMonthly = product.localizedPrice
                }
            }
            else {
                completion(nil,result.error)
            }
        }
    }
    func purchasePlatinumListing(completion:@escaping (_ success:Bool, _ error:SKError?) -> Void ) {
        SwiftyStoreKit.purchaseProduct(getPlatinumID(), quantity: 1, atomically: false) { result in
            switch result {
            case .success(let purchase):
                self.addPlatinumListing()
                completion(true, nil)
                dprint("Purchase Success: \(purchase.productId)")
            case .error(let error):
                completion(false, error)
                self.printError(error)
            }
        }
    }
    func purchaseInvestorPro(isMonthly:Bool, completion:@escaping (_ success:Bool, _ error:SKError?) -> Void ) {
        SwiftyStoreKit.purchaseProduct(InAppPurchasesController.investorProMonthly,
                                       quantity: 1,
                                       atomically: false)
        { result in
            switch result {
            case .success(let purchase):
                self._proSubsciptionIsActive = true
                completion(true, nil)
                dprint("Purchase Success: \(purchase.productId)")
            case .error(let error):
                completion(false, error)
                self.printError(error)
            }
        }
    }
}
