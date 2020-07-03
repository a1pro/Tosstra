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

      @IBOutlet var myTable:UITableView!
    
    var titleArray = ["Term & Conditions","Privacy Policy","Contact Us","Help","Delete Account","Log Out","offline/Online"]
      
      var DisIconArray = ["term&conditions","Privacy-policy","Contact-us","Help","Delete-icon","Log-out","online"]
    
    
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
        
     
                  let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTCell") as! SettingTCell
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
        
                  return cell
           
             
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 0
        {
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
