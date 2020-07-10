//
//  AppDelegate.swift
//  Tosstra
//
//  Created by Eweb on 02/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import KYDrawerController
import UserNotifications
import UserNotificationsUI
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable=true
        IQKeyboardManager.shared.shouldResignOnTouchOutside=true
        GMSPlacesClient.provideAPIKey("AIzaSyCmujmy2_NQH2T4OGWOcwV2wp6QhOc3t28")
        GMSServices.provideAPIKey("AIzaSyCmujmy2_NQH2T4OGWOcwV2wp6QhOc3t28")
        //                UIFont.familyNames.forEach({ familyName in
        //                    let fontNames = UIFont.fontNames(forFamilyName: familyName)
        //                    print(familyName, fontNames)
        //                })
        registerForRemoteNotification()
        if let type = DEFAULT.value(forKey: "USERTYPE") as? String
        {
            
            if type == "Dispatcher"
            {
                loadHomeView()
            }
            else
            {
                loadDriverHomeView()
            }
            
            
        }
        else
        {
            loadLoginView()
            
        }
        
        let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
        if formatter.contains("a") {
            //phone is set to 12 hours
            print("//phone is set to 12 hours")
            TIMEFORMATE = "12"
        } else {
            TIMEFORMATE = "24"
            print("//phone is set to 24 hours")
        }
        
        return true
    }
    
    func loadLoginView()
    {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "nav") as! UINavigationController
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    func loadConfirmView()
    {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "confirmNavi") as! UINavigationController
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    func loadHomeView()
    {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "KYDrawerController") as! KYDrawerController
        
        DEFAULT.set("dispatcher", forKey: "APPTYPE")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    func loadDriverHomeView()
    {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "DriverDrawer") as! KYDrawerController
        DEFAULT.set("driver", forKey: "APPTYPE")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    override init() {
        super.init()
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "ProximaNova-Black", size: 21)!]
        
        
        
        
        UIFont.overrideInitialize()
    }
    
    // MARK: UISceneSession Lifecycle
    
    
    @available(iOS 13.0, *)
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Tosstra")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    //MARK:-- remote notifications methods---
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *)
        {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil
                {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    
                }
            }
            // For iOS 10 data message (sent via FCM
            //            Messaging.messaging().delegate = self
            
        }
        else
        {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
    }
    //MARK:-- remote notifications methods---
    func UnregisterForRemoteNotification() {
        if #available(iOS 10.0, *)
        {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: []) { (granted, error) in
                if error == nil
                {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            // For iOS 10 data message (sent via FCM
            //            Messaging.messaging().delegate = self
            
        }
        else
        {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
    }
    
    func notificationBlock()
    {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    //MARK:- Notification Methods------
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        print(notification.request.content.userInfo)
        
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        
        
        if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
        {
            
            if let dict = info["0"] as? NSDictionary
            {
                let noti_type = dict.value(forKey: "userType") as? String
                
                if noti_type == "22"
                {
                    completionHandler([.alert, .badge, .sound])
                }
                else
                {
                    completionHandler([.alert, .badge, .sound])
                }
            }
            else
            {
                completionHandler([.alert, .badge, .sound])
            }
        }
        else
        {
            completionHandler([.alert, .badge, .sound])
        }
    
    
    
    
    
    //completionHandler([.alert, .badge, .sound])
}
//Called to let your app know which action was selected by the user for a given notification.
@available(iOS 10.0, *)
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    let storyBoard = UIStoryboard.init(name: "Main", bundle:Bundle.main)
    
    print("Notification Data = \(userInfo)")
    
    if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
    {
        
        let dict = info["0"] as! NSDictionary
        
        let userType = dict.value(forKey: "userType") as? String
        
        
        if userType?.lowercased() == "driver"
        {
            if #available(iOS 13.0, *)
            {
                SCENEDEL.loadDriverHomeView()
                
            }
            else
            {
                APPDEL.loadDriverHomeView()
            }
        }
        else
        {
            if #available(iOS 13.0, *) {
                SCENEDEL.loadHomeView()
                
            }
            else
            {
                APPDEL.loadHomeView()
            }
        }
        
        let noti_type = dict.value(forKey: "type") as? String
        
        
        print(dict)
    }
    
    
    
    completionHandler()
}


func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                 fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    
    // Print message ID.
    //        if let messageID = userInfo[gcmMessageIDKey] {
    //            print("Message ID: \(messageID)")
    //        }
    
    // Print full message.
    print(userInfo)
    
    completionHandler(UIBackgroundFetchResult.newData)
}


//--MARK:--Get Token-----
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    var token = ""
    for i in 0..<deviceToken.count
    {
        token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
    }
    print("device token =  \(token)")
    
    UserDefaults.standard.setValue(token, forKey: "DEVICETOKEN")
    UserDefaults.standard.synchronize()
    
}
}

