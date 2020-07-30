//
//  DriverJobDetailVC.swift
//  Tosstra
//
//  Created by Eweb on 04/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit

class DriverJobDetailVC: UIViewController {

    @IBOutlet var addInfoText:UITextView!
      
       @IBOutlet weak var companyName: UILabel!
    
    @IBOutlet weak var pickupAddress: UILabel!
    @IBOutlet weak var dropOffAddress: UILabel!
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var locationTxt: UITextField!
    
           @IBOutlet weak var stsrt_FromTxt: UITextField!
           
           @IBOutlet weak var endTimeTxt: UITextField!
           @IBOutlet weak var date_fromTxt: UITextField!
           
           @IBOutlet weak var date_totxt: UITextField!
    
    var jobData:JobDatum?
    
    var status = "1"
       
       var apiData:ForgotPasswordModel?
       
       var dict = NSDictionary()
       
       var jobId = ""
        var dispatcherId = ""
        var jobStatus = "1"
    
    var sourceLat = "30.7041"
     var sourceLong = "76.1025"
     var destinationLat = "28.7041"
    var destinationLong = "77.1025"
    var sourceAdd = ""
         var destinationAdd = ""
    
    var JobDetailData:JobDetailMedel?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                  {
                      NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                  }
                  else
                  {
                      self.JobDetalsAPI()
                  }
                   
        
        print(self.jobData)
       
        
        
        
    }
    @IBAction func seeDirection(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TrackLoactionVC") as! TrackLoactionVC
        vc.sourceLat=self.sourceLat
        vc.sourceLong=self.sourceLong
        vc.sourceAdd=self.sourceAdd
        vc.destinationLat=self.destinationLat
        vc.destinationLong=self.destinationLong
        vc.destinationAdd=self.destinationAdd
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func backAct(_ sender: UIButton)
    {
     self.navigationController?.popViewController(animated: true)
    }
    @IBAction func completeBtnAct(_ sender: UIButton)
      {
       
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to mark complete for this job?", preferredStyle: UIAlertController.Style.alert)
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
                                     
                                     
                                     
                                     self.completeJobAPI()
                                     
                                     
                                 }
                     }
                    
                     
                 }))
             
                 present(alert, animated: true, completion: nil)
      }
      
    
    
    //MARK:- completeJobAPI
       
       func completeJobAPI()
       {
           var id = ""
                  if let userID = DEFAULT.value(forKey: "USERID") as? String
                  {
                      id = userID
                  }
           
           let params = ["userId" : id,
                         "jobId" : self.jobId]   as [String : String]
           
           ApiHandler.ModelApiPostMethod(url: DRIVER_COPLETE_API, parameters: params) { (response, error) in
               
               if error == nil
               {
                   let decoder = JSONDecoder()
                   do
                   {
                       self.apiData = try decoder.decode(ForgotPasswordModel.self, from: response!)
                       
                       if self.apiData?.code == "200"
                           
                       {
                           
                          
                        NetworkEngine.showToast(controller: self, message: self.apiData?.message ?? "")

                       }
                       else
                       {
                           self.view.makeToast(self.apiData?.message)
                           
                           DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                                if #available(iOS 13.0, *)
                                                                  {
                                                                      SCENEDEL.loadDriverHomeView()
                                                                      
                                                                  }
                                                                  else
                                                                  {
                                                                      APPDEL.loadDriverHomeView()
                                                                  }
                           })
                           
                           
                       }
                       
                       
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
      //MARK:- accept reject Api
        
        func JobDetalsAPI()
        {
            var id = "1"
            if let userID = DEFAULT.value(forKey: "USERID") as? String
            {
                id = userID
            }
            
            let params = ["jobId" : self.jobId,
                          "driverId" : id,
                          "dispatcherId" : self.dispatcherId]   as [String : String]
            
            ApiHandler.ModelApiPostMethod(url: JOB_DETAILS_API, parameters: params) { (response, error) in
                
                if error == nil
                {
                    let decoder = JSONDecoder()
                    do
                    {
                        self.JobDetailData = try decoder.decode(JobDetailMedel.self, from: response!)
                        
                        if self.JobDetailData?.code == "200"
                            
                        {
                            NetworkEngine.showToast(controller: self, message: self.JobDetailData?.message ?? "")

                        }
                        else
                        {
                            self.view.makeToast(self.JobDetailData?.message)
                            if self.JobDetailData?.data?.count ?? 0 > 0
                            {
                                var jobData = self.JobDetailData?.data?[0]
                                
                              
                              self.companyName.text = jobData?.companyName ?? ""
                                     self.emailTxt.text = jobData?.email ?? ""
                                     self.locationTxt.text = jobData?.phone ?? ""
                                     
                                     self.stsrt_FromTxt.text = jobData?.startTime ?? ""
                                     self.endTimeTxt.text = jobData?.endTime ?? ""
                                     self.date_fromTxt.text = jobData?.dateFrom ?? ""
                                     self.date_totxt.text = jobData?.dateTo ?? ""
                                     
//                                self.sourceLat = jobData?.p ?? ""
//                                     self.sourceLong = jobData?.puplongitude ?? ""
//
                                 
                                     
                                     self.destinationLat = jobData?.drplatitude ?? ""
                                     self.destinationLong = jobData?.drplongitude ?? ""
                                     
                                     
                                      self.nameTxt.text = (jobData?.firstName ?? "") + " " + (jobData?.lastName ?? "")
                                     
                                     let d_add = (jobData?.drpStreet ?? "") + " " + (jobData?.drpCity ?? "")
                                     
                                     let d =  (jobData?.drpState ?? "") + " " + (self.jobData?.drpZipcode ?? "")
                                     
                                    self.dropOffAddress.text = d_add + " " + d
                                     
                                     let p_add = (jobData?.pupStreet ?? "") + " " + (jobData?.pupCity ?? "")
                                         
                                        let p = (jobData?.pupState ?? "") + " " + (jobData?.pupZipcode ?? "")
                                            
                                            
                                     self.pickupAddress.text = p_add + " " + p
                                     
                                     self.sourceAdd = self.pickupAddress.text!
                                     
                                      self.destinationAdd = self.dropOffAddress.text!
                                     
                                     self.jobId = (jobData?.jobId ?? "")
                                
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                        
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
