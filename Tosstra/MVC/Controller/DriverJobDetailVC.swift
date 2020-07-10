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
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.companyName.text = self.jobData?.companyName ?? ""
        self.emailTxt.text = self.jobData?.email ?? ""
        self.locationTxt.text = self.jobData?.address ?? ""
        
        self.stsrt_FromTxt.text = self.jobData?.startTime ?? ""
        self.endTimeTxt.text = self.jobData?.endTime ?? ""
        self.date_fromTxt.text = self.jobData?.dateFrom ?? ""
        self.date_totxt.text = self.jobData?.dateTo ?? ""
        
         self.nameTxt.text = (self.jobData?.firstName ?? "") + " " + (self.jobData?.lastName ?? "")
        
        let d_add = (self.jobData?.drpStreet ?? "") + " " + (self.jobData?.drpCity ?? "")
        
        let d =  (self.jobData?.drpState ?? "") + " " + (self.jobData?.drpZipcode ?? "")
        
       self.dropOffAddress.text = d_add + " " + d
        
        let p_add = (self.jobData?.pupStreet ?? "") + " " + (self.jobData?.pupCity ?? "")
            
           let p = (self.jobData?.pupState ?? "") + " " + (self.jobData?.pupZipcode ?? "")
               
               
        self.pickupAddress.text = p_add + " " + p
        
        self.jobId = (self.jobData?.jobId ?? "")
        
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
                           
                           NetworkEngine.commonAlert(message: self.apiData?.message ?? "", vc: self)
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

}
