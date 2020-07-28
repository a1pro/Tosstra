//
//  DriverSettingVC.swift
//  Tosstra
//
//  Created by Eweb on 04/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import KYDrawerController
class DriverSettingVC: UIViewController {
    
    @IBOutlet var myTable:UITableView!
    var viewProfiledata:ViewProfileModel?
    var titleArray = ["Term & Conditions","Privacy Policy","Contact Us","Help","Change Password","Delete Account","Log Out"]
    
    var DisIconArray = ["term&conditions","Privacy-policy","Contact-us","Help","Privacy-policy","Delete-icon","Log-out"]
    
    
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
extension DriverSettingVC:UITableViewDelegate,UITableViewDataSource
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
        
        
        cell.offOnSwicth.isHidden = true
        
        
        return cell
        
        
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
      
        if indexPath.row == 0
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "StatticVC") as! StatticVC
            vc.url = Terms_and_Conditions
               vc.pageTitle = "Term of Services"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 1
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "StatticVC") as! StatticVC
            vc.url = Privacy
            vc.pageTitle = "Privacy Policy"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 2
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "StatticVC") as! StatticVC
            vc.url = CONTACTUS
            vc.pageTitle = "Contact us"
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if indexPath.row == 3
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "StatticVC") as! StatticVC
            vc.url = HELP
            vc.pageTitle = "Help"
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
}
extension DriverSettingVC
{
    //MARK:- Logout Api
    
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
                       
                        NetworkEngine.showToast(controller: self, message: self.viewProfiledata?.message)
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
                    
                      NetworkEngine.showToast(controller: self, message: self.viewProfiledata?.message)

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
    
}
