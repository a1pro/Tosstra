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
    
    @IBOutlet var check1:UIImageView!
    @IBOutlet var check2:UIImageView!
    
    @IBOutlet weak var agreeBtn: UIButton!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPassTxt: UITextField!
    @IBOutlet weak var firstNameTxt: UITextField!
    
    @IBOutlet weak var dotNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var companyNameTxt: UITextField!
    
    var signupData:Dis_Register_Model?
    
    var SubUserType = "Owner"
    
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
    @IBAction func termBtnAct(_ sender: UIButton)
          {
            if sender.isSelected
            {
                sender.isSelected = false
                self.agreeBtn.setImage(UIImage(named: "check-box"), for: UIControl.State.normal)
            }
            else
            
            {
                sender.isSelected = true
                self.agreeBtn.setImage(UIImage(named: "check-box-1"), for: UIControl.State.normal)
            }
             
           
          }
       

    @IBAction func signInAct(_ sender: Any)
       {
           
          
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "DisSigninVC") as! DisSigninVC
          self.navigationController?.pushViewController(vc, animated: true)
       }
    
    @IBAction func signUpAct(_ sender: Any)
         {
               if emailTxt.text == ""
                  {
                      
                      NetworkEngine.commonAlert(message: "Please enter email id.", vc: self)
                      
                  }
                  else if passwordTxt.text == ""
                  {
                      NetworkEngine.commonAlert(message: "Please enter password.", vc: self)
                      
                  }
                else if firstNameTxt.text == ""
                                 {
                                     NetworkEngine.commonAlert(message: "Please enter First Name.", vc: self)
                                     
                                 }
                               
                               
                else if lastNameTxt.text == ""
                {
                    NetworkEngine.commonAlert(message: "Please enter Last Name.", vc: self)
                    
                }
                else if companyNameTxt.text == ""
                               {
                                   NetworkEngine.commonAlert(message: "Please enter Company Name.", vc: self)
                                   
                               }
                               
                else if dotNameTxt.text == ""
                {
                    NetworkEngine.commonAlert(message: "Please enter Dot Number.", vc: self)
                    
                }
                
                
                
                  else if (Int(passwordTxt.text!.count) < 6)
                  {
                      NetworkEngine.commonAlert(message: "Please enter at least 6 characters password.", vc: self)
                      
                  }

                  else if passwordTxt.text != confirmPassTxt.text
                  {
               NetworkEngine.commonAlert(message: "Password and confirm password should match.", vc: self)
                      
                  }

                  else if !NetworkEngine.networkEngineObj.validateEmail(candidate: emailTxt.text!)
                  {
                      NetworkEngine.commonAlert(message: "Please enter valid email.", vc: self)
                  }
               else if self.agreeBtn.image(for: .normal) == UIImage(named: "check-box-1")
                                 {
                                     NetworkEngine.commonAlert(message: "Please agree the T&C.", vc: self)
                                 }


                  else
                  {
                      
                      if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                      {
                          NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                      }
                      else
                      {
                        self.SignupWithEmailAPI()
                      }
                      
                  }

          
         }
    
    
    @IBAction func checkAct(_ sender: UIButton)
          {
              
            if sender.tag == 0
            {
                
                
                if self.check1.image == UIImage(named: "check-box")
                {
                    self.check2.image = UIImage(named: "check-box")
                    self.check1.image = UIImage(named: "check-box-1")
                    self.SubUserType = "Dispatcher"
                   
                }
                else
                {
                    self.check1.image = UIImage(named: "check-box")
                    self.check2.image = UIImage(named: "check-box-1")
                     self.SubUserType = "Owner"
                }
                
            }
            else
            {
//              self.check2.image = UIImage(named: "check-box")
//                self.check1.image = UIImage(named: "check-box-1")
                
                if self.check2.image == UIImage(named: "check-box")
                             {
                                 self.check2.image = UIImage(named: "check-box-1")
                                 self.check1.image = UIImage(named: "check-box")
                                 self.SubUserType = "Owner"
                             }
                             else
                             {
                                 self.check1.image = UIImage(named: "check-box-1")
                                 self.check2.image = UIImage(named: "check-box")
                                self.SubUserType = "Dispatcher"
                             }
            }
             
          }


}
extension DisSignupVC
{
    //MARK:- Login With Email Api
       
       func SignupWithEmailAPI()
       {
           
      
           let params = ["email" : emailTxt.text!,
                         "password" : passwordTxt.text!,
                         "firstName" : firstNameTxt.text!,
                         "lastName" : lastNameTxt.text!,
                         "companyName" : companyNameTxt.text!,
                           "userType" : "Dispatcher",
                           "SubUserType" : self.SubUserType,
                          "dotNumber" : dotNameTxt.text!]   as [String : String]
           
           ApiHandler.ModelApiPostMethod(url: DISPATCHER_REGISTER_API, parameters: params) { (response, error) in
               
               if error == nil
               {
                   let decoder = JSONDecoder()
                   do
                   {
                       self.signupData = try decoder.decode(Dis_Register_Model.self, from: response!)
                    
                    if self.signupData?.code == "200"
                           
                       {
                           self.view.makeToast(self.signupData?.message)
            
                       }
                       else
                       {
                        let count = self.signupData?.data?.count ?? 0
                        if count > 0
                        {
                            DEFAULT.set(self.signupData?.data?[0].id, forKey: "USERID")
                            DEFAULT.set(self.signupData?.data?[0].userType, forKey: "USERTYPE")
                              DEFAULT.set(self.signupData?.data?[0].userType, forKey: "APPTYPE")
                            DEFAULT.synchronize()
                                                     
                                                    if #available(iOS 13.0, *) {
                                                                                                      SCENEDEL.loadLoginView()
                                                                                                         
                                                                                                     }
                                                                                                     else
                                                                                                     {
                                                                                                         APPDEL.loadLoginView()
                                                                                                     }
                                                   
                        }
                       
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
