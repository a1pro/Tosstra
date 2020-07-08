//
//  DriverProfileVC.swift
//  Tosstra
//
//  Created by Eweb on 04/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import KYDrawerController
import Alamofire
import SVProgressHUD
import SDWebImage
import Letters

class DriverProfileVC: UIViewController {

    var fromSideBar = "yes"
    
    var viewProfiledata:ViewProfileModel?
    
    @IBOutlet weak var emailTxt: UITextField!
       

       @IBOutlet weak var addressTxt: UITextField!
       @IBOutlet weak var firstNameTxt: UITextField!
       
       @IBOutlet weak var dotNameTxt: UITextField!
       @IBOutlet weak var lastNameTxt: UITextField!
    
    @IBOutlet weak var companyName: UILabel!
         @IBOutlet weak var type: UILabel!
    
    var pickedImageProduct = UIImage()
       var imagePicker = UIImagePickerController()
       var choosenImage:UIImage!
      @IBOutlet weak var profileImage: UIImageView!
        var apiData:ForgotPasswordModel?
    
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
        if fromSideBar == "yes"
        {
            let drawer = navigationController?.parent as? KYDrawerController
                   drawer?.setDrawerState(.opened, animated: true)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
       
    }
    
    // MARK:- Choose profile Image method
         
         @IBAction func editProfilePic(_ sender: Any)
         {
             
             
        
             
          let actionSheet = UIAlertController(title: "Add photo !", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
             actionSheet.view.tintColor = UIColor.black
             
             let camera1 =  UIAlertAction(title: "Take Photo", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
                 self.openCamera()
             })
           
             
             let camera2 =  UIAlertAction(title: "Choose from Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
                 self.openGallary()
             })
            
             
          let camera3 =  UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (alert:UIAlertAction!) -> Void in
                 
             })
          
             
             // Add the actions
             imagePicker.delegate = self
             imagePicker.isEditing = true
             imagePicker.allowsEditing = true
             
             actionSheet.addAction(camera1)
             actionSheet.addAction(camera2)
             actionSheet.addAction(camera3)
             self.present(actionSheet, animated: true, completion: {() -> Void in
                 
          
             })
             
             
             
         }
      

      @IBAction func saveProfilePic(_ sender: Any)
      {
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                                                {
                                                    NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                                                }
                                                else
                                                {
                                                 self.editProfileApi()
                                                }
      }
      
      //MARK:- Choose image end ---------------------------------
        
        func openCamera()
        {
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
            {
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
               
                    imagePicker.mediaTypes=["public.image"]
                
                
                imagePicker.delegate = self
                imagePicker.isEditing = true
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            else
            {
                let alertWarning = UIAlertView(title:"Alert!", message: "You don't have camera", delegate:nil, cancelButtonTitle:"Ok")
                alertWarning.show()
            }
        }
        func openGallary()
        {
            
            
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            
                picker.mediaTypes=["public.image"]
            
            
            present(picker, animated: true, completion: nil)
        }
     
}
extension DriverProfileVC
{
    //MARK:- Login With Email Api
       
       func viewProfileAPI()
       {
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
      
           let params = ["userId" : id]   as [String : String]
           
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
extension DriverProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
           
            
            
            // Local variable inserted by Swift 4.2 migrator.
            let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
            
            
            if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
            {
                self.profileImage.image = image
            }
            else
            {
                let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
                self.profileImage.image = image
                
            }
        
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func editProfileApi()
    {
        
        
        
        var useriD="1"
        if let id = DEFAULT.value(forKey: "USERID") as? String
        {
            useriD=id
        }
        
        let uploadDict = ["userId":useriD,
                          "firstName":self.firstNameTxt.text!,
                          "lastName":self.lastNameTxt.text!,
                          "dotNumber":self.dotNameTxt.text!,
                          "address":self.addressTxt.text!,
                          "companyName":self.companyName.text!] as [String:String]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            //Parameter for Upload files
            let timestamp = NSDate().timeIntervalSince1970
            
            
            
            let imgData = self.profileImage.image!.jpegData(compressionQuality: 0.2)!
            
            
            multipartFormData.append(imgData, withName: "profileImg" , fileName: "\(timestamp*10).jpg" , mimeType: "\(timestamp*10)/jpg")
            
            
            print("Para in upload = \(uploadDict)\(self.profileImage)")
            print("\(self.profileImage.image)")
            
            for(key,value) in uploadDict
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
            
        }, usingThreshold:UInt64.init(),
           to: EDIT_PROFILE_API, //URL Here
            method: .post,//pass header dictionary here
            encodingCompletion: { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    print("the status code is :")
                    SVProgressHUD.dismiss()
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("something")
                        if progress.isFinished
                        {
                            // self.ViewProfileAPI()
                            SVProgressHUD.dismiss()
                        }
                        else{
                            SVProgressHUD.show()
                        }
                    })
                    
                    upload.responseJSON { response in
                        debugPrint("SUCCESS RESPONSE: \(response)")
                        
                        let decoder = JSONDecoder()
                        do
                        {
                            if response.data != nil
                            {
                                self.apiData = try decoder.decode(ForgotPasswordModel.self, from: response.data!)
                                if self.apiData?.code == "200"
                                    
                                {
                                    self.view.makeToast(self.apiData?.message)
                                    
                                }
                                else
                                {
                                     if #available(iOS 13.0, *) {
                                                                           SCENEDEL.loadDriverHomeView()
                                                                           
                                                                       }
                                                                       else
                                                                       {
                                                                           APPDEL.loadDriverHomeView()
                                                                       }
                                }
                                
                            }
                            
                            
                            
                            
                        }
                        catch let error
                        {
                            self.view.makeToast(error.localizedDescription)
                        }
                    }
                    break
                case .failure(let encodingError):
                    SVProgressHUD.dismiss()
                    print("the error is  : \(encodingError.localizedDescription)")
                    break
                }
        })
    
    }
}
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
