//
//  UserTypeViewController.swift
//  Tosstra
//
//  Created by Eweb on 02/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit

class UserTypeViewController: UIViewController {

    var loginsignUp = ""
    var Apptype = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBackBtn(_ sender: Any)
             {
                 
                
                self.navigationController?.popViewController(animated: true)
             }
    
    @IBAction func DriverBtn(_ sender: Any)
          {
              
            
            if self.loginsignUp == "signin"
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DisSigninVC") as! DisSigninVC
                vc.Apptype = "driver"
                    self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverSignupVC") as! DriverSignupVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
              
          }
       @IBAction func dispatcherBtn(_ sender: Any)
             {
                 if self.loginsignUp == "signin"
                            {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DisSigninVC") as! DisSigninVC
                                vc.Apptype = "dispatcher"
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else
                            {
                                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "DisSignupVC") as! DisSignupVC
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
               
             }

}
