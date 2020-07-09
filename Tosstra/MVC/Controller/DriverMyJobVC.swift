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
    
    var jobData:JobModel?
    var apiData:ForgotPasswordModel?
    private let refreshControl = UIRefreshControl()
    
    var jobId = ""
    
    @IBOutlet var noDataLbl:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate=self
        myTable.dataSource=self
        myTable.separatorStyle = .none
        myTable.register(UINib(nibName: "DriveMyJobCell", bundle: nil), forCellReuseIdentifier: "DriveMyJobCell")
        if #available(iOS 10.0, *) {
            self.myTable.refreshControl = refreshControl
        } else {
            self.myTable.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            DispatchQueue.main.async {
                
                
                self.MYJobAPI()
            }
            
        }
        
    }
    @objc private func refreshData(_ sender: Any)
    {
        
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            DispatchQueue.main.async {
                
                
                self.MYJobAPI()
            }
            
        }
        
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
        
        return self.jobData?.data?.count ?? 0
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriveMyJobCell") as! DriveMyJobCell
        
        let celldData =  self.jobData?.data?.reversed()[indexPath.row]
        
        
        cell.companyNameLbl.text = celldData?.companyName
        
        cell.userNaleLb.text = (celldData?.firstName ?? " ") + " " + (celldData?.lastName ?? " ")
        
        cell.startBtn.tag = indexPath.row
        cell.startBtn.addTarget(self, action: #selector(startBtnAct), for: UIControl.Event.touchUpInside)
        
        if let status = celldData?.workStartStatus
        {
            if status == "1"
            {
                cell.startBtn.backgroundColor = APPCOLOL
                cell.startBtn.setTitle("Started", for: .normal)
                cell.startBtn.setTitleColor(UIColor.white, for: .normal)
                
                
            }
            else
            {
                cell.startBtn.backgroundColor = UIColor.white
                cell.startBtn.setTitle("Start", for: .normal)
                cell.startBtn.setTitleColor(APPCOLOL, for: .normal)
                
            }
        }
        else
        {
            cell.startBtn.backgroundColor = UIColor.white
            cell.startBtn.setTitle("Start", for: .normal)
            cell.startBtn.setTitleColor(APPCOLOL, for: .normal)
        }
        
        
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    @objc func startBtnAct(_ sender:UIButton)
    {
        let celldData =  self.jobData?.data?.reversed()[sender.tag]
        
        
        self.jobId = celldData?.jobId ?? ""
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.myTable.cellForRow(at: indexPath) as! DriveMyJobCell
        
        let text =  cell.startBtn.titleLabel?.text ?? ""
        
        if text == "Started"
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverJobDetailVC") as! DriverJobDetailVC
            vc.jobData = celldData
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to start this job?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                        print("Handle Cancel Logic here")
                    }))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
               if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                {
                    NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                }
                else
                {
                   if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                            {
                                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                            }
                            else
                            {
                                
                                
                                
                                self.JoBStartAPI()
                                
                                
                            }
                }
               
                
            }))
        
            present(alert, animated: true, completion: nil)
          
        }
        
        
        
        
    }
}

extension DriverMyJobVC
{
    //MARK:- MYJobAPI Api
    
    func MYJobAPI()
    {
        
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        
        let params = ["userId" : id]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: GET_MY_JOB_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                self.refreshControl.endRefreshing()
                let decoder = JSONDecoder()
                do
                {
                    self.jobData = try decoder.decode(JobModel.self, from: response!)
                    
                    if self.jobData?.data?.count ?? 0 > 0
                                       {
                                           self.noDataLbl.isHidden = true
                                       }
                                       else
                                       {
                                          self.noDataLbl.isHidden = false
                                       }
                    self.myTable.reloadData()
                    
                    
                }
                catch let error
                {
                    self.view.makeToast(error.localizedDescription)
                }
                
            }
            else
            {
                self.refreshControl.endRefreshing()
                self.view.makeToast(error)
            }
        }
    }
    
    //MARK:- JoBStartAPI Api
    
    func JoBStartAPI()
    {
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        
        let params = ["userId" : id,
                      "jobId" : self.jobId]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: START_JOB_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.apiData = try decoder.decode(ForgotPasswordModel.self, from: response!)
                    
                    self.myTable.reloadData()
                    
                    self.MYJobAPI()
                    
                    
                    
                    
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
