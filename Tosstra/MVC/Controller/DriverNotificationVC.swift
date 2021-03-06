//
//  DriverNotificationVC.swift
//  Tosstra
//
//  Created by Eweb on 04/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import KYDrawerController

class DriverNotificationVC: UIViewController {
    @IBOutlet var myTable:UITableView!
    var apiData:NotificationModel?
    var appType="Dispatcher"
    var timeformat = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate=self
        myTable.dataSource=self
        myTable.separatorStyle = .none
        myTable.rowHeight = 100
        myTable.estimatedRowHeight = UITableView.automaticDimension
        
        
        //        if TIMEFORMATE == "12"
        //        {
        //            self.timeformat = "yyyy-MM-dd hh:mm:ss"
        //        }
        //        else
        //        {
        //          self.timeformat = "yyyy-MM-dd hh:mm:ss"
        //        }
        
        myTable.register(UINib(nibName: "DriverNotiCell", bundle: nil), forCellReuseIdentifier: "DriverNotiCell")
        
        self.appType = DEFAULT.value(forKey: "APPTYPE") as? String ?? "Dispatcher"
        
        if appType == "Dispatcher"
        {
            
            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
            {
                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
            }
            else
            {
                self.GETDISNOTIAPI()
            }
        }
        else
            
        {
            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
            {
                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
            }
            else
            {
                self.GETDRIVERNOTIAPI()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         print("current data = \(Date())")
    }
    
    @IBAction func MenuAct(_ sender: UIButton)
    {
        let drawer = navigationController?.parent as? KYDrawerController
        drawer?.setDrawerState(.opened, animated: true)
    }
    
}
extension DriverNotificationVC:UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return self.apiData?.data?.count ?? 0
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriverNotiCell") as! DriverNotiCell
        //cell.selectedBackgroundView = bgColorView
        
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let cellData = self.apiData?.data?.reversed()[indexPath.row]
        
        let createDate = cellData?.create_at ?? "2020-07-10 10:55:18"
        
        let date = createDate.toDate(withFormat: self.timeformat)
        cell.timeLbl.isHidden = true
        //cell.timeLbl.text = cellData?.notificationTime ?? "10:55:"
   //     cell.timeLbl.text =  createDate.UTCToLocal(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "E,d MMM yyyy, h:mm a")
        
        //createDate.toDateString(inputDateFormat:  self.timeformat, ouputDateFormat: "hh:mm a")
        
        cell.dayAgoLbl.text = "".convertDateFormater(createDate)//(createDate.UTCToLocal(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "d MMM yyyy, h:mm a"))//.UTCToLocal(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "E,d MMM yyyy, h:mm a") //cellData?.notificationDate ?? "2020-07-10"
        //"".convertDateFormater(createDate)
        // cell.dayAgoLbl.text =  date?.timeAgoSinceDate()
        cell.dateLbl.isHidden = true
        
        
        cell.messageTitle.text = cellData?.message
        
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let cellData = self.apiData?.data?.reversed()[indexPath.row]
        
        let type = cellData?.type ?? ""
        
        if type == "3"
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverJobOfferVC") as! DriverJobOfferVC
            vc.fromNoti = "yes"
            vc.jobId = cellData?.jobId ?? ""
            
            vc.dispatcherId = cellData?.dispatcherId ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else  if type == "4"
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DisJobDetailsVC") as! DisJobDetailsVC
            vc.fromNoti = "yes"
            vc.jobId = cellData?.jobId ?? ""
            
            vc.dispatcherId = cellData?.dispatcherId ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else{
            //NetworkEngine.commonAlert(message: cellData?.message ?? "", vc: self)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func convertToUTC(dateToConvert:String) -> String
    {
        //"2020-08-14 18:22:46"s
     let formatter = DateFormatter()
     formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
     let convertedDate = formatter.date(from: dateToConvert)
     formatter.timeZone = TimeZone(identifier: "UTC")
     return formatter.string(from: convertedDate!)
        
    }
}
extension DriverNotificationVC
{
    //MARK:- GETDISNOTIAPI Api
    
    func GETDISNOTIAPI()
    {
        
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        let params = ["userId" : id]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: GET_DIS_NOTI_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.apiData = try decoder.decode(NotificationModel.self, from: response!)
                    
                    if self.apiData?.code == "200"
                        
                    {
                        
                        NetworkEngine.showToast(controller: self, message: self.apiData?.message)
                        
                    }
                    else
                    {
                        
                        self.myTable.reloadData()
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
    
    //MARK:- GETDRIVERNOTIAPI Api
    
    func GETDRIVERNOTIAPI()
    {
        
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        let params = ["userId" : id]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: GET_DRIVER_NOTI_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.apiData = try decoder.decode(NotificationModel.self, from: response!)
                    
                    if self.apiData?.code == "200"
                        
                    {
                        
                        NetworkEngine.showToast(controller: self, message: self.apiData?.message)
                        
                    }
                    else
                    {
                        
                        
                        self.myTable.reloadData()
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
extension Date {
    
    func timeAgoSinceDate() -> String {
        
        // From Time
        let fromDate = self
        
        // To Time
        let toDate = Date()
        
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }
        
        return "a moment ago"
    }
}
extension String {
    
    func toDate(withFormat format: String)-> Date?{
        
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        dateFormatter.locale = Locale.current
        // dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        if date != nil
        {
            return date
        }
        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
            dateFormatter.locale = Locale.current
            // dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            let date = dateFormatter.date(from: self)
            return date
        }
        
    }
}
extension String {
    
    //MARK:- Convert UTC To Local Date by passing date formats value
    func UTCToLocal(incomingFormat: String, outGoingFormat: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = incomingFormat
       dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        //MARK:-
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        
        print("TimeZone.current = \(TimeZone.current)")
        dateFormatter.dateFormat = outGoingFormat
        print(dt)
        return dateFormatter.string(from: dt ?? Date())
    }
    
    //MARK:- Convert Local To UTC Date by passing date formats value
    func localToUTC(incomingFormat: String, outGoingFormat: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = incomingFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = outGoingFormat
        
        return dateFormatter.string(from: dt ?? Date())
    }
    
    func convertDateFormater(_ dateX: String) -> String
    {
        
       
       // (createDate.UTCToLocal(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "d MMM yyyy, h:mm a"))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateX)
        dateFormatter.dateFormat = "d MMM yyyy, h:mm a"
        if date != nil
        {
           return  dateFormatter.string(from: date!)
        }
        else
        {
               let dateFormatter2 = DateFormatter()
                 dateFormatter2.dateFormat = "yyyy-MM-dd hh:mm:ss"
                 let date2 = dateFormatter2.date(from: dateX)
                 dateFormatter2.dateFormat = "d MMM yyyy, h:mm a"
            if date2 != nil
            {
               return  dateFormatter2.string(from: date2!)
            }
            else
            {
                return  ""
            }
            
           
        }
        
    }
}
