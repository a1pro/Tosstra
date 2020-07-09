//
//  DisSigninVC.swift
//  Tosstra
//
//  Created by Eweb on 02/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import CoreLocation
class DisSigninVC: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet var signInBtn:UIButton!
    
    @IBOutlet var userNameTxt:UITextField!
    
    @IBOutlet var passwordTxt:UITextField!
    
    var Apptype = ""
    var useLocation = ""
    
    var groupLat = ""
    var groupLong = ""
    var groupCity = ""
    var groupState = ""
    var groupCountry = ""
    var groupLocation = ""
    var firstName = ""
    var lastName = ""
    var gender = ""
    var currentLat = ""
    var currentLong = ""
    var age = ""
    var coutry = ""
    var selectedLocation = ""
    var selectedAge = ""
       var selectedGender = ""
       var selectedLookingFor = ""
       var fromGender = ""
       
       var contactNumber = ""
       var lookingFor = ""
       var aboutMe = ""
       var country_code = ""
       var state = ""
       var city = ""
    // For location
    let manager = CLLocationManager()
    var signInData:Dis_Login_Model?
    
    @IBOutlet var forGotBtn:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : APPCOLOL]
        
        let attributedString1 = NSMutableAttributedString(string:"Don't have an account?", attributes:attrs1)
        
        let attributedString2 = NSMutableAttributedString(string:" Sign up", attributes:attrs2)
        
        attributedString1.append(attributedString2)
        self.signInBtn.setAttributedTitle(attributedString1, for: .normal)
        let attributeString = NSMutableAttributedString(string: "Forgot Password?",
                                                        attributes: underLineText)
        forGotBtn.setAttributedTitle(attributeString, for: .normal)
        manager.delegate = self
               manager.desiredAccuracy = kCLLocationAccuracyBest
               manager.requestWhenInUseAuthorization()
               manager.startUpdatingLocation()
    }
    
    @IBAction func goBackBtn(_ sender: Any)
    {
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func forGotpasswordAct(_ sender: Any)
    {
        
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForPassVC") as! ForPassVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func signInAct(_ sender: Any)
    {
        
        if userNameTxt.text == ""
        {
            
            NetworkEngine.commonAlert(message: "Please enter email id.", vc: self)
            
        }
        else if !NetworkEngine.networkEngineObj.validateEmail(candidate: userNameTxt.text!)
        {
            NetworkEngine.commonAlert(message: "Please enter valid email.", vc: self)
        }
        else if passwordTxt.text == ""
        {
            NetworkEngine.commonAlert(message: "Please enter password.", vc: self)
            
        }
        else
        {
            
            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
            {
                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
            }
            else
            {
                self.SignInWithEmailAPI()
            }
            
        }
  
        
        
    }
    
    @IBAction func signupAct(_ sender: Any)
    {
        if self.Apptype == "driver"
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverSignupVC") as! DriverSignupVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DisSignupVC") as! DisSignupVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
}
extension DisSigninVC
{
    //MARK:- Login With Email Api
    
    func SignInWithEmailAPI()
    {
        var DEVICETOKEN = "12312"
               if let userID = DEFAULT.value(forKey: "DEVICETOKEN") as? String
               {
                   DEVICETOKEN = userID
               }
        
        
        let params = ["email" : userNameTxt.text!,
                      "password" : passwordTxt.text!,
                      "latitude" : "\(CURRENTLOCATIONLAT)",
                      "longitude" : "\(CURRENTLOCATIONLONG)",
                      "deviceId" : DEVICETOKEN,
                      "deviceType" : DEVICETYPE]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: DISPATCHER_LOGIN_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.signInData = try decoder.decode(Dis_Login_Model.self, from: response!)
                    
                    if self.signInData?.code == "200"
                        
                    {
                        self.view.makeToast(self.signInData?.message)
                        
                    }
                    else
                    {
                        let count = self.signInData?.data?.count ?? 0
                        
                        
                        
                        if count > 0
                        {
                            var type = self.signInData?.data?[0].userType
                            
                            var status = self.signInData?.data?[0].verifiedStatus
                            
                            if status == "0"
                            {
                                NetworkEngine.commonAlert(message: "Please verify email first!", vc: self)
                            }
                            else{
                                
                                
                                DEFAULT.set(self.signInData?.data?[0].id, forKey: "USERID")
                                DEFAULT.set(type, forKey: "USERTYPE")
                                DEFAULT.set(type, forKey: "APPTYPE")
                                
                                DEFAULT.synchronize()
                                
                                if type == "Dispatcher"
                                {
                                    if #available(iOS 13.0, *) {
                                        SCENEDEL.loadHomeView()
                                        
                                    }
                                    else
                                    {
                                        APPDEL.loadHomeView()
                                    }
                                }
                                else
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
                            }
                            
                            
                            
                            
                            
                        }
                        
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
                        
                        let address = stateName + " , " + cityName + " , " + nationality
                        self?.selectedLocation = address
                        self?.coutry = firstLocation.country!
                        self?.city = cityName
                        self?.state = stateName
                        self?.country_code = firstLocation.isoCountryCode ?? "IND"
                        print("Address =  \(address)")
                        self?.currentLong = "\(longitude)"
                        self?.currentLat = "\(latitude)"
                        CURRENTLOCATIONLAT = latitude
                        CURRENTLOCATIONLONG = longitude
                        
                        DEFAULT.set("\(latitude)", forKey: "CURRENTLAT")
                        DEFAULT.set("\(longitude)", forKey: "CURRENTLONG")
                        //  self?.CompanyLocationTF.text! = address
                        self?.manager.stopUpdatingLocation()
                       
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

