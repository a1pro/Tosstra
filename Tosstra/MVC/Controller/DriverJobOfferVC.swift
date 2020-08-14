//
//  DriverJobOfferVC.swift
//  Tosstra
//
//  Created by Eweb on 07/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit

class DriverJobOfferVC: UIViewController {
    
    @IBOutlet var addInfoText:UITextView!
    
    @IBOutlet weak var companyName: UILabel!
    
    @IBOutlet weak var rateLbl: UILabel!
    
    @IBOutlet weak var amountTxt: UITextField!
    @IBOutlet weak var p_stresttxt: UITextView!
    // @IBOutlet weak var p_stateTxt: UITextField!
    
    //@IBOutlet weak var p_zipTxt: UITextField!
    // @IBOutlet weak var p_cityTxt: UITextField!
    
    @IBOutlet weak var d_stresttxt: UITextView!
    
    //@IBOutlet weak var d_stateTxt: UITextField!
    
    //@IBOutlet weak var d_zipTxt: UITextField!
    //@IBOutlet weak var d_cityTxt: UITextField!
    
    @IBOutlet weak var stsrt_FromTxt: UITextField!
    
    @IBOutlet weak var endTimeTxt: UITextField!
    @IBOutlet weak var date_fromTxt: UITextField!
    
    @IBOutlet weak var date_totxt: UITextField!
    
    @IBOutlet weak var buttonStack: UIStackView!
    var status = "1"
    
    
    
    var apiData:ForgotPasswordModel?
    var JobDetailData:JobDetailMedel?
    
    
    var dict = NSDictionary()
    
    var jobId = ""
    var dispatcherId = ""
    var jobStatus = "1"
    
    
    var fromNoti = "no"
    
    @IBOutlet weak var locView: UIView!
    @IBOutlet weak var locationLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addInfoText.layer.borderColor = UIColor.lightGray.cgColor
        self.addInfoText.layer.borderWidth = 1
        
        if fromNoti == "yes"
        {
            //self.dispatcherId = dict.value(forKey: "dispatcherId") as? String ?? ""
            //self.jobId = dict.value(forKey: "jobId") as? String ?? ""
            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
            {
                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
            }
            else
            {
                self.JobDetalsAPI()
            }
            
        }
        else
        {
            
            
            
            self.companyName.text = dict.value(forKey: "companyName") as? String ?? ""
            
            
            
            self.amountTxt.isUserInteractionEnabled = false
            
            
            
            let rate = dict.value(forKey: "rateType") as? String ?? ""
            
            if rate == "perHours"
            {
                self.amountTxt.text  = "$ " + (dict.value(forKey: "rate") as? String ?? "") + " " + ("per Hours")
            }
            else
            {
                self.amountTxt.text  = "$ " + (dict.value(forKey: "rate") as? String ?? "") + " " + ("per Load")
            }
            
            
            self.stsrt_FromTxt.text = dict.value(forKey: "startTime") as? String ?? ""
            
            self.endTimeTxt.text = dict.value(forKey: "endTime") as? String ?? ""
            self.date_fromTxt.text = dict.value(forKey: "dateFrom") as? String ?? ""
            self.date_totxt.text = dict.value(forKey: "dateTo") as? String ?? ""
            
            //self.p_zipTxt.text = (dict.value(forKey: "pupZipcode") as? String ?? "" )
            //  self.p_cityTxt.text = dict.value(forKey: "pupCity") as? String ?? ""
            //self.p_stateTxt.text = dict.value(forKey: "pupState") as? String ?? ""
            self.p_stresttxt.text = dict.value(forKey: "pupStreet") as? String ?? ""
            
            //self.d_zipTxt.text = (dict.value(forKey: "drpZipcode") as? String ?? "" )
            //self.d_cityTxt.text = dict.value(forKey: "drpCity") as? String ?? ""
            //self.d_stateTxt.text = dict.value(forKey: "drpState") as? String ?? ""
            self.d_stresttxt.text = dict.value(forKey: "drpStreet") as? String ?? ""
            self.addInfoText.text = dict.value(forKey: "additinal_Instructions") as? String ?? ""
            
            self.jobId = dict.value(forKey: "jobId") as? String ?? ""
            self.dispatcherId = dict.value(forKey: "dispatcherId") as? String ?? ""
            
            
            
        }
        
    }
    
    @IBAction func MenuAct(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func acceptRejAct(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            self.jobStatus = "0"
        }
        else
        {
            self.jobStatus = "1"
        }
        
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.accept_rejectAPI()
        }
        
    }
    //MARK:- accept reject Api
    
    func accept_rejectAPI()
    {
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        
        let params = ["driverId" : id,
                      "jobId" : self.jobId,
                      "dispatcherId" : self.dispatcherId,
                      "jobStatus" : self.jobStatus]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: ACEEPT_REJECT_JOB_API, parameters: params) { (response, error) in
            
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
                            let dict = self.JobDetailData?.data?[0]
                            self.companyName.text = dict?.companyName
                            self.amountTxt.isUserInteractionEnabled = false
                            
                            let driverId = dict?.jobStatus ?? ""
                            
                            if driverId == "1"
                            {
                                self.buttonStack.isHidden = true
                                self.locView.isHidden = false
                                
                            }
                            else
                            {
                                self.buttonStack.isHidden = false
                                self.locView.isHidden = true
                            }
                            let rate = dict?.rateType ?? ""
                            
                            if rate == "perHours"
                            {
                                self.amountTxt.text  = "$ " + (dict?.rate ?? "") + " " + ("per Hours")
                            }
                            else
                            {
                                
                                
                                self.amountTxt.text  = "$ " + (dict?.rate ?? "") + " " + ("per Load")
                            }
                            
                            self.stsrt_FromTxt.text = dict?.startTime ?? ""
                            //
                            self.endTimeTxt.text = dict?.endTime ?? ""
                            self.date_fromTxt.text = dict?.dateFrom ?? ""
                            self.date_totxt.text =  dict?.dateTo ?? ""
                            //
                            //self.p_zipTxt.text = dict?.pupZipcode ?? ""
                            
                            //self.p_cityTxt.text = dict?.pupCity ?? ""
                            // self.p_stateTxt.text = dict?.pupState ?? ""
                            self.p_stresttxt.text = dict?.pupStreet ?? ""
                            
                            //   self.d_zipTxt.text = dict?.drpZipcode ?? ""
                            //self.d_cityTxt.text = dict?.drpCity ?? ""
                            //self.d_stateTxt.text = dict?.drpState ?? ""
                            self.d_stresttxt.text = dict?.drpStreet ?? ""
                            self.addInfoText.text = dict?.additinalInstructions ?? ""
                            
                            self.locationLbl.text = dict?.address ?? ""
          
                            
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
