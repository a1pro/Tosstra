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
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate=self
                                    myTable.dataSource=self
                                    myTable.separatorStyle = .none
                             myTable.register(UINib(nibName: "DriverNotiCell", bundle: nil), forCellReuseIdentifier: "DriverNotiCell")
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
      
        return 10
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
     let bgColorView = UIView()
    bgColorView.backgroundColor = UIColor.clear
                 
    
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "DriverNotiCell") as! DriverNotiCell
        //cell.selectedBackgroundView = bgColorView
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
       
        
        
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
        return 80
    }
}
