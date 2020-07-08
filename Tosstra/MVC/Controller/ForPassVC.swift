//
//  ForPassVC.swift
//  Tosstra
//
//  Created by Eweb on 07/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit

class ForPassVC: UIViewController {
    
    @IBOutlet var emailTxt:UITextField!
    
    var apiData:ForgotPasswordModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func goBackBtn(_ sender: Any)
    {
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitAct(_ sender: Any)
    {
        
        if emailTxt.text == ""
        {
            
            NetworkEngine.commonAlert(message: "Please enter email id.", vc: self)
            
        }
        else if !NetworkEngine.networkEngineObj.validateEmail(candidate: emailTxt.text!)
        {
            NetworkEngine.commonAlert(message: "Please enter valid email.", vc: self)
        }
            
        else
        {
            
            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
            {
                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
            }
            else
            {
                self.sendOTPAPI()
            }
            
        }
    }
    
}
extension ForPassVC
{
    //MARK:- Forgot Api
    
    func sendOTPAPI()
    {
        
        
        let params = ["email" : emailTxt.text!]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: FORGOT_PASSWORD_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.apiData = try decoder.decode(ForgotPasswordModel.self, from: response!)
                    
                    if self.apiData?.code == "200"
                        
                    {
                        
                        NetworkEngine.commonAlert(message: self.apiData?.message ?? "", vc: self)
                    }
                    else
                    {
                        self.view.makeToast(self.apiData?.message)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewPasswordVC") as! NewPasswordVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        })
                        
                        
                    }
                    
                    
                }
                catch let error
                {
                    self.view.makeToast(error.localizedDescription)
                }
                
            }
            else
            {
                self.view.makeToast(error)
            }
        }
    }
    
}
