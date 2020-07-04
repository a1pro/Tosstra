//
//  DriverProfileVC.swift
//  Tosstra
//
//  Created by Eweb on 04/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import KYDrawerController

class DriverProfileVC: UIViewController {

    var fromSideBar = "yes"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func MenuAct(_ sender: UIButton)
    {
        if fromSideBar == "yes"
        {
            let drawer = navigationController?.parent as? KYDrawerController
                   drawer?.setDrawerState(.opened, animated: true)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
       
    }
}
