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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func MenuAct(_ sender: UIButton)
       {
        self.navigationController?.popViewController(animated: true)
       }
}
