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
    
    @IBAction func plusAct(_ sender: UIButton)
          {
             let vc = self.storyboard?.instantiateViewController(withIdentifier: "DisjobDescriptionVC") as! DisjobDescriptionVC
              self.navigationController?.pushViewController(vc, animated: true)
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
      
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
               
             
       if self.truckType == "all"
              {
                  let cell = tableView.dequeueReusableCell(withIdentifier: "AllTrackTableViewCell") as! AllTrackTableViewCell
                   // cell.selectedBackgroundView = bgColorView
                cell.checkBtn.tag = indexPath.row
                cell.checkBtn.addTarget(self, action: #selector(AllTrackcheckAct), for: UIControl.Event.touchUpInside)
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                  return cell
              }
              else
              {
                  let cell = tableView.dequeueReusableCell(withIdentifier: "SeniorTrackTCell") as! SeniorTrackTCell
                cell.checkBtn.tag = indexPath.row
                cell.checkBtn.addTarget(self, action: #selector(SeniorTrackcheckAct), for: UIControl.Event.touchUpInside)
                    // cell.selectedBackgroundView = bgColorView
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
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
    
    
    @objc func AllTrackcheckAct(_ sender:UIButton)
    {
        let indexPath = IndexPath(row: sender.tag, section: 0)
                      let cell = self.myTable.cellForRow(at: indexPath) as! AllTrackTableViewCell

                               if sender.image(for: .normal) == UIImage(named: "check-box")
                               {
                                   sender.setImage(#imageLiteral(resourceName: "check-box-1"), for: .normal)
                            
                               }
                               else
                               {
                                   sender.setImage(#imageLiteral(resourceName: "check-box"), for: .normal)
                               
                                  
                               }
    }
    
    @objc func SeniorTrackcheckAct(_ sender:UIButton)
       {
           let indexPath = IndexPath(row: sender.tag, section: 0)
                         let cell = self.myTable.cellForRow(at: indexPath) as! SeniorTrackTCell

                                  if sender.image(for: .normal) == UIImage(named: "check-box")
                                  {
                                      sender.setImage(#imageLiteral(resourceName: "check-box-1"), for: .normal)
                               
                                  }
                                  else
                                  {
                                      sender.setImage(#imageLiteral(resourceName: "check-box"), for: .normal)
                                  
                                     
                                  }
       }
}
