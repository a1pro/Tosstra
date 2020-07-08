//
//  DisSettingVC.swift
//  Tosstra
//
//  Created by Eweb on 02/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import KYDrawerController

class DisSettingVC: UIViewController {
   var viewProfiledata:ViewProfileModel?
    
    var onlineStatus = "0"
    
      @IBOutlet var myTable:UITableView!
    
    var titleArray = ["Term & Conditions","Privacy Policy","Contact Us","Help","Change Password","Delete Account","Log Out","offline/Online"]
      
    var DisIconArray = ["term&conditions","Privacy-policy","Contact-us","Help","Privacy-policy","Delete-icon","Log-out","online"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate=self
                             myTable.dataSource=self
                             myTable.separatorStyle = .none
                      myTable.register(UINib(nibName: "SettingTCell", bundle: nil), forCellReuseIdentifier: "SettingTCell")
    }
    @IBAction func MenuAct(_ sender: UIButton)
    {
        let drawer = navigationController?.parent as? KYDrawerController
        drawer?.setDrawerState(.opened, animated: true)
    }
}
extension DisSettingVC:UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      
        return self.titleArray.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
     let bgColorView = UIView()
    bgColorView.backgroundColor = UIColor.clear
                 
    
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTCell") as! SettingTCell
        //cell.selectedBackgroundView = bgColorView
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.iconImg.image = UIImage(named: self.DisIconArray[indexPath.row])
                  
        cell.itleLbl.text  = self.titleArray[indexPath.row]
        
        if indexPath.row == self.titleArray.count-1
        {
            cell.offOnSwicth.isHidden = false
        }
        else
        {
            cell.offOnSwicth.isHidden = true
        }
        
        
        
        
        if let  status = DEFAULT.value(forKey: "ONLINESTATUS") as? String
        {
            if status == "1"
            {
                cell.offOnSwicth.setOn(true, animated: true)
            }
            else
            {
                cell.offOnSwicth.setOn(false, animated: true)
            }
        }
        else
        {
            cell.offOnSwicth.setOn(false, animated: true)
        }
        
        cell.offOnSwicth.addTarget(self, action: #selector(offlineStatus), for: .valueChanged)
        
                  return cell
           
             
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
         if indexPath.row == 4
                            {
                               let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
                            
                               self.navigationController?.pushViewController(vc, animated: true)
       }
        else  if indexPath.row == 5
                      {
                         
                          
                          let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete your account?", preferredStyle: UIAlertController.Style.alert)
                          alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
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
                                  self.DeleteAccountAPI()
                                 }
                              }
                             
                              
                          }))
                          alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                              print("Handle Cancel Logic here")
                          }))
                          present(alert, animated: true, completion: nil)
                          
                          
                      }
       else if indexPath.row == 6
               {
                   
                   let alert = UIAlertController(title: "Alert", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
                   alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action: UIAlertAction!) in
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
                           self.logoutAPI()
                          }
                       }
                      
                       
                   }))
                   alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                       print("Handle Cancel Logic here")
                   }))
                   present(alert, animated: true, completion: nil)
                   
                   
                   
               }
                      
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @objc func offlineStatus(_ sender:UISwitch)
    {
        print("swiftch \(sender.isOn)")
        if sender.isOn
        {
            self.onlineStatus = "1"
        }
        else
        {
            self.onlineStatus = "0"
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
extension DisSettingVC
{
    //MARK:- Login With Email Api
       
       func logoutAPI()
       {
           
      
           var id = ""
                  if let userID = DEFAULT.value(forKey: "USERID") as? String
                  {
                      id = userID
                  }
                
                     let params = ["userId" : id]   as [String : String]
                     
           ApiHandler.ModelApiPostMethod(url: LOGOUT_PROFILE_API, parameters: params) { (response, error) in
               
               if error == nil
               {
                   let decoder = JSONDecoder()
                   do
                   {
                       self.viewProfiledata = try decoder.decode(ViewProfileModel.self, from: response!)
                    
                    if self.viewProfiledata?.code == "200"
                           
                       {
                           self.view.makeToast(self.viewProfiledata?.message)
            
                       }
                       else
                       {
                       
                        
                         
                        DEFAULT.removeObject(forKey: "USERTYPE")
                        DEFAULT.removeObject(forKey: "APPTYPE")
                        DEFAULT.removeObject(forKey: "USERID")
                          
                            
                            DEFAULT.synchronize()
                            
                          if #available(iOS 13.0, *) {
                            SCENEDEL.loadLoginView()
                                   }
                                   else
                                   {
                                       APPDEL.loadLoginView()
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
    
    //MARK:- Delete Account
      func DeleteAccountAPI()
           {
               
          
               var id = ""
                      if let userID = DEFAULT.value(forKey: "USERID") as? String
                      {
                          id = userID
                      }
                    
                         let params = ["userId" : id]   as [String : String]
                         
               ApiHandler.ModelApiPostMethod(url: DELETE_PROFILE_API, parameters: params) { (response, error) in
                   
                   if error == nil
                   {
                       let decoder = JSONDecoder()
                       do
                       {
                           self.viewProfiledata = try decoder.decode(ViewProfileModel.self, from: response!)
                        
                        if self.viewProfiledata?.code == "200"
                               
                           {
                               self.view.makeToast(self.viewProfiledata?.message)
                
                           }
                           else
                           {
                           
                            
                             
                            DEFAULT.removeObject(forKey: "USERTYPE")
                            DEFAULT.removeObject(forKey: "APPTYPE")
                            DEFAULT.removeObject(forKey: "USERID")
                              
                                
                                DEFAULT.synchronize()
                                
                              if #available(iOS 13.0, *) {
                                SCENEDEL.loadLoginView()
                                       }
                                       else
                                       {
                                           APPDEL.loadLoginView()
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
                              self.viewProfiledata = try decoder.decode(ViewProfileModel.self, from: response!)
                           
                           if self.viewProfiledata?.code == "200"
                                  
                              {
                                  self.view.makeToast(self.viewProfiledata?.message)
                   
                              }
                              else
                              {
        
                               self.view.makeToast(self.viewProfiledata?.message)
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
