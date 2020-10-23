//
//  VIewReportVC.swift
//  Tosstra
//
//  Created by Eweb on 15/10/20.
//  Copyright © 2020 Eweb. All rights reserved.
//


import UIKit
import KYDrawerController
import SVProgressHUD

class VIewReportVC: UIViewController {
    
    var currentTag = 0
    
    @IBOutlet weak var txtSelectedDateTime: UITextField!
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
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btn10: UIButton!
    @IBOutlet weak var btn11: UIButton!
    @IBOutlet weak var btn12: UIButton!
    @IBOutlet weak var btn13: UIButton!
    @IBOutlet weak var btn14: UIButton!
    @IBOutlet weak var btn15: UIButton!
    @IBOutlet weak var btn16: UIButton!
    @IBOutlet weak var btn17: UIButton!
    @IBOutlet weak var btn18: UIButton!
    @IBOutlet weak var btn19: UIButton!
    @IBOutlet weak var btn20: UIButton!
    @IBOutlet weak var btn21: UIButton!
    @IBOutlet weak var btn22: UIButton!
    @IBOutlet weak var btn23: UIButton!
    @IBOutlet weak var btn24: UIButton!
    @IBOutlet weak var btn25: UIButton!
    @IBOutlet weak var btn26: UIButton!
    @IBOutlet weak var btn27: UIButton!
    @IBOutlet weak var btn28: UIButton!
    @IBOutlet weak var btn29: UIButton!
    @IBOutlet weak var btn30: UIButton!
    @IBOutlet weak var btn31: UIButton!
    @IBOutlet weak var btn32: UIButton!
    @IBOutlet weak var btn33: UIButton!
    @IBOutlet weak var btn34: UIButton!
    @IBOutlet weak var btn35: UIButton!
    @IBOutlet weak var btn36: UIButton!
    @IBOutlet weak var btn37: UIButton!
    @IBOutlet weak var btn38: UIButton!
    @IBOutlet weak var btn39: UIButton!
    @IBOutlet weak var btn40: UIButton!
    
    @IBOutlet weak var btn41: UIButton!
    @IBOutlet weak var btn42: UIButton!
    @IBOutlet weak var btn43: UIButton!
    @IBOutlet weak var btn44: UIButton!
    @IBOutlet weak var btn45: UIButton!
    @IBOutlet weak var btn46: UIButton!
    @IBOutlet weak var btn47: UIButton!
    @IBOutlet weak var btn48: UIButton!
    @IBOutlet weak var btn49: UIButton!
    @IBOutlet weak var btn50: UIButton!
    @IBOutlet weak var btn51: UIButton!
    @IBOutlet weak var btn52: UIButton!
    @IBOutlet weak var btn53: UIButton!
    @IBOutlet weak var btn54: UIButton!
    @IBOutlet weak var btn55: UIButton!
    
    @IBOutlet weak var btn56: UIButton!
    
    @IBOutlet weak var btn57: UIButton!
    @IBOutlet weak var btn58: UIButton!
    
    
    let datePicker = UIDatePicker()
    var apiData:LogBookModel?
    
    
    @IBOutlet weak var stack1: UIStackView!
    
    @IBOutlet weak var stack2: UIStackView!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var stack3: UIStackView!
    
    @IBOutlet weak var stack4: UIStackView!
    @IBOutlet weak var view2: CardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        txtSelectedDateTime.delegate = self
        txtSelectedDateTime.tag = 0
        
        self.stack1.isHidden=true
        self.stack2.isHidden=true
        self.stack3.isHidden=true
        self.stack4.isHidden=true
        
        self.view1.isHidden=true
        self.view2.isHidden=true
        
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
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension VIewReportVC:UITextFieldDelegate
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
        
        if tag == 2 || tag == 1
        {
            datePicker.datePickerMode = .date
            // datePicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 0, to: Date())
        }
        else
        {
            datePicker.datePickerMode = .date
            // datePicker.minimumDate = Calendar.current.date(byAdding: .second, value: 0, to: Date())
        }
        
        
        datePicker.setValue(CALENDERCOLOL, forKeyPath: "textColor")
        self.datePicker.setValue(true, forKey: "highlightsToday")
        
        
        datePicker.backgroundColor = UIColor.white
        
        
        //datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        
        self.view.addGestureRecognizer(tapGesture)
        
        
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Submit", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(self.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(self
            .cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        txtSelectedDateTime.inputAccessoryView = toolbar
        
        // txtMechSig_Date.inputAccessoryView = toolbar
        //txtDriverSig_Date.inputAccessoryView = toolbar
        
        
        txtSelectedDateTime.inputView = datePicker
        // txtMechSig_Date.inputView = datePicker
        // txtDriverSig_Date.inputView = datePicker
    }
    
    @objc func dateChange()
    {
        let formatter = DateFormatter()
        //formatter.dateFormat = "dd/MM/yyyy"
        if self.currentTag == 2 || self.currentTag == 1
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
            txtSelectedDateTime.text! = dateSelected
        }
        //        if  self.currentTag == 1
        //        {
        //            txtMechSig_Date.text! = dateSelected
        //        }
        //
        //        if self.currentTag == 2
        //        {
        //            txtDriverSig_Date.text! = dateSelected
        //        }
        
        
        
        
        
        DEFAULT.synchronize()
        
        self.view.endEditing(true)
        DEFAULT.synchronize()
        self.view.endEditing(true)
    }
    
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        //formatter.dateFormat = "dd/MM/yyyy"
        if self.currentTag == 2 || self.currentTag == 1
        {
            formatter.dateFormat = "dd-MMM-yyyy"
            
        }
        else
        {
            formatter.dateFormat = "dd-MMM-yyyy"
        }
        
        
        let dateSelected = formatter.string(from: datePicker.date)
        
        
        if self.currentTag == 0
        {
            txtSelectedDateTime.text! = dateSelected
        }
        
        
        DEFAULT.synchronize()
        
        self.view.endEditing(true)
        DEFAULT.synchronize()
        self.view.endEditing(true)
        
        self.GetLogBookAPI()
    }
    
    @objc func cancelDatePicker(){
        
        
        self.view.endEditing(true)
    }
    @objc func viewTapped()
    {
        self.view.endEditing(true)
    }
}
extension VIewReportVC
{
    //MARK:- AddLogBookAPI Api
    
    func GetLogBookAPI()
    {
         SVProgressHUD.show()
        
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        
        
        let params = ["driverId" : id,
                      "dateTime" : self.txtSelectedDateTime.text!]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: GETLOGBOOKAPI, parameters: params) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.apiData = try decoder.decode(LogBookModel.self, from: response!)
                    
                    if self.apiData?.code == "200"
                        
                    {
                         SVProgressHUD.dismiss()
                        NetworkEngine.showToast(controller: self, message: self.apiData?.message ?? "")
                       self.stack1.isHidden=true
                       self.stack2.isHidden=true
                       self.stack3.isHidden=true
                       self.stack4.isHidden=true
                       
                       self.view1.isHidden=true
                       self.view2.isHidden=true
                
                    }
                    else
                    {
                        self.view.makeToast(self.apiData?.message)
                        if self.apiData?.data?.count ?? 0 > 0
                        {
                            self.stack1.isHidden=false
                            self.stack2.isHidden=false
                            self.stack3.isHidden=false
                            self.stack4.isHidden=false
                            
                            self.view1.isHidden=false
                            self.view2.isHidden=false
                            self.txtcompanyName.text = self.apiData?.data?[0].companyName
                            self.txtAddress.text = self.apiData?.data?[0].address
                            
                            self.txtDateTime.text = self.apiData?.data?[0].dateTime
                            self.txtTruckNo.text = self.apiData?.data?[0].truckNumber
                            
                            
                            self.txtOdometerReading.text = self.apiData?.data?[0].odometerReading
                            self.txtTrailerNo.text = self.apiData?.data?[0].trailer
                            
                            self.txtReview.text = self.apiData?.data?[0].remarks
                            self.txtdriverSign1.text = self.apiData?.data?[0].driverSignature
                            
                            self.txtMechSig.text = self.apiData?.data?[0].mechanicSignature
                            self.txtMechSig_Date.text = self.apiData?.data?[0].dateTimeM
                            
                            self.txtDriverSig2.text = self.apiData?.data?[0].driverSignature2
                            self.txtDriverSig_Date.text = self.apiData?.data?[0].dateTimeD
                            self.txtSelectedTime.text = self.apiData?.data?[0].logBookTime
                            
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn1.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn1.isSelected=true
                            }
                            else
                            {
                                self.btn1.isSelected=false
                            }
                            
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn2.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn2.isSelected=true
                            }
                            else
                            {
                                self.btn2.isSelected=false
                            }
                            
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn3.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn3.isSelected=true
                            }
                            else
                            {
                                self.btn3.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn4.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn4.isSelected=true
                            }
                            else
                            {
                                self.btn4.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn5.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn5.isSelected=true
                            }
                            else
                            {
                                self.btn5.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn6.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn6.isSelected=true
                            }
                            else
                            {
                                self.btn6.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn7.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn7.isSelected=true
                            }
                            else
                            {
                                self.btn7.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn8.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn8.isSelected=true
                            }
                            else
                            {
                                self.btn8.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn9.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn9.isSelected=true
                            }
                            else
                            {
                                self.btn9.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn10.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn10.isSelected=true
                            }
                            else
                            {
                                self.btn10.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn11.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn11.isSelected=true
                            }
                            else
                            {
                                self.btn11.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn12.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn12.isSelected=true
                            }
                            else
                            {
                                self.btn12.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn13.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn13.isSelected=true
                            }
                            else
                            {
                                self.btn13.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn14.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn14.isSelected=true
                            }
                            else
                            {
                                self.btn14.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn15.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn15.isSelected=true
                            }
                            else
                            {
                                self.btn15.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn16.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn16.isSelected=true
                            }
                            else
                            {
                                self.btn16.isSelected=false
                            }
                            
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn17.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn17.isSelected=true
                            }
                            else
                            {
                                self.btn17.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn18.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn18.isSelected=true
                            }
                            else
                            {
                                self.btn18.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn19.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn19.isSelected=true
                            }
                            else
                            {
                                self.btn19.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn20.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn20.isSelected=true
                            }
                            else
                            {
                                self.btn20.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn21.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn21.isSelected=true
                            }
                            else
                            {
                                self.btn21.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn22.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn22.isSelected=true
                            }
                            else
                            {
                                self.btn22.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn23.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn23.isSelected=true
                            }
                            else
                            {
                                self.btn23.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn24.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn24.isSelected=true
                            }
                            else
                            {
                                self.btn24.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn25.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn25.isSelected=true
                            }
                            else
                            {
                                self.btn25.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn26.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn26.isSelected=true
                            }
                            else
                            {
                                self.btn26.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn27.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn27.isSelected=true
                            }
                            else
                            {
                                self.btn27.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn28.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn28.isSelected=true
                            }
                            else
                            {
                                self.btn28.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn29.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn29.isSelected=true
                            }
                            else
                            {
                                self.btn29.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn30.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn30.isSelected=true
                            }
                            else
                            {
                                self.btn30.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn31.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn31.isSelected=true
                            }
                            else
                            {
                                self.btn31.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn32.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn32.isSelected=true
                            }
                            else
                            {
                                self.btn32.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn33.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn33.isSelected=true
                            }
                            else
                            {
                                self.btn33.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn34.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn34.isSelected=true
                            }
                            else
                            {
                                self.btn34.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn35.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn35.isSelected=true
                            }
                            else
                            {
                                self.btn35.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn36.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn36.isSelected=true
                            }
                            else
                            {
                                self.btn36.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn37.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn37.isSelected=true
                            }
                            else
                            {
                                self.btn37.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn38.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn38.isSelected=true
                            }
                            else
                            {
                                self.btn38.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn39.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn39.isSelected=true
                            }
                            else
                            {
                                self.btn39.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn40.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn40.isSelected=true
                            }
                            else
                            {
                                self.btn40.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn41.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn41.isSelected=true
                            }
                            else
                            {
                                self.btn41.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn42.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn42.isSelected=true
                            }
                            else
                            {
                                self.btn42.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn43.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn43.isSelected=true
                            }
                            else
                            {
                                self.btn43.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn44.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn44.isSelected=true
                            }
                            else
                            {
                                self.btn44.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn45.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn45.isSelected=true
                            }
                            else
                            {
                                self.btn45.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn46.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn46.isSelected=true
                            }
                            else
                            {
                                self.btn46.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn47.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn47.isSelected=true
                            }
                            else
                            {
                                self.btn47.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn48.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn48.isSelected=true
                            }
                            else
                            {
                                self.btn48.isSelected=false
                            }
                            
                            
                            
                            
                            
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn49.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn49.isSelected=true
                            }
                            else
                            {
                                self.btn49.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn50.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn50.isSelected=true
                            }
                            else
                            {
                                self.btn50.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn51.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn51.isSelected=true
                            }
                            else
                            {
                                self.btn51.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn52.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn52.isSelected=true
                            }
                            else
                            {
                                self.btn52.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn53.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn53.isSelected=true
                            }
                            else
                            {
                                self.btn53.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn54.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn54.isSelected=true
                            }
                            else
                            {
                                self.btn54.isSelected=false
                            }
                            if self.apiData?.data?[0].logBookCheckBox?.contains(((self.btn55.titleLabel?.text ?? "").trimmingCharacters(in: .whitespaces))) ?? false
                            {
                                print("true")
                                self.btn55.isSelected=true
                            }
                            else
                            {
                                self.btn55.isSelected=false
                            }
                            
                            
                            
                            if self.apiData?.data?[0].logBookCheckBox?.contains("Condition") ?? false
                            {
                                print("true")
                                self.btn56.isSelected=true
                            }
                            else
                            {
                                self.btn56.isSelected=false
                            }
                            
                            if self.apiData?.data?[0].logBookCheckBox?.contains("Defect") ?? false
                            {
                                print("true")
                                self.btn57.isSelected=true
                            }
                            else
                            {
                                self.btn57.isSelected=false
                            }
                            
                            if self.apiData?.data?[0].logBookCheckBox?.contains("Defect not") ?? false
                            {
                                print("true")
                                self.btn58.isSelected=true
                            }
                            else
                            {
                                self.btn58.isSelected=false
                            }
                             SVProgressHUD.dismiss()
                        }
                        
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
