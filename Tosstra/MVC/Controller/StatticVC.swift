//
//  StatticVC.swift
//  Tosstra
//
//  Created by Eweb on 23/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class StatticVC: UIViewController,WKNavigationDelegate {
    @IBOutlet weak var webV: WKWebView!
       @IBOutlet weak var titleLbl: UILabel!
       
       var url = ""
       
       var pageTitle = ""
    
       override func viewDidLoad() {
           super.viewDidLoad()
        NetworkEngine.LOADERSHOW2()

        self.webV.navigationDelegate = self
           if url != ""
           {
               
               if let url1 = URL(string: url)
               {
                   webV.load(URLRequest(url: url1))
               }
              
           }
        self.titleLbl.text = self.pageTitle
           
           
       }
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    
     SVProgressHUD.dismiss()
   }

   func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    SVProgressHUD.dismiss()
   }
       @IBAction func closeAct(_ sender: UIButton)
          {
            self.navigationController?.popViewController(animated: true)
          }
}
