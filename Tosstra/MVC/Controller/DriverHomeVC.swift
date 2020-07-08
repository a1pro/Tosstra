//
//  DriverHomeVC.swift
//  Tosstra
//
//  Created by Eweb on 02/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import KYDrawerController
import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class DriverHomeVC: UIViewController {
    //MARK:- MAp work
       
      @IBOutlet weak var myMapView: GMSMapView!
    
    @IBOutlet weak var onOfflineLbl: UILabel!
    @IBOutlet weak var onLineBtn: UIButton!
    @IBOutlet weak var OfflineBtn: UIButton!
     var apiData:ForgotPasswordModel?
       var geoCoder:CLGeocoder!
          var destinationMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: 37.0, longitude: 45.0))
         let currentLocationMarker = GMSMarker()
         var locationManager = CLLocationManager()
        var chosenPlace: MyPlace?
         
         let customMarkerWidth: Int = 50
         let customMarkerHeight: Int = 70
         public var longitude:Double = 77.38066792488098
         public var latitude:Double = 28.6517752463408
    
    var onlineStatus = "0"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.startUpdatingLocation()
             locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        initGoogleMaps()
        
        
        
        if let  status = DEFAULT.value(forKey: "ONLINESTATUS") as? String
               {
                   if status == "1"
                   {
                        self.onOfflineLbl.text = "You are online"
                               self.OfflineBtn.isHidden = false
                              self.onLineBtn.isHidden = true
                    self.myMapView.isUserInteractionEnabled = true
                   }
                   else
                   {
                       self.onOfflineLbl.text = "You are offline"
                                   self.onlineStatus = "1"
                                  self.OfflineBtn.isHidden = true
                                  self.onLineBtn.isHidden = false
                    self.myMapView.isUserInteractionEnabled = false
                   }
               }
               else
               {
                   self.onOfflineLbl.text = "You are offline"
                               self.onlineStatus = "1"
                              self.OfflineBtn.isHidden = true
                              self.onLineBtn.isHidden = false
                 self.myMapView.isUserInteractionEnabled = false
               }
               
        
        
    }
    
    @IBAction func MenuAct(_ sender: UIButton)
    {
        let drawer = navigationController?.parent as? KYDrawerController
        drawer?.setDrawerState(.opened, animated: true)
    }
    @IBAction func profileAct(_ sender: UIButton)
       {
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverProfileVC") as! DriverProfileVC
        vc.fromSideBar = "no"
           self.navigationController?.pushViewController(vc, animated: true)
       }
       
   
    
    override func viewWillAppear(_ animated: Bool)
        {
            super.viewWillAppear(true)
           self.locationCheck()
        }
    
    @IBAction func offlineOnlineAct(_ sender: UIButton)
       {
        if sender.tag == 0
        {
            self.onOfflineLbl.text = "You are online"
            self.onlineStatus = "1"
            self.OfflineBtn.isHidden = false
             self.onLineBtn.isHidden = true
             self.myMapView.isUserInteractionEnabled = true
        }
        else
        {
            self.onOfflineLbl.text = "You are offline"
             self.onlineStatus = "1"
            self.OfflineBtn.isHidden = true
            self.onLineBtn.isHidden = false
             self.myMapView.isUserInteractionEnabled = false
        }
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                                                       {
                                                           NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                                                       }
                                                       else
                                                       {
                                                        self.UserStatusAPI()
                                                       }
    }
  
}


extension DriverHomeVC : CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate
{
     func initGoogleMaps()
        {
            let camera = GMSCameraPosition.camera(withLatitude: CURRENTLOCATIONLAT, longitude: CURRENTLOCATIONLONG, zoom: 17)
    //        self.myMapView.setMinZoom(17, maxZoom: myMapView.maxZoom)
    //        myMapView.animate(toViewingAngle: 0)
            self.myMapView.camera = camera
            self.myMapView.delegate = self
            self.myMapView.isMyLocationEnabled = true
            self.myMapView.settings.myLocationButton = true
            self.myMapView.settings.compassButton = true
        }
      // MARK: GOOGLE AUTO COMPLETE DELEGATE
         func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
             let lat = place.coordinate.latitude
             let long = place.coordinate.longitude
             
           //  showPartyMarkers(lat: lat, long: long)
             
             let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17)
     //        self.myMapView.setMinZoom(17, maxZoom: myMapView.maxZoom)
     //        myMapView.animate(toViewingAngle: 0)
             myMapView.camera = camera
           
             chosenPlace = MyPlace(name: place.formattedAddress!, lat: lat, long: long)
             let marker=GMSMarker()
             marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
             marker.title = "\(place.name)"
             marker.snippet = "\(place.formattedAddress!)"
             marker.map = myMapView

             self.dismiss(animated: true, completion: nil) // dismiss after place selected
         }
         
         func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
             print("ERROR AUTO COMPLETE \(error)")
         }
         
         func wasCancelled(_ viewController: GMSAutocompleteViewController) {
             self.dismiss(animated: true, completion: nil)
         }
         
    
      func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
        {
            
            let lat = position.target.latitude
            let lng = position.target.longitude
            
            self.myMapView.clear()
            
            destinationMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude))
                    let image = UIImage(named:"marker")
                    destinationMarker.icon = image
            
                    destinationMarker.map = myMapView
            
            let camera = GMSCameraPosition.camera(withLatitude: position.target.latitude, longitude: position.target.longitude, zoom: 17)
            self.myMapView.camera = camera
    //        myMapView.animate(toViewingAngle: 0)
    //          self.myMapView.setMinZoom(17, maxZoom: myMapView.maxZoom)
            let location = CLLocation(latitude: lat, longitude: lng)
            //            DispatchQueue.global(qos: .userInitiated).async {
            //                self.geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            //                    if let placemarks = placemarks
            //                    {
            //                        if let location = placemarks.first?.location
            //                        {
            //
            //                            DEFAULT.set("\(location.coordinate.latitude)", forKey: "GROUPLAT")
            //                            DEFAULT.set("\(location.coordinate.longitude)", forKey: "GROUPLONG")
            //
            //                            if let addressDict = (placemarks.first?.addressDictionary as? NSDictionary)
            //                            {
            //                                if let City = (addressDict.value(forKey: "City") as? String)
            //                                {
            //                                    DEFAULT.set("\(City)", forKey: "GROUPCITY")
            //                                }
            //                                if let State = (addressDict.value(forKey: "State") as? String)
            //                                {
            //                                    DEFAULT.set("\(State)", forKey: "GROUPSTATE")
            //                                }
            //                                if let Country = (addressDict.value(forKey: "Country") as? String)
            //                                {
            //                                    DEFAULT.set("\(Country)", forKey: "GROUPCOUNTRY")
            //                                }
            //                                if let CountryCode = (addressDict.value(forKey: "CountryCode") as? String)
            //                                {
            //                                    DEFAULT.set("\(CountryCode)", forKey: "GROUPCOUNTRYCODE")
            //                                }
            //
            //                                if let address1 = (addressDict.value(forKey: "FormattedAddressLines") as? NSArray)
            //                                {
            //                                   // self.addresslabel.text! = address1.componentsJoined(by: ",")
            ////                                    let attributedString = NSMutableAttributedString(string: self.addresslabel.text ?? "")
            ////                                    self.addresslabel.linkTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.underlineStyle.rawValue): NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key: Any]?
            ////                                    self.addresslabel.attributedText = attributedString
            //                                     print("current address \(address1)")
            //                                }
            //
            //
            //
            //                            }
            //                        }
            //                    }
            //
            //                }
            //            }
            // Geocode Location
            
        }
    
     // MARK: CLLocation Manager Delegate
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error while getting location \(error)")
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            locationManager.delegate = nil
            locationManager.stopUpdatingLocation()
          //  self.initGoogleMaps()
            let location = locations.last
            let lat = (location?.coordinate.latitude)!
            let long = (location?.coordinate.longitude)!
            self.latitude  = lat
            self.longitude  = long
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17)
    //          self.myMapView.setMinZoom(17, maxZoom: myMapView.maxZoom)
    //        myMapView.animate(toViewingAngle: 0)
            self.myMapView.animate(to: camera)
            
    //
        }
        
        // MARK: GOOGLE MAP DELEGATE
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverJobOfferVC") as! DriverJobOfferVC
               
                    self.navigationController?.pushViewController(vc, animated: true)

            return false
        }
    
    func locationCheck()
        {
            if CLLocationManager.locationServicesEnabled()
                     {
                         switch CLLocationManager.authorizationStatus()
                         {
                         case .notDetermined, .restricted, .denied:
                             print("No access")
                          

                         case .authorizedAlways, .authorizedWhenInUse:
                             print("Access")
                             
                             locationManager.requestWhenInUseAuthorization()
                             locationManager.startUpdatingLocation()
                             locationManager.startMonitoringSignificantLocationChanges()
                          
                       }
                     }
                     else {
                         print("Location services are not enabled")
                       

                     }
        }
        
}
extension DriverHomeVC
{
    //MARK:- Change Status Account
     func UserStatusAPI()
          {
              
         
              var id = ""
                     if let userID = DEFAULT.value(forKey: "USERID") as? String
                     {
                         id = userID
                     }
                   
                        let params = ["userId" : id,
                                      "onlineStatus" : self.onlineStatus]   as [String : String]
                        
              ApiHandler.ModelApiPostMethod2(url: CHANGE_ONLINESTATUS_API, parameters: params) { (response, error) in
                  
                  if error == nil
                  {
                      let decoder = JSONDecoder()
                      do
                      {
                          self.apiData = try decoder.decode(ForgotPasswordModel.self, from: response!)
                       
                       if self.apiData?.code == "200"
                              
                          {
                              self.view.makeToast(self.apiData?.message)
               
                          }
                          else
                          {
    
                           self.view.makeToast(self.apiData?.message)
                          }
                          
                          
                      }
                      catch let error
                      {
                          self.view.makeToast(error.localizedDescription)
                      }
                      
                  }
                  else
                  {
                      self.view.makeToast(error)
                  }
              }
          }
        
}



struct MyPlace {
    var name: String
    var lat: Double
    var long: Double
}

    
