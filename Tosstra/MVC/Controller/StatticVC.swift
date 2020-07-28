//
//  StatticVC.swift
//  Tosstra
//
//  Created by Eweb on 23/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import WebKit

class StatticVC: UIViewController {
    @IBOutlet weak var webV: WKWebView!
       @IBOutlet weak var titleLbl: UILabel!
       
       var url = ""
       
       var pageTitle = ""
    
       override func viewDidLoad() {
           super.viewDidLoad()
        
           if url != ""
           {
               
               if let url1 = URL(string: url)
               {
                   webV.load(URLRequest(url: url1))
               }
              
           }
        self.titleLbl.text = self.pageTitle
           
           
       }

       
       @IBAction func closeAct(_ sender: UIButton)
          {
            self.navigationController?.popViewController(animated: true)
          }
}
