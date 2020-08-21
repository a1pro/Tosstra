//
//  DisHomeVC.swift
//  Tosstra
//
//  Created by Eweb on 02/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import KYDrawerController
import CoreLocation
class DisHomeVC: UIViewController
{
    @IBOutlet var myTable:UITableView!
    
    @IBOutlet var allTruckView:UIView!
    @IBOutlet var seniorTruckView:UIView!
    
    @IBOutlet var lblCount:UILabel!
    
    @IBOutlet var noDataLbl:UILabel!
    
    @IBOutlet var pBtn:UIButton!
    
    var viewProfiledata:ViewProfileModel?
    var apiData:ForgotPasswordModel?
    var truckType="all"
    var driverId = ""
    
    var selectedDriverArray = NSMutableArray()
    var selectedgroupCatArray = NSMutableArray()
    var checkArray = NSMutableArray()
    private let refreshControl = UIRefreshControl()
    var locationManager = CLLocationManager()

    public var longitude:Double = CURRENTLOCATIONLONG
       public var latitude:Double = CURRENTLOCATIONLAT
    override func viewDidLoad()
    {
        super.viewDidLoad()
        locationCheck()
        myTable.delegate=self
        myTable.dataSource=self
        myTable.separatorStyle = .none
        myTable.register(UINib(nibName: "SeniorTrackTCell", bundle: nil), forCellReuseIdentifier: "SeniorTrackTCell")
        myTable.register(UINib(nibName: "AllTrackTableViewCell", bundle: nil), forCellReuseIdentifier: "AllTrackTableViewCell")
        
        if #available(iOS 10.0, *) {
            self.myTable.refreshControl = refreshControl
        } else {
            self.myTable.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        locationManager.startUpdatingLocation()
               locationManager.delegate = self
               locationManager.requestWhenInUseAuthorization()
               locationManager.startUpdatingLocation()
               locationManager.startMonitoringSignificantLocationChanges()
               locationManager.pausesLocationUpdatesAutomatically = false
               locationManager.allowsBackgroundLocationUpdates=true
               self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.get_All_DriversAPI()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locationCheck()
    }
    
    func locationCheck()
      {

          if CLLocationManager.locationServicesEnabled()
                {
                    switch CLLocationManager.authorizationStatus()
                    {
                    case .notDetermined, .restricted, .denied:
                        print("No access")
                        
                        let alertController = UIAlertController(title: "Enable GPS", message: "GPS is not enable.Do you want to go setting menu.", preferredStyle: .alert)
                        
                        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
                        let settingsAction = UIAlertAction(title: "SETTING", style: .default) { (UIAlertAction) in
                            UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                        }
                        
                        alertController.addAction(cancelAction)
                        alertController.addAction(settingsAction)
                        self.present(alertController, animated: true, completion: nil)
                    case .authorizedAlways, .authorizedWhenInUse:
                        print("Access")
                      
                      locationManager.requestWhenInUseAuthorization()
                      locationManager.startUpdatingLocation()
                      locationManager.startMonitoringSignificantLocationChanges()
                    }
                }
                else {
                    print("Location services are not enabled")
                    let alertController = UIAlertController(title: "Enable GPS", message: "GPS is not enable.Do you want to go setting menu.", preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
                    let settingsAction = UIAlertAction(title: "SETTING", style: .default) { (UIAlertAction) in
                        UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                    }
                    
                    alertController.addAction(cancelAction)
                    alertController.addAction(settingsAction)
                    self.present(alertController, animated: true, completion: nil)
                }
      }
    
    @objc private func refreshData(_ sender: Any)
    {
        locationCheck()
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            DispatchQueue.main.async {
                
                
                if self.truckType == "all"
                {
                    self.get_All_DriversAPI()
                }
                else
                {
                    self.get_Only_FavDriversAPI()
                }
                
            }
            
        }
        
    }
    
    @IBAction func MenuAct(_ sender: UIButton)
    {
        let drawer = navigationController?.parent as? KYDrawerController
        drawer?.setDrawerState(.opened, animated: true)
    }
    
    @IBAction func plusAct(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DisjobDescriptionVC") as! DisjobDescriptionVC
        vc.offerForSelectedDrivers = self.selectedDriverArray.componentsJoined(by: ",")
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func allTruckAct(_ sender: UIButton)
    {
        if self.selectedDriverArray.count>0
        {
            self.selectedDriverArray.removeAllObjects()
        }
        if self.checkArray.count>0
        {
            self.checkArray.removeAllObjects()
        }
        self.truckType = "all"
        self.allTruckView.backgroundColor = APPCOLOL
        self.seniorTruckView.backgroundColor = UIColor.lightGray
        
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.get_All_DriversAPI()
        }
        
    }
    
    @IBAction func seniorTruckAct(_ sender: UIButton)
    {
        if self.selectedDriverArray.count>0
        {
            self.selectedDriverArray.removeAllObjects()
        }
        if self.checkArray.count>0
        {
            self.checkArray.removeAllObjects()
        }
        self.truckType = "senior"
        self.allTruckView.backgroundColor = UIColor.lightGray
        self.seniorTruckView.backgroundColor = APPCOLOL
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.get_Only_FavDriversAPI()
        }
    }
    
    
}
extension DisHomeVC:UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.truckType == "all"
        {
            return self.viewProfiledata?.data?.count ?? 0
        }
        else
        {
            return self.viewProfiledata?.data?.count ?? 0
        }
        
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        
        
        if self.truckType == "all"
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllTrackTableViewCell") as! AllTrackTableViewCell
            // cell.selectedBackgroundView = bgColorView
            
            let celldData =  self.viewProfiledata?.data?.reversed()[indexPath.row]
            
            cell.userName.text = (celldData?.firstName ?? "") + " " + (celldData?.lastName ?? "")
            
            cell.trsportName.text = celldData?.companyName
            
            cell.checkBtn.tag = indexPath.row
            cell.checkBtn.addTarget(self, action: #selector(AllTrackcheckAct), for: UIControl.Event.touchUpInside)
            
            if self.checkArray.contains(indexPath.row)
            {
                let id = celldData?.id ?? ""
                
                if self.selectedDriverArray.contains(id)
                {
                    
                }
                else
                {
                    self.selectedDriverArray.add(id)
                    
                }
                
                
                cell.checkBtn.setImage(UIImage(named: "check-box"), for: .normal)
            }
            else
            {
                cell.checkBtn.setImage(UIImage(named: "check-box-1"), for: .normal)
            }
            
            
            if self.selectedDriverArray.count>0
            {
                self.pBtn.isEnabled = true
                self.lblCount.text = "Total- " + "\(self.selectedDriverArray.count)" + " Selected"
            }
            else
            {
                self.pBtn.isEnabled = false
                self.lblCount.text = "Total- " + "\(self.selectedDriverArray.count)" + " Selected"
            }
            //
            
            
            cell.favBtn.tag = indexPath.row
            cell.favBtn.addTarget(self, action: #selector(UnfavBtnAct), for: UIControl.Event.touchUpInside)
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SeniorTrackTCell") as! SeniorTrackTCell
            let celldData =  self.viewProfiledata?.data?.reversed()[indexPath.row]
            
            cell.userName.text = (celldData?.firstName ?? "") + " " + (celldData?.lastName ?? "")
            
            cell.trsportName.text = celldData?.companyName
            
            cell.checkBtn.tag = indexPath.row
            cell.checkBtn.addTarget(self, action: #selector(SeniorTrackcheckAct), for: UIControl.Event.touchUpInside)
            
            if self.checkArray.contains(indexPath.row)
            {
                let id = celldData?.id ?? ""
                
                if self.selectedDriverArray.contains(id)
                {
                    
                }
                else
                {
                    self.selectedDriverArray.add(id)
                    
                }
                
                
                cell.checkBtn.setImage(UIImage(named: "check-box"), for: .normal)
            }
            else
            {
                cell.checkBtn.setImage(UIImage(named: "check-box-1"), for: .normal)
            }
            
            
            if self.selectedDriverArray.count>0
            {
                self.pBtn.isEnabled = true
                self.lblCount.text = "Total- " + "\(self.selectedDriverArray.count)" + " Selected"
            }
            else
            {
                self.pBtn.isEnabled = false
                self.lblCount.text = "Total- " + "\(self.selectedDriverArray.count)" + " Selected"
            }
            
            
            
            
            
            cell.favBtn.tag = indexPath.row
            cell.favBtn.addTarget(self, action: #selector(UnfavBtnAct), for: UIControl.Event.touchUpInside)
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
        let celldData =  self.viewProfiledata?.data?.reversed()[indexPath.row]
        
        vc.userId = celldData?.id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
    
    @objc func UnfavBtnAct(_ sender:UIButton)
    {
        let celldData =  self.viewProfiledata?.data?.reversed()[sender.tag]
        
        
        self.driverId = celldData?.id ?? ""
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.driver_Favorite_UnfavoriteAPI()
        }
    }
    
    @objc func AllTrackcheckAct(_ sender:UIButton)
    {
        
        
        if self.selectedDriverArray.count>0
        {
            self.selectedDriverArray.removeAllObjects()
        }
        if self.selectedgroupCatArray.count>0
        {
            self.selectedgroupCatArray.removeAllObjects()
        }
        
        if self.checkArray.contains(sender.tag)
        {
            self.checkArray.remove(sender.tag)
        }
        else
        {
            self.checkArray.add(sender.tag)
        }
        print("check array = \(self.checkArray)")
        
        
        self.myTable.reloadData()
        
    }
    
    @objc func SeniorTrackcheckAct(_ sender:UIButton)
    {
        
        if self.selectedDriverArray.count>0
        {
            self.selectedDriverArray.removeAllObjects()
        }
        if self.selectedgroupCatArray.count>0
        {
            self.selectedgroupCatArray.removeAllObjects()
        }
        
        if self.checkArray.contains(sender.tag)
        {
            self.checkArray.remove(sender.tag)
        }
        else
        {
            self.checkArray.add(sender.tag)
        }
        print("check array = \(self.checkArray)")
        
        
        self.myTable.reloadData()
    }
}
extension DisHomeVC
{
    //MARK:- get-All-Drivers Api
    
    func get_All_DriversAPI()
    {
        
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        
        let params = ["userId" : id,
                    "latitude" : "\(self.latitude)",
                   "longitude" : "\(self.longitude)"]  as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: GET_ALL_DRIVER_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                self.refreshControl.endRefreshing()
                let decoder = JSONDecoder()
                do
                {
                    self.viewProfiledata = try decoder.decode(ViewProfileModel.self, from: response!)
                    
                    self.myTable.reloadData()
                    
                    if self.viewProfiledata?.data?.count ?? 0 > 0
                    {
                        self.noDataLbl.isHidden = true
                    }
                    else
                    {
                        self.noDataLbl.isHidden = false
                    }
                }
                catch let error
                {
                    self.view.makeToast(error.localizedDescription)
                }
                
            }
            else
            {
                self.refreshControl.endRefreshing()
                self.view.makeToast(error)
            }
        }
    }
    //MARK:- get-All-Drivers Api
    
    func get_Only_FavDriversAPI()
    {
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        
        let params = ["userId" : id,
                      "latitude" : "\(self.latitude)",
            "longitude" : "\(self.longitude)"]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: GET_FAV_DRIVER_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                self.refreshControl.endRefreshing()
                let decoder = JSONDecoder()
                do
                {
                    self.viewProfiledata = try decoder.decode(ViewProfileModel.self, from: response!)
                    
                    if self.viewProfiledata?.data?.count ?? 0 > 0
                    {
                        self.noDataLbl.isHidden = true
                    }
                    else
                    {
                        self.noDataLbl.isHidden = false
                    }
                    self.myTable.reloadData()
                    
                    
                }
                catch let error
                {
                    self.view.makeToast(error.localizedDescription)
                }
                
            }
            else
            {
                self.refreshControl.endRefreshing()
                self.view.makeToast(error)
            }
        }
    }
    
    
    //MARK:- driver-Favorite-Unfavorite Api
    
    func driver_Favorite_UnfavoriteAPI()
    {
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        
        let params = ["userId" : id,
                      "driverId" : self.driverId]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: driver_Favorite_Unfavorite_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.apiData = try decoder.decode(ForgotPasswordModel.self, from: response!)
                    
                    self.myTable.reloadData()
                    if self.truckType == "all"
                    {
                        self.get_All_DriversAPI()
                    }
                    else
                    {
                        self.get_Only_FavDriversAPI()
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
//MARK:- location work

extension DisHomeVC:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let _ :CLLocation = locations[0] as CLLocation
        print("didUpdateLocations \(locations)")
      
        if let lastLocation = locations.last
        {
            
            
            self.latitude = lastLocation.coordinate.latitude
            self.longitude = lastLocation.coordinate.longitude
            
            DEFAULT.set("\(latitude)", forKey: "CURRENTLAT")
            DEFAULT.set("\(longitude)", forKey: "CURRENTLONG")
   
            CURRENTLOCATIONLAT = self.latitude
            CURRENTLOCATIONLONG = self.longitude

            }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
    }
    
}

