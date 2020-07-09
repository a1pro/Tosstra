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
        
        
        
    }
    @IBAction func backAct(_ sender: UIButton)
    {
     self.navigationController?.popViewController(animated: true)
    }
}
