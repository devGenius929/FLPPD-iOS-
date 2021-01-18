//
//  AppDelegate.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 1/19/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import FilestackSDK
import Filestack
import PubNub
import Firebase
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var current:AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    private var continueAfterTutorToLogin:Bool = true
    var chatController:ChatController?
    
    var window: UIWindow?
    static var fileStackClient:Filestack.Client? = {
        // Initialize a `Policy` with the expiry time and permissions you need.
        let oneDayInSeconds: TimeInterval = 60 * 60 * 24 * 30 // expires next month
        
        let policy = Policy(expiry: .distantFuture,
                            call: [.pick, .read, .stat, .write, .writeURL, .store, .convert, .remove, .exif])
        guard let secret = Config.current?.filestack_app_secrect, let apiKey = Config.current?.filestack_api_key else {
            return nil
        }
        guard let security = try? Security(policy: policy, appSecret: secret) else {
            fatalError("Unable to instantiate Security object.")
        }
        
        // Create `Config` object.
        let config = Filestack.Config()
        
        // Make sure to assign an app scheme URL that matches the one configured in your info.plist.
        config.appURLScheme = "flppd"
        
        config.availableLocalSources = LocalSource.all()
        config.availableCloudSources = CloudSource.all()
        
        let client = Filestack.Client(apiKey: apiKey, security: security, config: config)
        
        return client
    }()
    static func getPicker() -> Filestack.PickerNavigationController? {
        let storeOptions = StorageOptions(location: .s3, access: .public)
        // Instantiate picker by passing the `StorageOptions` object we just set up.
        return self.fileStackClient?.picker(storeOptions: storeOptions)
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //tabbar appearance setup
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().clipsToBounds = false
        //UITabBar.appearance().shadowImage = UIImage() remove shadow border
        //UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().tintColor = Colors.greenColor
        UITabBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor(hex: 0xA7A2A9)
        InAppPurchasesController.default.shouldAddStorePaymentHandler()
        
        FirebaseApp.configure()
        registerForNotifications()
        
        if !ClientAPI.default.hasAuthKey {
            if UserDefaults.standard.bool(forKey: "Onboarding_done"){
                showLogin()
            }
            else {
                showTutorial()
            }
        }
        else {
            ClientAPI.default.refreshToken { (dict, error) in
                if error != nil {
                    self.showLogin()
                }
                else {
                    self.createChatController()
                }
            }
        }
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        DispatchQueue.main.async {
            GlossaryItem.updateGlossary()
        }
        return true
    }
    func createChatController() {
        guard let user = ClientAPI.currentUser else {
            return
        }
        if chatController == nil || chatController?.user_id != Int32(user.user_id){
            chatController = ChatController(forUser: Int32(user.user_id), inContext: CoreDataManager.shared.context)
            chatController!.createUserBy(user: user)
            chatController!.history(forChannel: chatController!.inboundChannel(forUserId: Int32(user.user_id)))
        }
        setPresence(true)
        guard let device_token =  UserDefaults.standard.value(forKey: "deviceToken") as? Data  else {
            return
        }
        chatController?.add(deviceToken: device_token)
        
    }
    func registerForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    func showLogin() {
        self.window?.rootViewController = UIStoryboard(name: "login", bundle: nil).instantiateInitialViewController()
    }
    func showMainInterface(){
        self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainTabBarController")
    }
    func showTutorial(continueToLogin:Bool = true ){
        self.continueAfterTutorToLogin = continueToLogin
        guard let vc = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController() else {
            return
        }
        if continueToLogin {
            self.window?.rootViewController = vc
            UserDefaults.standard.set(true, forKey: "Onboarding_done")
            UserDefaults.standard.synchronize()
        }
        else {
            guard let tbc = window?.rootViewController as? UITabBarController else {
                return
            }
            guard let nc = tbc.selectedViewController as? UINavigationController else {
                return
            }
            nc.pushViewController(vc, animated: true)
            nc.isNavigationBarHidden = true
        }
    }
    func continueAfterTutorial(){
        if self.continueAfterTutorToLogin {
            self.showLogin()
        }
        else {
            guard let tbc = window?.rootViewController as? UITabBarController else {
                return
            }
            guard let nc = tbc.selectedViewController as? UINavigationController else {
                return
            }
            nc.popViewController(animated: true)
            nc.isNavigationBarHidden = false
        }
    }
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        UserDefaults.standard.set(deviceToken, forKey: "deviceToken")
        // Print it to console
        dprint("APNs device token: \(deviceTokenString)")
        Messaging.messaging().apnsToken = deviceToken
        
        let token = Messaging.messaging().fcmToken
        
        UserDefaults.standard.set(token, forKey: ClientAPI.Constants.FLPDDAuthKeys.fcm_device_token)
        UserDefaults.standard.synchronize()
        ClientAPI.default.sendDeviceToken()
    }
    
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        dprint("APNs registration failed: \(error)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        dprint("remote info:\(userInfo.debugDescription)")
    }
    
    func setPresence(_ presence:Bool){
        if let chatController = self.chatController {
                chatController.setPresence(presence)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        setPresence(false)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        setPresence(false)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        setPresence(true)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        setPresence(true)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        setPresence(false)
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.scheme == "flppd" && url.host == "Filestack" {
            if #available(iOS 11.0, *) {
                // NO-OP
            } else {
                NotificationCenter.default.post(name: Filestack.Client.resumeCloudRequestNotification,
                                                object: url)
            }
        }
        let handled = FBSDKApplicationDelegate
            .sharedInstance()
            .application(app, open: url,
                         sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String ?? "None",
                         annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        // Here we just state that any other URLs should not be handled by this app.
        return handled
    }
}

