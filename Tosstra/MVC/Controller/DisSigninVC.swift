//
//  DisSigninVC.swift
//  Tosstra
//
//  Created by Eweb on 02/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit

class DisSigninVC: UIViewController {
    
    @IBOutlet var signInBtn:UIButton!
    
    @IBOutlet var userNameTxt:UITextField!
    
    @IBOutlet var passwordTxt:UITextField!
    
    var Apptype = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : APPCOLOL]
        
        let attributedString1 = NSMutableAttributedString(string:"Don't have an account?", attributes:attrs1)
        
        let attributedString2 = NSMutableAttributedString(string:" Sign up", attributes:attrs2)
        
        attributedString1.append(attributedString2)
        self.signInBtn.setAttributedTitle(attributedString1, for: .normal)
    }
    
    @IBAction func goBackBtn(_ sender: Any)
    {
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signInAct(_ sender: Any)
    {
        let type = userNameTxt.text!
        
       
            if type == "driver@gmail.com"
            {
                 DEFAULT.set("driver", forKey: "APPTYPE")
                if #available(iOS 13.0, *)
                           {
                               SCENEDEL.loadDriverHomeView()
                           }
                           else
                           {
                               APPDEL.loadDriverHomeView()
                           }
            }
           
        
        else if  type == "dispatcher@gmail.com"
        {
             DEFAULT.set("dispatcher", forKey: "APPTYPE")
            if #available(iOS 13.0, *) {
                SCENEDEL.loadHomeView()
            }
            else
            {
                APPDEL.loadHomeView()
            }
        }
        DEFAULT.synchronize()
        
        
    }
    
    @IBAction func signupAct(_ sender: Any)
    {
        if self.Apptype == "driver"
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverSignupVC") as! DriverSignupVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DisSignupVC") as! DisSignupVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
}
