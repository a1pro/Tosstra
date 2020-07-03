//
//  DisProfileVC.swift
//  Tosstra
//
//  Created by Eweb on 02/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import KYDrawerController

class DisProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func MenuAct(_ sender: UIButton)
              {
                  let drawer = navigationController?.parent as? KYDrawerController
                  drawer?.setDrawerState(.opened, animated: true)
              }

}
