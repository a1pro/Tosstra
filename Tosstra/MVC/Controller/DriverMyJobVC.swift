//
//  DriverMyJobVC.swift
//  Tosstra
//
//  Created by Eweb on 04/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import KYDrawerController

class DriverMyJobVC: UIViewController {
    
    @IBOutlet var myTable:UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate=self
                                    myTable.dataSource=self
                                    myTable.separatorStyle = .none
                             myTable.register(UINib(nibName: "DriveMyJobCell", bundle: nil), forCellReuseIdentifier: "DriveMyJobCell")
        
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
      
        return 10
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
     let bgColorView = UIView()
    bgColorView.backgroundColor = UIColor.clear
                 
    
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "DriveMyJobCell") as! DriveMyJobCell
      
        
return cell
           
             
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
       let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverJobDetailVC") as! DriverJobDetailVC
        
              
    self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
