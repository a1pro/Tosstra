//
//  DriverJobDetailVC.swift
//  Tosstra
//
//  Created by Eweb on 04/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit

class DriverJobDetailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backAct(_ sender: UIButton)
    {
     self.navigationController?.popViewController(animated: true)
    }
}
