//
//  DisSignupVC.swift
//  Tosstra
//
//  Created by Eweb on 02/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit

class DisSignupVC: UIViewController {

    @IBOutlet var signInBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
               
               let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : APPCOLOL]
               
               let attributedString1 = NSMutableAttributedString(string:"Already have an account?", attributes:attrs1)
               
               let attributedString2 = NSMutableAttributedString(string:" Sign in", attributes:attrs2)
               
               attributedString1.append(attributedString2)
        self.signInBtn.setAttributedTitle(attributedString1, for: .normal)
    }
    
    @IBAction func goBackBtn(_ sender: Any)
    {
        
       
       self.navigationController?.popViewController(animated: true)
    }

    @IBAction func signInAct(_ sender: Any)
       {
           
          
          self.navigationController?.popViewController(animated: true)
       }

}
