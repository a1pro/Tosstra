//
//  DisHomeVC.swift
//  Tosstra
//
//  Created by Eweb on 02/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import KYDrawerController

class DisHomeVC: UIViewController
{
  @IBOutlet var myTable:UITableView!
    
    @IBOutlet var allTruckView:UIView!
     @IBOutlet var seniorTruckView:UIView!
   
    
    var truckType="all"
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        myTable.delegate=self
               myTable.dataSource=self
               myTable.separatorStyle = .none
        myTable.register(UINib(nibName: "SeniorTrackTCell", bundle: nil), forCellReuseIdentifier: "SeniorTrackTCell")
               myTable.register(UINib(nibName: "AllTrackTableViewCell", bundle: nil), forCellReuseIdentifier: "AllTrackTableViewCell")
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    @IBAction func MenuAct(_ sender: UIButton)
        {
            let drawer = navigationController?.parent as? KYDrawerController
            drawer?.setDrawerState(.opened, animated: true)
        }

    @IBAction func allTruckAct(_ sender: UIButton)
           {
            self.truckType = "all"
            self.allTruckView.backgroundColor = APPCOLOL
            self.seniorTruckView.backgroundColor = UIColor.lightGray
            
            self.myTable.reloadData()
            
           }

    @IBAction func seniorTruckAct(_ sender: UIButton)
           {
              self.truckType = "senior"
            self.allTruckView.backgroundColor = UIColor.lightGray
                     self.seniorTruckView.backgroundColor = APPCOLOL
              self.myTable.reloadData()
           }

    
}
extension DisHomeVC:UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.truckType == "all"
        {
            return 20
        }
        else
        {
             return 10
        }
       
           
        
      
     
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       if self.truckType == "all"
              {
                  let cell = tableView.dequeueReusableCell(withIdentifier: "AllTrackTableViewCell") as! AllTrackTableViewCell
                  
                  return cell
              }
              else
              {
                  let cell = tableView.dequeueReusableCell(withIdentifier: "SeniorTrackTCell") as! SeniorTrackTCell
                   
                   return cell
              }
             
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 0
        {
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
