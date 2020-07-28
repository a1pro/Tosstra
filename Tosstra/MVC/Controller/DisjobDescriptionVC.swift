//
//  DisjobDescriptionVC.swift
//  Tosstra
//
//  Created by Eweb on 03/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import KYDrawerController
//ADD JOB

class DisjobDescriptionVC: UIViewController {
    @IBOutlet var addInfoText:UITextView!
    @IBOutlet var segmentedControl:UISegmentedControl!
    @IBOutlet var segmentOuterView:UIView!
    
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var amountTxt: UITextField!
    @IBOutlet weak var p_stresttxt: UITextView!
  //  @IBOutlet weak var p_stateTxt: UITextField!
    
   // @IBOutlet weak var p_zipTxt: UITextField!
   // @IBOutlet weak var p_cityTxt: UITextField!
    
    @IBOutlet weak var d_stresttxt: UITextView!
    
    
    //@IBOutlet weak var d_zipTxt: UITextField!
 
    
    @IBOutlet weak var stsrt_FromTxt: UITextField!
    
    @IBOutlet weak var endTimeTxt: UITextField!
    @IBOutlet weak var date_fromTxt: UITextField!
    
    @IBOutlet weak var date_totxt: UITextField!
    var selectedDate = ""
    
    var offerForSelectedDrivers = ""
    
    var currentTag = 0
    var apiData:ForgotPasswordModel?
    
    var puplongitude = ""
   var puplatitude = ""
    var drplatitude = ""
    var drplongitude = ""
    
    
    var isPickUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addInfoText.layer.borderColor = UIColor.lightGray.cgColor
        self.addInfoText.layer.borderWidth = 1
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        let titleTextAttributes2 = [NSAttributedString.Key.foregroundColor: APPCOLOL]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes2, for: .normal)
        
        self.segmentedControl.layer.cornerRadius = segmentOuterView.bounds.height / 2
        self.segmentedControl.layer.borderColor = UIColor.white.cgColor
        self.segmentedControl.layer.borderWidth = 1
        self.segmentedControl.layer.masksToBounds = true
        
        segmentOuterView.layer.cornerRadius = segmentOuterView.bounds.height / 2
        segmentOuterView.layer.borderColor = UIColor.blue.cgColor
        segmentOuterView.layer.borderWidth = 1
        
        stsrt_FromTxt.delegate = self
        endTimeTxt.delegate = self
        date_fromTxt.delegate = self
        date_totxt.delegate = self
        
        
        
        date_fromTxt.tag = 0
        date_totxt.tag = 1
        stsrt_FromTxt.tag = 2
        endTimeTxt.tag = 3
        
        
    }
  @IBAction func locationAct(_ sender: UIButton)
          {
           let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "ChooseAddressVC") as! ChooseAddressVC
            if sender.tag == 0
            {
               self.isPickUp=true
            }
            else
            {
                self.isPickUp=false
            }
            
           self.navigationController?.pushViewController(locationSearchTable, animated: true)
    
          }
    override func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(true)
              
              if let loc = DEFAULT.value(forKey: "CHOOSENLOC") as? String
              {
                 
                
                print("location = \(loc)")
                print("isPickUp = \(isPickUp)")
                
                
                if isPickUp
                {
                    self.puplatitude  = DEFAULT.value(forKey: "CHOOSENLAT") as? String ?? "30.99"
                    self.puplongitude = DEFAULT.value(forKey: "CHOOSENLONG") as? String ?? "76.9889"
                     self.p_stresttxt.text = loc
                }
               else
                {
                    self.drplatitude = DEFAULT.value(forKey: "CHOOSENLAT") as? String ?? "30.99"
                self.drplongitude = DEFAULT.value(forKey: "CHOOSENLONG") as? String ?? "76.9889"
                    self.d_stresttxt.text = loc
                }
                
                
                  DEFAULT.removeObject(forKey: "CHOOSENLOC")
                  DEFAULT.synchronize()
                
              }
              
              
          }
    
    @IBAction func MenuAct(_ sender: UIButton)
    {
        //let drawer = navigationController?.parent as? KYDrawerController
        //drawer?.setDrawerState(.opened, animated: true)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendJobAct(_ sender: UIButton)
    {
        if amountTxt.text == "" || p_stresttxt.text == ""  || d_stresttxt.text == "" || date_totxt.text == "" || date_fromTxt.text == "" || stsrt_FromTxt.text == "" || endTimeTxt.text == ""
                       {
                           
                           NetworkEngine.commonAlert(message: "Please fill all details.", vc: self)
                           
                       }
                    

                       else
                       {
                           
                           if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                           {
                               NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                           }
                           else
                           {
                             self.CreateJobAPI()
                           }
                           
                       }

    }
    
}

extension DisjobDescriptionVC:UITextFieldDelegate
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
        
        if tag == 0 || tag == 1
        {
            datePicker.datePickerMode = .date
            datePicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 0, to: Date())
        }
        else
        {
            datePicker.datePickerMode = .time
            datePicker.minimumDate = Calendar.current.date(byAdding: .second, value: 0, to: Date())
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
        
        stsrt_FromTxt.inputAccessoryView = toolbar
        
        endTimeTxt.inputAccessoryView = toolbar
        date_fromTxt.inputAccessoryView = toolbar
        date_totxt.inputAccessoryView = toolbar
        
        
        stsrt_FromTxt.inputView = datePicker
        
        endTimeTxt.inputView = datePicker
        date_fromTxt.inputView = datePicker
        date_totxt.inputView = datePicker
    }
    
    @objc func dateChange()
    {
      let formatter = DateFormatter()
        //formatter.dateFormat = "dd/MM/yyyy"
        if self.currentTag == 0 || self.currentTag == 1
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
            date_fromTxt.text! = dateSelected
        }
        if  self.currentTag == 1
        {
            date_totxt.text! = dateSelected
        }
        
        if self.currentTag == 2
        {
            stsrt_FromTxt.text! = dateSelected
        }
        
        if  self.currentTag == 3
        {
            endTimeTxt.text! = dateSelected
        }
        
        
        
        DEFAULT.synchronize()
        
        self.view.endEditing(true)
        DEFAULT.synchronize()
        self.view.endEditing(true)
    }
    
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        //formatter.dateFormat = "dd/MM/yyyy"
        if self.currentTag == 0 || self.currentTag == 1
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
            date_fromTxt.text! = dateSelected
        }
        if  self.currentTag == 1
        {
            date_totxt.text! = dateSelected
        }
        
        if self.currentTag == 2
        {
            stsrt_FromTxt.text! = dateSelected
        }
        
        if  self.currentTag == 3
        {
            endTimeTxt.text! = dateSelected
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
extension DisjobDescriptionVC
{
    //MARK:- Create job Api
       
       func CreateJobAPI()
       {
           var useriD="1"
         var rateType="perHours"
                  if let id = DEFAULT.value(forKey: "USERID") as? String
                  {
                      useriD=id
                  }
        if segmentedControl.selectedSegmentIndex == 0
        {
          rateType="perHours"
        }
        else{
            rateType="perLoad"
        }
                  
      
        let params = ["dispatcherId" : useriD,
                      "offerForSelectedDrivers" : self.offerForSelectedDrivers,
                      "rateType" : rateType,
                         "rate" : amountTxt.text!,
                         "pupStreet" : p_stresttxt.text!,
                         "pupCity" : "",
                         "pupState" : "",
                         "pupZipcode" : "",
                         "drpStreet" : d_stresttxt.text!,
                         "drpCity" : "",
                         "drpState" : "",
                         "drpZipcode" : "",
                         "dateFrom" : date_fromTxt.text!,
                         "dateTo" : date_totxt.text!,
                         "startTime" : stsrt_FromTxt.text!,
                         "endTime" : endTimeTxt.text!,
                         
                         "puplongitude" : self.puplongitude,
                         "puplatitude" : self.puplatitude,
                         "drplatitude" : self.drplatitude,
                         "drplongitude" : self.drplongitude,
                         
                          "additinal_Instructions" : addInfoText.text!]   as [String : String]
           
           ApiHandler.ModelApiPostMethod(url: CREATE_JOB_API, parameters: params) { (response, error) in
               
               if error == nil
               {
                   let decoder = JSONDecoder()
                   do
                   {
                       self.apiData = try decoder.decode(ForgotPasswordModel.self, from: response!)
                    
                    if self.apiData?.code == "200"
                           
                       {
                         
          NetworkEngine.showToast(controller: self, message: self.apiData?.message)
                       }
                       else
                       {
                     
                         self.view.makeToast(self.apiData?.message)
                          if #available(iOS 13.0, *) {
                                                              SCENEDEL.loadHomeView()
                                                              
                                                          }
                                                          else
                                                          {
                                                              APPDEL.loadHomeView()
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


class CustomSegmentedControl: UISegmentedControl {
    
    override func layoutSubviews(){
        
        super.layoutSubviews()
        
        //corner radius
        let cornerRadius = bounds.height/2
        let maskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        //background
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = maskedCorners
        //foreground
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex), let foregroundImageView = subviews[foregroundIndex] as? UIImageView
        {
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: 5, dy: 5)
            foregroundImageView.image = UIImage()
            foregroundImageView.highlightedImage = UIImage()
            foregroundImageView.backgroundColor = UIColor.darkGray
            foregroundImageView.clipsToBounds = true
            foregroundImageView.layer.masksToBounds = true
            
            foregroundImageView.layer.cornerRadius = 14
            foregroundImageView.layer.maskedCorners = maskedCorners
        }
    }
}
