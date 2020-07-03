//
//  StartedViewController.swift
//  Tosstra
//
//  Created by Eweb on 02/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit

class StartedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

     @IBAction func signupBtn(_ sender: Any)
       {
           
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserTypeViewController") as! UserTypeViewController
           vc.loginsignUp = "signup"
           self.navigationController?.pushViewController(vc, animated: true)
       }
    @IBAction func loginBtn(_ sender: Any)
          {
              
              let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserTypeViewController") as! UserTypeViewController
              vc.loginsignUp = "signin"
              self.navigationController?.pushViewController(vc, animated: true)
          }
}
