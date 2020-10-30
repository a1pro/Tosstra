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
import CoreLocation
import Firebase
import FirebaseAuth
import UserNotifications
import UserNotificationsUI
import MessageUI
import Messages
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {
    
    var gameTimer: Timer?
    var locationManager = CLLocationManager()

    var window: UIWindow?
    var bgTask:UIBackgroundTaskIdentifier?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        NotificationCenter.default.addObserver(self, selector:#selector(AppDelegate.onAppWillTerminate), name:UIApplication.willTerminateNotification, object:nil)

        
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable=true
        IQKeyboardManager.shared.shouldResignOnTouchOutside=true
        GMSPlacesClient.provideAPIKey("AIzaSyCmujmy2_NQH2T4OGWOcwV2wp6QhOc3t28")
        GMSServices.provideAPIKey("AIzaSyCmujmy2_NQH2T4OGWOcwV2wp6QhOc3t28")
        //                UIFont.familyNames.forEach({ familyName in
        //                    let fontNames = UIFont.fontNames(forFamilyName: familyName)
        //                    print(familyName, fontNames)
        //                })
        registerForRemoteNotification()
        Messaging.messaging().isAutoInitEnabled = true
                  if #available(iOS 10.0, *) {
                    // For iOS 10 display notification (sent via APNS)
                    UNUserNotificationCenter.current().delegate = self

                    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                    UNUserNotificationCenter.current().requestAuthorization(
                      options: authOptions,
                      completionHandler: {_, _ in })
                  } else {
                    let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                    application.registerUserNotificationSettings(settings)
                  }

                  application.registerForRemoteNotifications()
           
           Messaging.messaging().delegate = self
       // BackgroundLocationManager.instance.start()

        UIApplication.shared.windows.forEach { window in
                   if #available(iOS 13.0, *) {
                       window.overrideUserInterfaceStyle = .light
                   } else {
                       // Fallback on earlier versions
                   }
               }
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
        
//        let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
//        if formatter.contains("a") {
//            //phone is set to 12 hours
//            print("//phone is set to 12 hours")
//            TIMEFORMATE = "12"
//        } else {
//            TIMEFORMATE = "24"
//            print("//phone is set to 24 hours")
//        }
        
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
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
//self.scheduleNotification(notificationType: "applicationDidEnterBackground")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        bgTask = application.beginBackgroundTask(withName:"MyBackgroundTask", expirationHandler: {() -> Void in
            // Do something to stop our background task or the app will be killed
            application.endBackgroundTask(self.bgTask!)
            //self.bgTask = UIBackgroundTaskIdentifier.invalid
        })

        DispatchQueue.global(qos: .background).async {
            //make your API call here
            
            if let type = DEFAULT.value(forKey: "USERTYPE") as? String
                 {
                     
                     if type == "Dispatcher"
                     {
                        // loadHomeView()
                     }
                     else
                     {
                        // loadDriverHomeView()
                        self.gameTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: true)
                        
                     }
                     
                     
                 }
                 else
                 {
                     //loadLoginView()
                     
                 }
            print("Api call")
        }
        // Perform your background task here
        print("The task has started")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")

    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive")

    }
    func applicationWillTerminate(_ application: UIApplication) {
        
       // self.scheduleNotification(notificationType: "applicationWillTerminate")

        DispatchQueue.global(qos: .background).async {
                   //make your API call here
                   
                   if let type = DEFAULT.value(forKey: "USERTYPE") as? String
                        {
                            
                            if type == "Dispatcher"
                            {
                               // loadHomeView()
                            }
                            else
                            {
                               // loadDriverHomeView()
                               self.gameTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: true)
                               
                            }
                            
                            
                        }
                        else
                        {
                            //loadLoginView()
                            
                        }
                   print("Api call")
               }
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.gameTimer?.invalidate()
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
  func scheduleNotification(notificationType: String) {
        let notificationCenter  = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent() // Содержимое уведомления
        let userActions = "User Actions"
        
        content.title = notificationType
        content.body = "This is example how to create " + notificationType
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userActions
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: userActions, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        
        notificationCenter.setNotificationCategories([category])
    }
    
    //MARK:- FCM
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
      print("Firebase registration token: \(fcmToken)")
      UserDefaults.standard.setValue(fcmToken, forKey: "DEVICETOKEN")
                UserDefaults.standard.synchronize()
      
      
      
      let dataDict:[String: String] = ["token": fcmToken]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
        
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
           // self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
            
            
          }
        }
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print(response)
      let userInfo = response.notification.request.content.userInfo
               let storyBoard = UIStoryboard.init(name: "Main", bundle:Bundle.main)
               
               print("Notification Data = \(userInfo)")
      
      if let test = userInfo["message"] as? String
      {
               //if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
              // {
                
                if  let noti_type = userInfo["gcm.notification.type"] as? String
                {
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
            //Live code
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
    
    /*
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
*/

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
          Messaging.messaging().apnsToken = deviceToken
        
                var token = ""
                for i in 0..<deviceToken.count
                {
                    token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
                }
                print("device token =  \(token)")
        
    //            UserDefaults.standard.setValue(token, forKey: "DEVICETOKEN")
    //            UserDefaults.standard.synchronize()
          
      }
    
//func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//    var token = ""
//    for i in 0..<deviceToken.count
//    {
//        token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
//    }
//    print("device token =  \(token)")
//
//    UserDefaults.standard.setValue(token, forKey: "DEVICETOKEN")
//    UserDefaults.standard.synchronize()
//
//}
    
    
   @objc func onAppWillTerminate(notification:NSNotification)
    {
      print("onAppWillTerminate")
        DispatchQueue.global(qos: .background).async {
                 //make your API call here
                 
                 if let type = DEFAULT.value(forKey: "USERTYPE") as? String
                      {
                          
                          if type == "Dispatcher"
                          {
                             // loadHomeView()
                          }
                          else
                          {
                             // loadDriverHomeView()
                             self.gameTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: true)
                             
                          }
                          
                          
                      }
                      else
                      {
                          //loadLoginView()
                          
                      }
                 print("Api call")
             }
    }
}
//MARK:- location work

extension AppDelegate:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let _ :CLLocation = locations[0] as CLLocation
        print("didUpdateLocations \(locations)")
        //let trigger = UNLocationNotificationTrigger(region: locations, repeats:false)
        //   APPDEL.scheduleNotification(notificationType: "amar")
        //self.scheduleNotification(notificationType: "\(locations)")
        
        if let lastLocation = locations.last
        {
            
            
            let latitude = lastLocation.coordinate.latitude
            let longitude = lastLocation.coordinate.longitude
            
            DEFAULT.set("\(latitude)", forKey: "CURRENTLAT")
            DEFAULT.set("\(longitude)", forKey: "CURRENTLONG")
            
            if let  status = DEFAULT.value(forKey: "ONLINESTATUS") as? String
            {
                if status == "1"
                {
                    if latitude != CURRENTLOCATIONLAT || longitude != CURRENTLOCATIONLONG
                    {
                        
                        let coordinate₀ = CLLocation(latitude: CURRENTLOCATIONLAT, longitude: CURRENTLOCATIONLONG)
                        let coordinate₁ = CLLocation(latitude: latitude, longitude: longitude)

                        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                        
                        print("distanceInMeters = \(distanceInMeters)")
                        
                        
//                        if(distanceInMeters <= 1609)
//                         {
//                         // under 1 mile
//                         }
//                         else
//                        {
                         CURRENTLOCATIONLAT = latitude
                            CURRENTLOCATIONLONG = longitude
                                              
                        self.UserStatusAPI()
                         //}
                        
                       
                    }
                    
                    
                    
                }
            }
            
            
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
    }
    //MARK:- Change Status Account
       func UserStatusAPI()
       {
           
           
           var id = ""
           if let userID = DEFAULT.value(forKey: "USERID") as? String
           {
               id = userID
           }
           
           let params = ["userId" : id,
                         "onlineStatus" : "1",
                         "latitude" : "\(CURRENTLOCATIONLAT)",
                        "longitude" : "\(CURRENTLOCATIONLONG)"]   as [String : String]
        
        print(params)
           
           ApiHandler.ModelApiPostMethod2(url: CHANGE_ONLINESTATUS_API, parameters: params) { (response, error) in
               
               if error == nil
               {
                   let decoder = JSONDecoder()
                   do
                   {
                      
                       
                       
                   }
                   catch let error
                   {
                       print(error.localizedDescription)
                   }
                   
               }
               else
               {
                 print(error)

               }
           }
       }
    
    @objc func runTimedCode()
    {
       locationManager.startUpdatingLocation()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates=true
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
    }
}
