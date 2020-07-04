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
     
     var titleArray = ["Term & Conditions","Privacy Policy","Contact Us","Help","Delete Account","Log Out"]
       
       var DisIconArray = ["term&conditions","Privacy-policy","Contact-us","Help","Delete-icon","Log-out"]
     
     
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
        return 60
    }
}
