//
//  ViewProfileVC.swift
//  Tosstra
//
//  Created by Eweb on 09/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import KYDrawerController
import Alamofire
import SVProgressHUD
import SDWebImage
import Letters

class ViewProfileVC: UIViewController {

    var fromSideBar = "yes"
    
    var viewProfiledata:ViewProfileModel?
    
    @IBOutlet weak var emailTxt: UITextField!
       

       @IBOutlet weak var addressTxt: UITextField!
       @IBOutlet weak var firstNameTxt: UITextField!
       
       @IBOutlet weak var dotNameTxt: UITextField!
       @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var phoneNumbTxt: UITextField!
    
    
    @IBOutlet weak var companyName: UILabel!
         @IBOutlet weak var type: UILabel!
    
    var pickedImageProduct = UIImage()
       var imagePicker = UIImagePickerController()
       var choosenImage:UIImage!
      @IBOutlet weak var profileImage: UIImageView!
        var apiData:ForgotPasswordModel?
    var userId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height/2
              self.profileImage.contentMode = .scaleAspectFill
              
              self.profileImage.clipsToBounds=true
        // Do any additional setup after loading the view.
        
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                                   {
                                       NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                                   }
                                   else
                                   {
                                    self.viewProfileAPI()
                                   }
    }
    
    @IBAction func MenuAct(_ sender: UIButton)
    {
      
            self.navigationController?.popViewController(animated: true)
        
       
    }
    
   

     
}
extension ViewProfileVC
{
    //MARK:- Login With Email Api
       
       func viewProfileAPI()
       {
      
       
        let params = ["userId" : self.userId]   as [String : String]
           
           ApiHandler.ModelApiPostMethod(url: VIEW_PROFILE_API, parameters: params) { (response, error) in
               
               if error == nil
               {
                   let decoder = JSONDecoder()
                   do
                   {
                       self.viewProfiledata = try decoder.decode(ViewProfileModel.self, from: response!)
                    
                    if self.viewProfiledata?.code == "200"
                           
                       {
                           self.view.makeToast(self.viewProfiledata?.message)
            
                       }
                       else
                       {
                        let count = self.viewProfiledata?.data?.count ?? 0
                        if count > 0
                        {
                            var type = self.viewProfiledata?.data?[0].userType
                            
                            self.emailTxt.text = self.viewProfiledata?.data?[0].email
                           self.firstNameTxt.text = self.viewProfiledata?.data?[0].firstName
                            self.lastNameTxt.text = self.viewProfiledata?.data?[0].lastName
                            
                           self.dotNameTxt.text = self.viewProfiledata?.data?[0].dotNumber
                            self.addressTxt.text = self.viewProfiledata?.data?[0].address
                            
                            self.companyName.text = self.viewProfiledata?.data?[0].companyName
                             self.phoneNumbTxt.text = self.viewProfiledata?.data?[0].phone
                            self.type.text = self.viewProfiledata?.data?[0].userType
                            DEFAULT.setValue(self.viewProfiledata?.data?[0].onlineStatus, forKey: "ONLINESTATUS")
                            DEFAULT.set(self.viewProfiledata?.data?[0].userType, forKey: "APPTYPE")
                            
                            
                            
                            
                            DEFAULT.synchronize()
                              if let profile = self.viewProfiledata?.data?[0].profileImg
                                             {
                                                 let fullurl = IMAGEBASEURL + profile
                                                 let fullUrl = URL(string: fullurl)!
                                                 
                                                 DEFAULT.setValue(profile, forKey: "PROFILEIMAGE")
                                                 DEFAULT.synchronize()
                                                 
                                                 // headerView.profileImge.sd_setImage(with: fullUrl, completed: nil)
                                              self.profileImage.sd_setImage(with: fullUrl, placeholderImage: #imageLiteral(resourceName: "logo"), options: .refreshCached, context: nil)
                                             }
                                             else
                                                 
                                             {
                                              
                                              self.profileImage.setImage(string: self.companyName.text!, color: nil, circular: true,textAttributes: attrs)

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
