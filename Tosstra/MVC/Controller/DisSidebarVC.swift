//
//  DisSidebarVC.swift
//  Tosstra
//
//  Created by Eweb on 02/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//


import UIKit
import KYDrawerController
class DisSidebarVC: UIViewController {
    @IBOutlet var myTable:UITableView!
    @IBOutlet weak var headerUIView: UIView!
    
    @IBOutlet weak var DriverLbl: UILabel!
    var viewProfiledata:ViewProfileModel?
    
    var DisArray = ["Active Trucks","Add a new Job","Active Driver","Profile","Notification","Setting"]
    var DriverArray = ["All Jobs","My Jobs","Profile","Notification","Setting"]
    
    var DisIconArray = ["all-job","Add-icon-1","all-job","Profile","notification","setting"]
    
    var DriverIconArray = ["all-job","all-job","Profile","notification","setting"]
    
    var appType="Dispatcher"
    
    
    @IBOutlet weak var companyName: UILabel!
           @IBOutlet weak var type: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTable.delegate=self
        myTable.dataSource=self
        myTable.separatorStyle = .none
        myTable.tableHeaderView=headerUIView
        myTable.register(UINib(nibName: "DisSideTCell", bundle: nil), forCellReuseIdentifier: "DisSideTCell")
        
        
        self.appType = DEFAULT.value(forKey: "APPTYPE") as? String ?? "Dispatcher"
        
        
        if appType == "Driver"
        {
            self.DriverLbl.isHidden = false
        }
        else
        
        {
              self.DriverLbl.isHidden = true
        }
    }
    
}
extension DisSidebarVC:UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if appType == "driver"
        {
            return self.DriverArray.count
        }
        else
        {
            return self.DisArray.count
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisSideTCell") as! DisSideTCell
        let bgColorView = UIView()
        bgColorView.backgroundColor = APPCOLOL
        
        //cell.selectedBackgroundView = bgColorView
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if appType == "driver"
        {
            cell.iconImg.image = UIImage(named: self.DriverIconArray[indexPath.row])
            
            cell.titleLbl.text  = self.DriverArray[indexPath.row]
        }
        else
        {
            cell.iconImg.image = UIImage(named: self.DisIconArray[indexPath.row])
            
            cell.titleLbl.text  = self.DisArray[indexPath.row]
        }
        return cell
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if appType == "driver"
        {
            if indexPath.row == 0
            {
                let elDrawer = navigationController?.parent as? KYDrawerController
                let home = storyboard?.instantiateViewController(withIdentifier: "DriverHomeVC") as? DriverHomeVC
                let _nav = UINavigationController(rootViewController: home ?? UIViewController())
                _nav.isNavigationBarHidden = true
                elDrawer?.mainViewController = _nav
                elDrawer?.setDrawerState(.closed, animated: true)
            }
            else if indexPath.row == 1
            {
                let elDrawer = navigationController?.parent as? KYDrawerController
                let home = storyboard?.instantiateViewController(withIdentifier: "DriverMyJobVC") as? DriverMyJobVC
                let _nav = UINavigationController(rootViewController: home ?? UIViewController())
                _nav.isNavigationBarHidden = true
                elDrawer?.mainViewController = _nav
                elDrawer?.setDrawerState(.closed, animated: true)
            }
            else if indexPath.row == 2
            {
                let elDrawer = navigationController?.parent as? KYDrawerController
                let home = storyboard?.instantiateViewController(withIdentifier: "DriverProfileVC") as? DriverProfileVC
                
                
                let _nav = UINavigationController(rootViewController: home ?? UIViewController())
                _nav.isNavigationBarHidden = true
                elDrawer?.mainViewController = _nav
                elDrawer?.setDrawerState(.closed, animated: true)
            }
                else if indexPath.row == 3
                           {
                               let elDrawer = navigationController?.parent as? KYDrawerController
                               let home = storyboard?.instantiateViewController(withIdentifier: "DriverNotificationVC") as? DriverNotificationVC
                               
                               
                               let _nav = UINavigationController(rootViewController: home ?? UIViewController())
                               _nav.isNavigationBarHidden = true
                               elDrawer?.mainViewController = _nav
                               elDrawer?.setDrawerState(.closed, animated: true)
                           }
                
            else if indexPath.row == 4
            {
                let elDrawer = navigationController?.parent as? KYDrawerController
                let home = storyboard?.instantiateViewController(withIdentifier: "DriverSettingVC") as? DriverSettingVC
                
                
                let _nav = UINavigationController(rootViewController: home ?? UIViewController())
                _nav.isNavigationBarHidden = true
                elDrawer?.mainViewController = _nav
                elDrawer?.setDrawerState(.closed, animated: true)
            }
        }
        else
        {
            if indexPath.row == 0
            {
                let elDrawer = navigationController?.parent as? KYDrawerController
                let home = storyboard?.instantiateViewController(withIdentifier: "DisHomeVC") as? DisHomeVC
                
                let _nav = UINavigationController(rootViewController: home ?? UIViewController())
                _nav.isNavigationBarHidden = true
                elDrawer?.mainViewController = _nav
                elDrawer?.setDrawerState(.closed, animated: true)
            }
                
            else if indexPath.row == 1
            {
                let elDrawer = navigationController?.parent as? KYDrawerController
                let home = storyboard?.instantiateViewController(withIdentifier: "DisjobDescriptionVC") as? DisjobDescriptionVC
                
                let _nav = UINavigationController(rootViewController: home ?? UIViewController())
                _nav.isNavigationBarHidden = true
                elDrawer?.mainViewController = _nav
                elDrawer?.setDrawerState(.closed, animated: true)
            }
                
            else if indexPath.row == 2
            {
                let elDrawer = navigationController?.parent as? KYDrawerController
                let home = storyboard?.instantiateViewController(withIdentifier: "ActiveDriverVC") as? ActiveDriverVC
                
                
                let _nav = UINavigationController(rootViewController: home ?? UIViewController())
                _nav.isNavigationBarHidden = true
                elDrawer?.mainViewController = _nav
                elDrawer?.setDrawerState(.closed, animated: true)
            }
                
            else if indexPath.row == 3
            {
                let elDrawer = navigationController?.parent as? KYDrawerController
                let home = storyboard?.instantiateViewController(withIdentifier: "DisProfileVC") as? DisProfileVC
                
                
                let _nav = UINavigationController(rootViewController: home ?? UIViewController())
                _nav.isNavigationBarHidden = true
                elDrawer?.mainViewController = _nav
                elDrawer?.setDrawerState(.closed, animated: true)
            }
                
            else if indexPath.row == 5
            {
                let elDrawer = navigationController?.parent as? KYDrawerController
                let home = storyboard?.instantiateViewController(withIdentifier: "DisSettingVC") as? DisSettingVC
                
                
                let _nav = UINavigationController(rootViewController: home ?? UIViewController())
                _nav.isNavigationBarHidden = true
                elDrawer?.mainViewController = _nav
                elDrawer?.setDrawerState(.closed, animated: true)
            }
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension DisSidebarVC
{
    //MARK:- Login With Email Api
       
       func viewProfileAPI()
       {
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
      
           let params = ["userId" : id]   as [String : String]
           
           ApiHandler.ModelApiPostMethod(url: VIEW_PROFILE_API, parameters: params) { (response, error) in
               
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
                        let count = self.viewProfiledata?.data?.count ?? 0
                        if count > 0
                        {
                            var type = self.viewProfiledata?.data?[0].userType
                            
                           
                            self.companyName.text = self.viewProfiledata?.data?[0].companyName
                            self.DriverLbl.text = self.viewProfiledata?.data?[0].userType
                            
                            
                            
                                                     
                              //  hello
                                                   
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
