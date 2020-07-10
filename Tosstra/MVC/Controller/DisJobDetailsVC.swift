//
//  DisJobDetailsVC.swift
//  Tosstra
//
//  Created by Eweb on 03/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import KYDrawerController
class DisJobDetailsVC: UIViewController {

    var dict = NSDictionary()
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
    var jobId = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.companyName.text = dict.value(forKey: "companyName") as? String ?? ""
             self.emailTxt.text = dict.value(forKey: "email") as? String ?? ""
             self.locationTxt.text = dict.value(forKey: "address") as? String ?? ""
             
             self.stsrt_FromTxt.text = dict.value(forKey: "startTime") as? String ?? ""
        
             self.endTimeTxt.text = dict.value(forKey: "endTime") as? String ?? ""
        
             self.date_fromTxt.text = dict.value(forKey: "dateFrom") as? String ?? ""
        
             self.date_totxt.text = dict.value(forKey: "dateTo") as? String ?? ""
             
              self.nameTxt.text = (dict.value(forKey: "firstName") as? String ?? "") + " " + (dict.value(forKey: "lastName") as? String ?? "")
             
             let d_add = (dict.value(forKey: "drpStreet") as? String ?? "") + " " + (dict.value(forKey: "drpCity") as? String ?? "")
             
             let d =  (dict.value(forKey: "drpState") as? String ?? "") + " " + (dict.value(forKey: "drpZipcode") as? String ?? "")
             
            self.dropOffAddress.text = d_add + " " + d
             
             let p_add = (dict.value(forKey: "pupStreet") as? String ?? "") + " " + (dict.value(forKey: "pupCity") as? String ?? "")
                 
                let p = (dict.value(forKey: "pupState") as? String ?? "") + " " + (dict.value(forKey: "pupZipcode") as? String ?? "")
                    
                    
             self.pickupAddress.text = p_add + " " + p
             
             self.jobId = (dict.value(forKey: "jobId") as? String ?? "")
        
    }
    

    @IBAction func MenuAct(_ sender: UIButton)
       {
        self.navigationController?.popViewController(animated: true)
       }
    
    @IBAction func endJobAct(_ sender: UIButton)
          {
           self.navigationController?.popViewController(animated: true)
          }
}
