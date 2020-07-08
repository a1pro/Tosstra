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
     //MARK:- Market task
    var allMarkerArray = NSMutableArray()
       var allMarkerArray2 = NSMutableArray()
    var markers = [GMSMarker]()
   
     var selectedMarkerIndex=0
    var customInfoWindow : markerDetailView?
    var tappedMarker : GMSMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        self.customInfoWindow = markerDetailView().loadView()
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
        
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.allDriverAPI()
        }
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        super.viewWillAppear(true)
        customInfoWindow?.removeFromSuperview()
        self.locationCheck()
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
               {
                   NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
               }
               else
               {
                   self.allDriverAPI()
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

extension DriverHomeVC
{
    //MARK:- all Driver API
    
    func allDriverAPI()
    {
        
        
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        
        let params = ["userId" : id,
                      "latitude" : "\(CURRENTLOCATIONLAT)",
            "longitude" : "\(CURRENTLOCATIONLONG)",
            "distance" : "2000"]   as [String : String]
        
        ApiHandler.PostMethod(url: GET_ALLJOB_API, parameters: params) { (response, error) in
            
             if error == nil
                       {
                           print(response)
                           if let dict = response as? NSDictionary
                           {
                               if let dataArray = dict.value(forKey: "data") as? NSArray
                               {
                                   
                                   self.allMarkerArray = dataArray.mutableCopy() as! NSMutableArray
                                   
                                   
                               }
                               
                           }
                          // self.markerCollection.reloadData()
                           self.showPartyMarkers()
                       }
                       else
                       {
                          self.view.makeToast(error)
                       }
        }
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
                      "onlineStatus" : self.onlineStatus,
                              "longitude" : "\(CURRENTLOCATIONLAT)",
                                "latitude" : "\(CURRENTLOCATIONLONG)"]   as [String : String]
        
        ApiHandler.ModelApiPostMethod2(url: CHANGE_ONLINESTATUS_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.apiData = try decoder.decode(ForgotPasswordModel.self, from: response!)
                    
                    if self.apiData?.code == "200"
                        
                    {
                        //self.view.makeToast(self.apiData?.message)
                        
                    }
                    else
                    {
                        
                        //self.view.makeToast(self.apiData?.message)
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
    func showPartyMarkers()
      {
          myMapView.clear()
          if markers.count>0
          {
              self.markers.removeAll()
          }
//        if allMarkerArray.count>0
//        {
//            self.allMarkerArray.removeAllObjects()
//        }

        
          //clusterManager.clearItems()
          for i in 0..<self.allMarkerArray.count
          {
              let dict = self.allMarkerArray.object(at: i) as! NSDictionary
              
              
             
          
              
              let lat = Double(dict.value(forKey: "latitude") as! String)
              let long = Double(dict.value(forKey: "longitude") as! String)
              
              if lat != nil || long != nil
              {
                 let marker=GMSMarker()
                 marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                 // let item = MoccherPOIItem(position: CLLocationCoordinate2DMake(lat!, long!), name: "\(i)", Tb_Type: "event")
                  //clusterManager.add(item)
                marker.icon = UIImage(named: "selectedmarker")
                 // marker.iconView = customInfoWindow
                self.markers.append(marker)
                             marker.map = self.myMapView
              }
              
             
          }
      }
}

//MARK:- Map Work

extension DriverHomeVC:GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate
{
    @objc func btnMarkerDetails(_ sender:UIButton)
         {
             print("btnGroupDetails click")
             let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverJobOfferVC") as! DriverJobOfferVC
             
            vc.dict = self.allMarkerArray.object(at: sender.tag) as! NSDictionary
            
             self.navigationController?.pushViewController(vc, animated: false)
             
         }
    
    // MARK: CLLocation Manager Delegate
    
    //MARK:- Map init code
          func initGoogleMaps() {
      //        let camera = GMSCameraPosition.camera(withLatitude: CURRENTLOCATIONLAT, longitude: CURRENTLOCATIONLONG, zoom: 17.0)
              
              let camera = GMSCameraPosition.camera(withLatitude: CURRENTLOCATIONLAT, longitude: CURRENTLOCATIONLONG, zoom: 6.0)
              self.myMapView.camera = camera
              self.myMapView.delegate = self
              self.myMapView.settings.compassButton = true
              self.myMapView.settings.myLocationButton=true
              self.myMapView.isMyLocationEnabled = true
              showPartyMarkers()
          }
    
    //MARK:-  Marker tap
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        NSLog("marker was tapped")
        tappedMarker = marker
        
  
        
        
        marker.icon = UIImage(named: "selectedmarker")
        //get position of tapped marker
        let position = marker.position
        mapView.animate(toLocation: position)
        let point = mapView.projection.point(for: position)
        let newPoint = mapView.projection.coordinate(for: point)
        let camera = GMSCameraUpdate.setTarget(newPoint)
        mapView.animate(with: camera)
        
        let opaqueWhite = UIColor(white: 1, alpha: 0.85)
        customInfoWindow?.layer.backgroundColor = opaqueWhite.cgColor
        customInfoWindow?.layer.cornerRadius = 8
        customInfoWindow?.center = mapView.projection.point(for: position)
        customInfoWindow?.center.y -= 100
        
        customInfoWindow?.backgroundColor = UIColor.clear

        if let index = markers.index(of: marker)
        {
            self.selectedMarkerIndex=index


                 
            print(index)
            if self.allMarkerArray.count>0
            {
                if let dict = self.allMarkerArray.object(at: index) as? NSDictionary
                {
                    
                     customInfoWindow?.userName.layer.cornerRadius = ((customInfoWindow?.userName.frame.height ?? 5)/2)
                    customInfoWindow?.userName.contentMode = .scaleAspectFill
                    customInfoWindow?.userName.clipsToBounds = true
                    
                    customInfoWindow?.profileImg.layer.cornerRadius = ((customInfoWindow?.profileImg.frame.height ?? 90)/2)
                    
                    customInfoWindow?.profileImg.contentMode = .scaleAspectFill
                    customInfoWindow?.profileImg.clipsToBounds = true
                    
                    customInfoWindow?.userName.text  = dict.value(forKey: "companyName") as? String ?? ""
                
                if let groupIcon = dict.value(forKey: "profileImg") as? String
                    
                {
                    if groupIcon != ""
                    {
                        let fullurl = IMAGEBASEURL + groupIcon
                        let url = URL(string: fullurl)!
                        customInfoWindow?.profileImg.image = nil
                        customInfoWindow?.profileImg.sd_setImage(with: url, completed: nil)
                    }
                    else
                    {
                        
                         customInfoWindow?.profileImg.setImage(string: customInfoWindow?.userName.text, color: APPCOLOL, circular: true,textAttributes: attrs)
                    }
                    
                }
                else
                {
                    
                    
                     customInfoWindow?.profileImg.setImage(string: customInfoWindow?.userName.text, color: APPCOLOL, circular: true,textAttributes: attrs)
                    
                }
                customInfoWindow?.profileBtn.tag = Int(dict.value(forKey: "jobId") as! String)!
                
            }
                customInfoWindow?.profileBtn.tag = index
            customInfoWindow?.profileBtn.addTarget(self, action: #selector(btnMarkerDetails), for: .touchUpInside)
            // marker.iconView = customInfoWindow
            mapView.addSubview(customInfoWindow!)
        }
                     
                     
            
       
        }
        else
        
        {
            customInfoWindow?.profileImg.setImage(string: customInfoWindow?.userName.text, color: APPCOLOL, circular: true,textAttributes: attrs)
            
            print(marker)
        }
        
        return false
    }
   
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        marker.icon = UIImage(named: "selectedmarker")
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
      // customInfoWindow?.profileImg.setImage(string: customInfoWindow?.userName.text, color: APPCOLOL, circular: true,textAttributes: attrs)
      
        
       customInfoWindow?.removeFromSuperview()
    }
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        let position = tappedMarker?.position
      //  customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "MarkerImage"), for: .normal)
        if position != nil
        {
            customInfoWindow?.center = mapView.projection.point(for: position!)
            customInfoWindow?.center.y -= 100
        }
        if let marker =  mapView.selectedMarker
        {

        //  customInfoWindow?.profileImg.setImage(string: customInfoWindow?.userName.text, color: APPCOLOL, circular: true,textAttributes: attrs)
        }
        else
        {
           // customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "MarkerImage"), for: .normal)
        //customInfoWindow?.profileImg.setImage(string: customInfoWindow?.userName.text, color: APPCOLOL, circular: true,textAttributes: attrs)
        }
        
    }
    
    
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker)
    {
        print("amar d gh h df")
        if let marker =  mapView.selectedMarker
        {
// customInfoWindow?.profileImg.setImage(string: customInfoWindow?.userName.text, color: APPCOLOL, circular: true,textAttributes: attrs)
            
        }
        
    }
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView?
    {
        let imageIcon = UIButton(frame: CGRect(x: 25, y: 0, width: 50, height: 50))
        imageIcon.setBackgroundImage(UIImage(named: "AppIcon-2"), for: .normal)
        
 //customInfoWindow?.profileImg.setImage(string: customInfoWindow?.userName.text, color: APPCOLOL, circular: true,textAttributes: attrs)
        //view.addSubview(imageIcon)
        
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return nil }
        // let data = previewDemoData[customMarkerView.tag]
        //restaurantPreviewView.setData(img:UIImage(named: "AppIcon-2")!)
        return UIView()//restaurantPreviewView
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker)
    {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
 //customInfoWindow?.profileImg.setImage(string: customInfoWindow?.userName.text, color: APPCOLOL, circular: true,textAttributes: attrs)
        
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        
        marker.icon = UIImage(named: "selectedmarker")
       // customInfoWindow?.profileImg.setImage(string: customInfoWindow?.userName.text, color: APPCOLOL, circular: true,textAttributes: attrs)
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.darkGray, tag: customMarkerView.tag)
        marker.iconView = customMarker
    }
    
    
    // MARK: GOOGLE AUTO COMPLETE DELEGATE
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        
        // showPartyMarkers(lat: lat, long: long)
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        myMapView.camera = camera
        //  txtFieldSearch.text=place.formattedAddress
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
//MARK:- location work

extension DriverHomeVC:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let _ :CLLocation = locations[0] as CLLocation
        
        if let lastLocation = locations.last
        {
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(lastLocation) { [weak self] (placemarks, error) in
                if error == nil
                {
                    if let firstLocation = placemarks?[0],
                        let cityName = firstLocation.locality,   // locality
                        let stateName = firstLocation.subLocality,
                        let nationality = firstLocation.administrativeArea,
                        let latitude = firstLocation.location?.coordinate.latitude,
                        let longitude = firstLocation.location?.coordinate.longitude
                    {
                        print(firstLocation)
                        
                        print(cityName + stateName + nationality)
                        let country = firstLocation.country ?? ""
                      //  self?.Mycoordinate = CLLocation(latitude: latitude, longitude: longitude)
                        let address =   nationality + " , " + country
                          CURRENTLOCATIONLONG=longitude
                        CURRENTLOCATIONLAT=latitude
                        DEFAULT.set(address, forKey: "CURRENTLOCATION")
                        DEFAULT.synchronize()
                    
                        CURRENTLOCATIONLAT = latitude
                        CURRENTLOCATIONLONG = longitude
                        
                        DEFAULT.set("\(latitude)", forKey: "CURRENTLAT")
                        DEFAULT.set("\(longitude)", forKey: "CURRENTLONG")
                        //  self?.CompanyLocationTF.text! = address
                      //  self?.locLbl.text=address
                        
                        self?.locationManager.stopUpdatingLocation()
                        
                    }
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
    }
    
}
struct MyPlace {
    var name: String
    var lat: Double
    var long: Double
}


