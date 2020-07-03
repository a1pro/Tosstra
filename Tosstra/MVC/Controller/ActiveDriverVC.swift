//
//  ActiveDriverVC.swift
//  Tosstra
//
//  Created by Eweb on 02/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import KYDrawerController

class ActiveDriverVC: UIViewController {

    @IBOutlet var myTable:UITableView!
      
      @IBOutlet var listLineView:UIView!
       @IBOutlet var mapLineView:UIView!
     @IBOutlet var listView:UIView!
     @IBOutlet var mapView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate=self
                      myTable.dataSource=self
                      myTable.separatorStyle = .none
               myTable.register(UINib(nibName: "ActiveDriverTCell", bundle: nil), forCellReuseIdentifier: "ActiveDriverTCell")
        
        self.mapView.isHidden = true
        self.listView.isHidden = false
    }
    
    @IBAction func MenuAct(_ sender: UIButton)
           {
               let drawer = navigationController?.parent as? KYDrawerController
               drawer?.setDrawerState(.opened, animated: true)
           }

       @IBAction func listViewAct(_ sender: UIButton)
              {
               //self.truckType = "all"
               self.listLineView.backgroundColor = APPCOLOL
               self.mapLineView.backgroundColor = UIColor.lightGray
               self.mapView.isHidden = true
               self.listView.isHidden = false
               self.myTable.reloadData()
               
              }

       @IBAction func mapViewAct(_ sender: UIButton)
              {
              self.mapView.isHidden = false
              self.listView.isHidden = true
               self.listLineView.backgroundColor = UIColor.lightGray
                        self.mapLineView.backgroundColor = APPCOLOL
                 self.myTable.reloadData()
              }

}
extension ActiveDriverVC:UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      
             return 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
     
                  let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveDriverTCell") as! ActiveDriverTCell
                  
                  return cell
           
             
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 0
        {
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
