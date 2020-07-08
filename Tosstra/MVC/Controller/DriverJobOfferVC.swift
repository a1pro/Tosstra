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
        @IBOutlet weak var p_stresttxt: UITextField!
        @IBOutlet weak var p_stateTxt: UITextField!
        
        @IBOutlet weak var p_zipTxt: UITextField!
        @IBOutlet weak var p_cityTxt: UITextField!
        
        @IBOutlet weak var d_stresttxt: UITextField!
        @IBOutlet weak var d_stateTxt: UITextField!
        
        @IBOutlet weak var d_zipTxt: UITextField!
        @IBOutlet weak var d_cityTxt: UITextField!
        
        @IBOutlet weak var stsrt_FromTxt: UITextField!
        
        @IBOutlet weak var endTimeTxt: UITextField!
        @IBOutlet weak var date_fromTxt: UITextField!
        
        @IBOutlet weak var date_totxt: UITextField!
    
    @IBOutlet weak var buttonStack: UIStackView!
    var status = "1"
    
    var apiData:ForgotPasswordModel?
    
    var dict = NSDictionary()
    
    var jobId = ""
     var dispatcherId = ""
     var jobStatus = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addInfoText.layer.borderColor = UIColor.lightGray.cgColor
        self.addInfoText.layer.borderWidth = 1
             
        self.companyName.text = dict.value(forKey: "companyName") as? String ?? ""
        
      let amount = (dict.value(forKey: "rate") as? String ?? "") + " " + (dict.value(forKey: "rateType") as? String ?? "")
        self.amountTxt.isUserInteractionEnabled = false
        
        
        self.amountTxt.text = "$ " + amount
        
        self.stsrt_FromTxt.text = dict.value(forKey: "startTime") as? String ?? ""
        
        self.endTimeTxt.text = dict.value(forKey: "endTime") as? String ?? ""
        self.date_fromTxt.text = dict.value(forKey: "dateFrom") as? String ?? ""
    self.date_totxt.text = dict.value(forKey: "dateTo") as? String ?? ""
        
        self.p_zipTxt.text = (dict.value(forKey: "pupZipcode") as? String ?? "" )
        self.p_cityTxt.text = dict.value(forKey: "pupCity") as? String ?? ""
    self.p_stateTxt.text = dict.value(forKey: "pupState") as? String ?? ""
        self.p_stresttxt.text = dict.value(forKey: "pupStreet") as? String ?? ""
        
        self.d_zipTxt.text = (dict.value(forKey: "drpZipcode") as? String ?? "" )
               self.d_cityTxt.text = dict.value(forKey: "drpCity") as? String ?? ""
           self.d_stateTxt.text = dict.value(forKey: "drpState") as? String ?? ""
               self.d_stresttxt.text = dict.value(forKey: "drpStreet") as? String ?? ""
          self.addInfoText.text = dict.value(forKey: "additinal_Instructions") as? String ?? ""
        
        self.jobId = dict.value(forKey: "jobId") as? String ?? ""
        self.dispatcherId = dict.value(forKey: "dispatcherId") as? String ?? ""
        
        
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
