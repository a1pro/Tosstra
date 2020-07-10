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
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func MenuAct(_ sender: UIButton)
       {
        self.navigationController?.popViewController(animated: true)
       }
}
