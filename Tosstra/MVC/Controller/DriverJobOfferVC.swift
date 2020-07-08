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
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addInfoText.layer.borderColor = UIColor.lightGray.cgColor
              self.addInfoText.layer.borderWidth = 1
             
              
              
    }
    
    @IBAction func MenuAct(_ sender: UIButton)
        {
            self.navigationController?.popViewController(animated: true)
        }


}
