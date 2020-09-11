//
//  DriverMyJobVC.swift
//  Tosstra
//
//  Created by Eweb on 04/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import KYDrawerController
import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
class DriverMyJobVC: UIViewController {
    
    @IBOutlet var myTable:UITableView!
    
    var jobData:JobModel?
    var apiData:ForgotPasswordModel?
    private let refreshControl = UIRefreshControl()
    
    var jobId = ""
    var locationManager = CLLocationManager()
    var gameTimer: Timer?
    var now = Date()
    @IBOutlet var noDataLbl:UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate=self
        myTable.dataSource=self
        myTable.separatorStyle = .none
        myTable.register(UINib(nibName: "DriveMyJobCell", bundle: nil), forCellReuseIdentifier: "DriveMyJobCell")
        if #available(iOS 10.0, *) {
            self.myTable.refreshControl = refreshControl
        } else {
            self.myTable.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            DispatchQueue.main.async {
                
                
                self.MYJobAPI()
            }
            
        }
         
    }
    @objc private func refreshData(_ sender: Any)
    {
        
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            DispatchQueue.main.async {
                
                
                self.MYJobAPI()
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
           
       
           print(Date())
           let time15 = Date()
           let diffComponents = Calendar.current.dateComponents([.minute], from: now, to: time15)

           let timeGap = diffComponents.minute ?? 0
           
           print("timeGap  is = \(timeGap)")
           
           if timeGap == 15
           {
               //APPDEL.scheduleNotification(notificationType: "\(timeGap) passed")
              // self.mins_15_NotificationAPI()
              // self.now=Date()
           }
           else
           
           {
              //APPDEL.scheduleNotification(notificationType: "Not 15 min pass")
               
               print("timeGap  is = \(timeGap)")
           }

           
       }
    
    
    @IBAction func MenuAct(_ sender: UIButton)
    {
        let drawer = navigationController?.parent as? KYDrawerController
        drawer?.setDrawerState(.opened, animated: true)
    }
    
}
extension DriverMyJobVC:UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return self.jobData?.data?.count ?? 0
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriveMyJobCell") as! DriveMyJobCell
        
        let celldData =  self.jobData?.data?.reversed()[indexPath.row]
        
        
        cell.companyNameLbl.text = celldData?.companyName
        
        cell.userNaleLb.text = (celldData?.firstName ?? " ") + " " + (celldData?.lastName ?? " ")
        
        cell.startBtn.tag = indexPath.row
        cell.startBtn.addTarget(self, action: #selector(startBtnAct), for: UIControl.Event.touchUpInside)
        
        if let status = celldData?.jobStartStatus
        {
            if status == "1"
            {
                cell.startBtn.backgroundColor = APPCOLOL
                cell.startBtn.setTitle("Started", for: .normal)
                cell.startBtn.setTitleColor(UIColor.white, for: .normal)
                
                
            }
            else
            {
                cell.startBtn.backgroundColor = UIColor.white
                cell.startBtn.setTitle("Start", for: .normal)
                cell.startBtn.setTitleColor(APPCOLOL, for: .normal)
                
            }
        }
        else
        {
            cell.startBtn.backgroundColor = UIColor.white
            cell.startBtn.setTitle("Start", for: .normal)
            cell.startBtn.setTitleColor(APPCOLOL, for: .normal)
        }
        
        
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let celldData =  self.jobData?.data?.reversed()[indexPath.row]
        
        
        if let status = celldData?.jobStartStatus
        {
            if status == "1"
            {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverJobDetailVC") as! DriverJobDetailVC
                vc.jobData = celldData
                vc.jobId = celldData?.jobId ?? ""
                vc.dispatcherId = celldData?.dispatcherId ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else
            {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverJobOfferVC") as! DriverJobOfferVC
                
                vc.fromNoti = "yes"
                vc.jobId = celldData?.jobId ?? ""
                vc.dispatcherId = celldData?.dispatcherId ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverJobOfferVC") as! DriverJobOfferVC
            
            vc.fromNoti = "yes"
            vc.jobId = celldData?.jobId ?? ""
            vc.dispatcherId = celldData?.dispatcherId ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    @objc func startBtnAct(_ sender:UIButton)
    {
        let celldData =  self.jobData?.data?.reversed()[sender.tag]
        
        
        self.jobId = celldData?.jobId ?? ""
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.myTable.cellForRow(at: indexPath) as! DriveMyJobCell
        
        let text =  cell.startBtn.titleLabel?.text ?? ""
        
        if text == "Started"
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverJobDetailVC") as! DriverJobDetailVC
            vc.jobData = celldData
            vc.jobId = celldData?.jobId ?? ""
            vc.dispatcherId = celldData?.dispatcherId ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            
            if DEFAULT.value(forKey: "ISPAID") != nil
            {
               
                
                let alert = UIAlertController(title: "Alert", message: "Are you sure you want to start this job?", preferredStyle: UIAlertController.Style.alert)
                                       alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                                           print("Handle Cancel Logic here")
                                       }))
                                       alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                                           if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                                           {
                                               NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                                           }
                                           else
                                           {
                                               if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                                               {
                                                   NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                                               }
                                               else
                                               {
                                                   
                                                   
                                                   
                                                   self.JoBStartAPI()
                                                   
                                                   
                                               }
                                           }
                                           
                                           
                                       }))
                                       
                                       present(alert, animated: true, completion: nil)
                                       
                                   }
            else
                      {
                                   DEFAULT.removeObject(forKey: "ISPAID")
                                         DEFAULT.synchronize()
                                         
                                        
                                          let popUpVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentPopupVC") as! PaymentPopupVC
                                          //Don't forget initialize protocal deletage
                                          // EditOrDelete = "Delete"
                                          //  popUpVc.from = "Delete"
                                         // popUpVc.delegate = self
                                         self.gameTimer?.invalidate()
                                          self.addChild(popUpVc)
                                          popUpVc.view.frame = self.view.frame
                                          self.view.addSubview(popUpVc.view)
                                          popUpVc.didMove(toParent: self)
                      }
            }
          
            
            
            
            
            
            
        
        
        
        
        
    }
}

extension DriverMyJobVC
{
    //MARK:- MYJobAPI Api
    
    func MYJobAPI()
    {
        
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        
        let params = ["userId" : id]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: GET_MY_JOB_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                self.refreshControl.endRefreshing()
                let decoder = JSONDecoder()
                do
                {
                    self.jobData = try decoder.decode(JobModel.self, from: response!)
                    
                    if self.jobData?.data?.count ?? 0 > 0
                    {
                        self.gameTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: true)
                        self.noDataLbl.isHidden = true
                    }
                    else
                    {
                        self.gameTimer?.invalidate()
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
    
    //MARK:- JoBStartAPI Api
    
    func JoBStartAPI()
    {
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        
        let params = ["userId" : id,
                      "jobId" : self.jobId]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: START_JOB_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.apiData = try decoder.decode(ForgotPasswordModel.self, from: response!)
                    
                    
                    if self.apiData?.code == "200"
                    {
                       // NetworkEngine.showToast(controller: self, message: self.apiData?.message)
                        NetworkEngine.commonAlert(message: self.apiData?.message ?? "", vc: self)

                    }
                    else
                    {
                       self.view.makeToast(self.apiData?.message)
                        self.MYJobAPI()
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
                self.view.makeToast(error)
            }
        }
    }
    
    //MARK:- 15 mins Notification Account
          func mins_15_NotificationAPI()
          {
              
              
              var id = ""
              if let userID = DEFAULT.value(forKey: "USERID") as? String
              {
                  id = userID
              }
              
              let params = ["driverId" : id]   as [String : String]
              
              ApiHandler.ModelApiPostMethod2(url: NOTIFICATION_15MINS_API, parameters: params) { (response, error) in
                  
                  if error == nil
                  {
                      
                  }
                  else
                  {
                      self.view.makeToast(error)
                  }
              }
          }
    
    
}
//MARK:- location work

extension DriverMyJobVC:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let _ :CLLocation = locations[0] as CLLocation
        print("didUpdateLocations \(locations)")
        //let trigger = UNLocationNotificationTrigger(region: locations, repeats:false)
        //   APPDEL.scheduleNotification(notificationType: "amar")
        
        
       

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

                        let distanceInMeters = Int(coordinate₀.distance(from: coordinate₁)/1000)
                        
            
                        print("distanceInMeters KMs = \(distanceInMeters)")
                        
                        if(distanceInMeters <= 1)
                         {
                         // under 1 mile
                            
                         }
                         else
                        {
                         CURRENTLOCATIONLAT = latitude
                            CURRENTLOCATIONLONG = longitude
                            self.now=Date()
                          
                         }
                        
                        
                        
                        
//                        CURRENTLOCATIONLAT = latitude
//                        CURRENTLOCATIONLONG = longitude
//                        self.onlineStatus = "1"
//                        self.UserStatusAPI()
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
