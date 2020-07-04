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
        cell.startBtn.tag = indexPath.row
                     cell.startBtn.addTarget(self, action: #selector(startBtnAct), for: UIControl.Event.touchUpInside)
        
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
    
    @objc func startBtnAct(_ sender:UIButton)
    {
        let indexPath = IndexPath(row: sender.tag, section: 0)
                      let cell = self.myTable.cellForRow(at: indexPath) as! DriveMyJobCell

        if sender.backgroundColor == UIColor.white
                               {
                                sender.backgroundColor = APPCOLOL
                                cell.startBtn.setTitle("Started", for: .normal)
                                cell.startBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
                            
                               }
                               else
                               {
                                 cell.startBtn.setTitle("Start", for: .normal)
                                  sender.backgroundColor = UIColor.white
                                cell.startBtn.setTitleColor(APPCOLOL, for: UIControl.State.normal)
                                  
                               }
    }
}
