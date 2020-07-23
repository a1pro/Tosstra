//
//  BackgroundLocationManager.swift
//  Tosstra
//
//  Created by Eweb on 22/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class BackgroundLocationManager :NSObject, CLLocationManagerDelegate {

    static let instance = BackgroundLocationManager()
    static let BACKGROUND_TIMER = 150.0 // restart location manager every 150 seconds
    static let UPDATE_SERVER_INTERVAL = 60 * 60 // 1 hour - once every 1 hour send location to server

    let locationManager = CLLocationManager()
    var timer:Timer?
    var currentBgTaskId : UIBackgroundTaskIdentifier?
    var lastLocationDate : NSDate = NSDate()

    private override init(){
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.activityType = .other;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startMonitoringSignificantLocationChanges()
        
        if #available(iOS 9, *){
            locationManager.allowsBackgroundLocationUpdates = true
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    @objc func applicationEnterBackground(){
        print("applicationEnterBackground")
        start()
    }

    func start(){
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            if #available(iOS 9, *){
                locationManager.requestLocation()
            } else {
                locationManager.startUpdatingLocation()
            }
        } else {
                locationManager.requestAlwaysAuthorization()
        }
    }
    @objc func restart (){
        timer?.invalidate()
        timer = nil
        start()
    }

    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.restricted:
            break;
            //log("Restricted Access to location")
        case CLAuthorizationStatus.denied:
            break;
            //log("User denied access to location")
        case CLAuthorizationStatus.notDetermined:
             break;
            //log("Status not determined")
        default:
            //log("startUpdatintLocation")
            if #available(iOS 9, *){
                locationManager.requestLocation()
            } else {
                locationManager.startUpdatingLocation()
            }
        }
    }
    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if(timer==nil){
            // The locations array is sorted in chronologically ascending order, so the
            // last element is the most recent
            guard let location = locations.last else {return}
print(location)
                    if let  status = DEFAULT.value(forKey: "ONLINESTATUS") as? String
                                        {
                                            if status == "1"
                                            {
            
                                               
                if (CURRENTLOCATIONLAT != location.coordinate.latitude) || (CURRENTLOCATIONLONG != location.coordinate.longitude)
                                                {
                                                    CURRENTLOCATIONLAT=location.coordinate.latitude
                                                     CURRENTLOCATIONLONG=location.coordinate.longitude
                                                    self.UserStatusAPI()
                                                }
                                                    
                                                
                                            }
                                            else
                                            {
            
                                            }
                                        }
                                        else
                                        {
            
                                        }
            
            
            
            beginNewBackgroundTask()
            locationManager.stopUpdatingLocation()
            let now = NSDate()
            if(isItTime(now: now)){
                //TODO: Every n minutes do whatever you want with the new location. Like for example sendLocationToServer(location, now:now)
            }
        }
    }

    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        

        beginNewBackgroundTask()
        locationManager.stopUpdatingLocation()
    }

    func isItTime(now:NSDate) -> Bool {
        let timePast = now.timeIntervalSince(lastLocationDate as Date)
        let intervalExceeded = Int(timePast) > BackgroundLocationManager.UPDATE_SERVER_INTERVAL
        return intervalExceeded;
    }

    func sendLocationToServer(location:CLLocation, now:NSDate){
        //TODO
    }

    func beginNewBackgroundTask(){
        var previousTaskId = currentBgTaskId;
        currentBgTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: {
         
        })
        if let taskId = previousTaskId{
            UIApplication.shared.endBackgroundTask(taskId)
            previousTaskId = UIBackgroundTaskIdentifier.invalid
        }

        timer = Timer.scheduledTimer(timeInterval: BackgroundLocationManager.BACKGROUND_TIMER, target: self, selector: #selector(self.restart),userInfo: nil, repeats: false)
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
           
           ApiHandler.ModelApiPostMethod2(url: CHANGE_ONLINESTATUS_API, parameters: params) { (response, error) in
               
               if error == nil
               {
                   let decoder = JSONDecoder()
                   do
                   {
                    print(params)
                       print(response)
                     
                       
                   }
                   catch let error
                   {
                       
                   }
                   
               }
               else
               {
                 
               }
           }
       }
}
