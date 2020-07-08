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
    
    var viewProfiledata:ViewProfileModel?
    var apiData:ForgotPasswordModel?
    var truckType="all"
    var driverId = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        myTable.delegate=self
        myTable.dataSource=self
        myTable.separatorStyle = .none
        myTable.register(UINib(nibName: "SeniorTrackTCell", bundle: nil), forCellReuseIdentifier: "SeniorTrackTCell")
        myTable.register(UINib(nibName: "AllTrackTableViewCell", bundle: nil), forCellReuseIdentifier: "AllTrackTableViewCell")
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.get_All_DriversAPI()
        }
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
        
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.get_All_DriversAPI()
        }
        
    }
    
    @IBAction func seniorTruckAct(_ sender: UIButton)
    {
        self.truckType = "senior"
        self.allTruckView.backgroundColor = UIColor.lightGray
        self.seniorTruckView.backgroundColor = APPCOLOL
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.get_Only_FavDriversAPI()
        }
    }
    
    
}
extension DisHomeVC:UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.truckType == "all"
        {
            return self.viewProfiledata?.data?.count ?? 0
        }
        else
        {
            return self.viewProfiledata?.data?.count ?? 0
        }
        
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        
        
        if self.truckType == "all"
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllTrackTableViewCell") as! AllTrackTableViewCell
            // cell.selectedBackgroundView = bgColorView
            
            let celldData =  self.viewProfiledata?.data?.reversed()[indexPath.row]
            
            cell.userName.text = (celldData?.firstName ?? "") + " " + (celldData?.lastName ?? "")
            
            cell.trsportName.text = celldData?.companyName
            
            cell.checkBtn.tag = indexPath.row
            // cell.f.addTarget(self, action: #selector(AllTrackcheckAct), for: UIControl.Event.touchUpInside)
            
            cell.checkBtn.tag = indexPath.row
            cell.checkBtn.addTarget(self, action: #selector(AllTrackcheckAct), for: UIControl.Event.touchUpInside)
            cell.favBtn.tag = indexPath.row
            cell.favBtn.addTarget(self, action: #selector(UnfavBtnAct), for: UIControl.Event.touchUpInside)
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SeniorTrackTCell") as! SeniorTrackTCell
            let celldData =  self.viewProfiledata?.data?.reversed()[indexPath.row]
            
            cell.userName.text = (celldData?.firstName ?? "") + " " + (celldData?.lastName ?? "")
            
            cell.trsportName.text = celldData?.companyName
            
            cell.checkBtn.tag = indexPath.row
            cell.checkBtn.addTarget(self, action: #selector(SeniorTrackcheckAct), for: UIControl.Event.touchUpInside)
            cell.favBtn.tag = indexPath.row
            cell.favBtn.addTarget(self, action: #selector(UnfavBtnAct), for: UIControl.Event.touchUpInside)
            
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
    
    
    
    @objc func UnfavBtnAct(_ sender:UIButton)
    {
        let celldData =  self.viewProfiledata?.data?.reversed()[sender.tag]
        
        
        self.driverId = celldData?.id ?? ""
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.driver_Favorite_UnfavoriteAPI()
        }
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
extension DisHomeVC
{
    //MARK:- get-All-Drivers Api
    
    func get_All_DriversAPI()
    {
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        
        let params = ["userId" : id]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: GET_ALL_DRIVER_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.viewProfiledata = try decoder.decode(ViewProfileModel.self, from: response!)
                    
                    self.myTable.reloadData()
                    
                    
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
    //MARK:- get-All-Drivers Api
    
    func get_Only_FavDriversAPI()
    {
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        
        let params = ["userId" : id]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: GET_FAV_DRIVER_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.viewProfiledata = try decoder.decode(ViewProfileModel.self, from: response!)
                    
                    self.myTable.reloadData()
                    
                    
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
    
    
    //MARK:- driver-Favorite-Unfavorite Api
    
    func driver_Favorite_UnfavoriteAPI()
    {
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        
        let params = ["userId" : id,
                      "driverId" : self.driverId]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: driver_Favorite_Unfavorite_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.apiData = try decoder.decode(ForgotPasswordModel.self, from: response!)
                    
                    self.myTable.reloadData()
                    
                    
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
