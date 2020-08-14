//
//  ChangePasswordVC.swift
//  Tosstra
//
//  Created by Eweb on 07/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//


import UIKit

class ChangePasswordVC: UIViewController {
    @IBOutlet var otpTxt:UITextField!
    @IBOutlet var newPassswordTxt:UITextField!
    @IBOutlet var confirmPassTxt:UITextField!
    var apiData:ForgotPasswordModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBackBtn(_ sender: Any)
    {
        
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitBtn(_ sender: Any)
    {
        
        
        if otpTxt.text == ""
        {
            
            NetworkEngine.commonAlert(message: "Please enter Old Password.", vc: self)
            
        }
        else if newPassswordTxt.text == ""
        {
            
            NetworkEngine.commonAlert(message: "Please enter New Password.", vc: self)
            
        }
            
        else if (Int(newPassswordTxt.text!.count) < 6)
        {
            NetworkEngine.commonAlert(message: "Please enter at least 6 characters password.", vc: self)
            
        }
        else if confirmPassTxt.text == ""
        {
            
            NetworkEngine.commonAlert(message: "Please  confirm Password.", vc: self)
            
        }
            
        else if newPassswordTxt.text != confirmPassTxt.text
        {
            NetworkEngine.commonAlert(message: "Password and confirm password should match.", vc: self)
            
        }
            
        else
        {
            
            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
            {
                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
            }
            else
            {
                self.ChangePasswordAPI()
            }
            
        }
    }
    
    
}
extension ChangePasswordVC
{
    //MARK:- Change password Api
    
    func ChangePasswordAPI()
    {
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        
        let params = ["userId" : id,
                      "oldPassword" : otpTxt.text!,
                      "newPassword" : newPassswordTxt.text!,
                      "confirm_password" : confirmPassTxt.text!]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: CHANGE_PASSWORD_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.apiData = try decoder.decode(ForgotPasswordModel.self, from: response!)
                    
                    if self.apiData?.code == "200"
                        
                    {
                        NetworkEngine.showToast(controller: self, message: self.apiData?.message ?? "")
                        
                    }
                    else
                    {
                        self.view.makeToast(self.apiData?.message)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                            
                            self.navigationController?.popViewController(animated: true)
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
