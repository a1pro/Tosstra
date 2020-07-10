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
        
        let createDate = cellData?.notificationTime ?? "2020-07-10 10:55:18"
        
        let date = createDate.toDate(withFormat: self.timeformat)
            
        cell.timeLbl.text = cellData?.notificationTime ?? "10:55:"
        //createDate.toDateString(inputDateFormat:  self.timeformat, ouputDateFormat: "hh:mm a")
        
        cell.dayAgoLbl.text = cellData?.notificationDate ?? "2020-07-10"
        //"".convertDateFormater(createDate)
       // cell.dayAgoLbl.text =  date?.timeAgoSinceDate()
        cell.dateLbl.isHidden = true
        
        
        cell.messageTitle.text = cellData?.message
        
        
        return cell

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 5
        {
            if #available(iOS 13.0, *) {
                SCENEDEL.loadLoginView()
            }
            else
            {
                APPDEL.loadLoginView()
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
                        self.view.makeToast(self.apiData?.message)
                        
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
                        self.view.makeToast(self.apiData?.message)
                        
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
extension String
{
    func toDateString( inputDateFormat inputFormat  : String,  ouputDateFormat outputFormat  : String ) -> String
    {
        let dateFormatter = DateFormatter()
       // dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        dateFormatter.dateFormat = inputFormat
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = outputFormat
        if date != nil
        {
           return dateFormatter.string(from: date!)
        }
        else
        {
            let dateFormatter = DateFormatter()
                   //dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
                   dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                   let date = dateFormatter.date(from: self)
                   dateFormatter.dateFormat = outputFormat
            return ""
        }
        
    }
    
    func convertDateFormater(_ date: String) -> String
    {

        //2020-07-10 15:37:24
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = TimeZone.ReferenceType.local
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: date)
        {
           dateFormatter.timeZone = TimeZone(identifier: "UTC")
           let calendar = Calendar.current
           let dayComponent = calendar.component(.year, from: date)
            
            return dateFormatter.string(from: date)
        }
        else
        {
          dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss" // Date as 12 hour
         if let date = dateFormatter.date(from: date)
         {
           dateFormatter.timeZone = TimeZone(identifier: "UTC")
          let calendar = Calendar.current
          let dayComponent = calendar.component(.year, from: date)
            return dateFormatter.string(from: date)
        }
         else{
           print("Cannot format Date")
            
            return ""
         }
             return ""
        }

    }
}
