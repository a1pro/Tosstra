//
//  VehicleReportVC.swift
//  Tosstra
//
//  Created by Eweb on 12/10/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import KYDrawerController
import SVProgressHUD
class VehicleReportVC: UIViewController {
    
    var currentTag = 0
    @IBOutlet weak var txtSelectedTime: UITextField!
    
    @IBOutlet weak var txtdriverSign1: UITextField!
    @IBOutlet weak var txtcompanyName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtDateTime: UITextField!
    @IBOutlet weak var txtTruckNo: UITextField!
    @IBOutlet weak var txtOdometerReading: UITextField!
    @IBOutlet weak var txtTrailerNo: UITextField!
    @IBOutlet weak var txtMechSig: UITextField!
    @IBOutlet weak var txtMechSig_Date: UITextField!
    @IBOutlet weak var txtDriverSig2: UITextField!
    @IBOutlet weak var txtDriverSig_Date: UITextField!
    
    @IBOutlet weak var txtReview: UITextView!
    
    
    let datePicker = UIDatePicker()
    var seletcedArray = NSMutableArray()
    var optionSelected = ""
    var logBookCheckBox = "Condition of the above vehicle is satisfactory"
    var logBookCheckBoxArray = NSMutableArray()

    var apiData:ForgotPasswordModel?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        txtDateTime.delegate = self
        txtDateTime.delegate = self
        
        txtMechSig_Date.delegate = self
        txtDriverSig_Date.delegate = self
         txtSelectedTime.delegate = self
        
        txtSelectedTime.tag = 0
        txtDateTime.tag = 3
        txtMechSig_Date.tag = 1
        txtDriverSig_Date.tag = 2
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let loc = DEFAULT.value(forKey: "CHOOSENLOC") as? String
        {
            self.txtAddress.text = loc
            DEFAULT.removeObject(forKey: "CHOOSENLOC")
            DEFAULT.synchronize()
        }
        
        
    }
    
    @IBAction func closeAct(_ sender: UIButton)
    {
        let drawer = navigationController?.parent as? KYDrawerController
        drawer?.setDrawerState(.opened, animated: true)
    }
    
    @IBAction func viewReportAct(_ sender: UIButton)
    {
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "VIewReportVC") as! VIewReportVC
        
        self.navigationController?.pushViewController(locationSearchTable, animated: true)
    }
    
    @IBAction func selectLocation(_ sender: UIButton)
    {
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "ChooseAddressVC") as! ChooseAddressVC
        
        self.navigationController?.pushViewController(locationSearchTable, animated: true)
    }
    
    
    @IBAction func optionSelect1(_ sender: UIButton)
    {
        
        let title = (sender.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces)
        
        if sender.isSelected
        {
            sender.isSelected=false
            self.seletcedArray.remove(title)
        }
        else
        {
            self.seletcedArray.add(title)
            sender.isSelected=true
            
        }
    }
    
    @IBAction func optionSelect2(_ sender: UIButton)
    {
        let title = (sender.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces)
        
        if sender.isSelected
        {
            sender.isSelected=false
            self.seletcedArray.remove(title)
        }
        else
        {
            self.seletcedArray.add(title)
            sender.isSelected=true
            
        }
    }
    @IBAction func conditionSelect(_ sender: UIButton)
    {
         let title = (sender.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces)
               
               if sender.isSelected
               {
                   sender.isSelected=false
                   self.seletcedArray.remove("Condition")
               }
               else
               {
                   self.seletcedArray.add("Condition")
                   sender.isSelected=true
                   
               }
    }
    @IBAction func defectCorrect(_ sender: UIButton)
    {
        let title = (sender.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces)
               
               if sender.isSelected
               {
                   sender.isSelected=false
                   self.seletcedArray.remove("Defect")
               }
               else
               {
                   self.seletcedArray.add("Defect")
                   sender.isSelected=true
                   
               }
    }
    @IBAction func defectNotCorrect(_ sender: UIButton)
    {
        let title = (sender.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces)
               
               if sender.isSelected
               {
                   sender.isSelected=false
                   self.seletcedArray.remove("Defect not")
               }
               else
               {
                   self.seletcedArray.add("Defect not")
                   sender.isSelected=true
                   
               }
    }
    
    @IBAction func saveAct(_ sender: UIButton)
    {
        self.optionSelected = self.seletcedArray.componentsJoined(by: ",")
        //self.logBookCheckBox = self.logBookCheckBoxArray.componentsJoined(by: ",")
        
        print("selected option = \(self.optionSelected)")
        
        
        
        if txtcompanyName.text == ""
        {
            
            NetworkEngine.commonAlert(message: "Please enter company name.", vc: self)
            
        }
        else if txtAddress.text == ""
        {
            
            NetworkEngine.commonAlert(message: "Please enter address.", vc: self)
            
        }
            
        else if txtTruckNo.text == ""
        {
            
            NetworkEngine.commonAlert(message: "Please enter truck number.", vc: self)
            
        }
            
            else if txtOdometerReading.text == ""
                   {
                       
                       NetworkEngine.commonAlert(message: "Please enter reading.", vc: self)
                       
                   }
                       
                   else if txtTrailerNo.text == ""
                   {
                       
                       NetworkEngine.commonAlert(message: "Please enter trailer number.", vc: self)
                       
                   }
            else if txtReview.text == ""
            {
                
                NetworkEngine.commonAlert(message: "Please enter review.", vc: self)
                
            }
                
            else if txtdriverSign1.text == ""
            {
                
                NetworkEngine.commonAlert(message: "Please enter driver signature.", vc: self)
                
            }
            else if txtDriverSig_Date.text == ""
            {
                
                NetworkEngine.commonAlert(message: "Please select driver signature date.", vc: self)
                
            }
            
            else if txtMechSig.text == ""
                       {
                           
                           NetworkEngine.commonAlert(message: "Please enter mechanics signature.", vc: self)
                           
                       }
                       else if txtDriverSig_Date.text == ""
                       {
                           
                           NetworkEngine.commonAlert(message: "Please select mechanics signature date.", vc: self)
                           
                       }
            
        else if txtDateTime.text == ""
        {
            
            NetworkEngine.commonAlert(message: "Please select date and time.", vc: self)
            
        }
      
         
            
        else
        {
            
            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
            {
                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
            }
            else
            {
                self.AddLogBookAPI()
            }
            
        }
        
    }
}
extension VehicleReportVC:UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.currentTag = textField.tag
        
        self.showDatePicker(self.currentTag)
        
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
    }
    func showDatePicker(_ tag:Int)
    {
        
        if tag == 2 || tag == 1 || tag == 3
        {
            datePicker.datePickerMode = .date
            // datePicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 0, to: Date())
        }
        else
        {
            datePicker.datePickerMode = .time
            // datePicker.minimumDate = Calendar.current.date(byAdding: .second, value: 0, to: Date())
        }
        
        
        datePicker.setValue(CALENDERCOLOL, forKeyPath: "textColor")
        self.datePicker.setValue(true, forKey: "highlightsToday")
        
        
        datePicker.backgroundColor = UIColor.white
        
        
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        
        self.view.addGestureRecognizer(tapGesture)
        
        
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(self.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(self
            .cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        txtDateTime.inputAccessoryView = toolbar
        
        txtMechSig_Date.inputAccessoryView = toolbar
        txtDriverSig_Date.inputAccessoryView = toolbar
        txtSelectedTime.inputAccessoryView = toolbar
        
         txtSelectedTime.inputView = datePicker
        txtDateTime.inputView = datePicker
        txtMechSig_Date.inputView = datePicker
        txtDriverSig_Date.inputView = datePicker
    }
    
    @objc func dateChange()
    {
        let formatter = DateFormatter()
        //formatter.dateFormat = "dd/MM/yyyy"
        if self.currentTag == 2 || self.currentTag == 1 || self.currentTag == 3
        {
            formatter.dateFormat = "dd-MMM-yyyy"
            
        }
        else
        {
            formatter.dateFormat = "hh:mm a"
        }
        
        
        let dateSelected = formatter.string(from: datePicker.date)
        
        
        if self.currentTag == 0
        {
            txtSelectedTime.text! = dateSelected
        }
        if  self.currentTag == 1
        {
            txtMechSig_Date.text! = dateSelected
        }
        
        if self.currentTag == 2
        {
            txtDriverSig_Date.text! = dateSelected
        }
        if self.currentTag == 3
        {
            txtDateTime.text! = dateSelected
        }
        
        
        
        
        DEFAULT.synchronize()
        
        self.view.endEditing(true)
        DEFAULT.synchronize()
        self.view.endEditing(true)
    }
    
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        //formatter.dateFormat = "dd/MM/yyyy"
        if self.currentTag == 2 || self.currentTag == 1 || self.currentTag == 3
        {
            formatter.dateFormat = "dd-MMM-yyyy"
            
        }
        else
        {
            formatter.dateFormat = "hh:mm a"
        }
        
        
        let dateSelected = formatter.string(from: datePicker.date)
        
        
        if self.currentTag == 3
        {
            txtDateTime.text! = dateSelected
        }
        if self.currentTag == 0
        {
            txtSelectedTime.text! = dateSelected
        }
        if  self.currentTag == 1
        {
            txtMechSig_Date.text! = dateSelected
        }
        
        if self.currentTag == 2
        {
            txtDriverSig_Date.text! = dateSelected
        }
        
        DEFAULT.synchronize()
        
        self.view.endEditing(true)
        DEFAULT.synchronize()
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        
        
        self.view.endEditing(true)
    }
    @objc func viewTapped()
    {
        self.view.endEditing(true)
    }
}
extension VehicleReportVC
{
    //MARK:- AddLogBookAPI Api
    
    func AddLogBookAPI()
    {
        SVProgressHUD.show()
        
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        
        
        let params = ["driverId" : id,
                      "address" : self.txtAddress.text!,
                      "companyName" : self.txtcompanyName.text!,
                      "dateTime" : txtDateTime.text!,
                      "logBookTime" : self.txtSelectedTime.text!,
                      "truckNumber" : self.txtTruckNo.text!,
            "odometerReading" : self.txtOdometerReading.text!,
            "trailer" : txtTrailerNo.text!,
            "remarks" : self.txtReview.text!,
            "driverSignature" : self.txtdriverSign1.text!,
            "mechanicSignature" : self.txtMechSig.text!,
            "dateTimeM" : self.txtMechSig_Date.text!,
            "driverSignature2" : self.txtDriverSig2.text!,
            "dateTimeD" : txtDriverSig_Date.text!,
            "logBookCheckBox" : self.optionSelected]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: ADDLOGBOOKAPI, parameters: params) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.apiData = try decoder.decode(ForgotPasswordModel.self, from: response!)
                    
                    if self.apiData?.code == "200"
                        
                    {
                        SVProgressHUD.dismiss()
                        
                        NetworkEngine.showToast(controller: self, message: self.apiData?.message ?? "")
                        
                    }
                    else
                    {
                        self.view.makeToast(self.apiData?.message)
                        
                         SVProgressHUD.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                                                      if #available(iOS 13.0, *)
                                                                                                          {
                                                                                                              SCENEDEL.loadDriverHomeView()
                                                                                                              
                                                                                                          }
                                                                                                          else
                                                                                                          {
                                                                                                              APPDEL.loadDriverHomeView()
                                                                                                          }
                                               })
                    
                        
                        
                    }
                    
                    
                }
                catch let error
                {
                     SVProgressHUD.dismiss()
                    self.view.makeToast(error.localizedDescription)
                }
                
            }
            else
            {
                 SVProgressHUD.dismiss()
                self.view.makeToast(error)
            }
        }
    }
    
}
