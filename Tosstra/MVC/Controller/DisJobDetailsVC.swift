//
//  DisJobDetailsVC.swift
//  Tosstra
//
//  Created by Eweb on 03/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import KYDrawerController
import MessageUI
import MapKit
import CoreLocation

class DisJobDetailsVC: UIViewController,MFMailComposeViewControllerDelegate {
    
    var dict = NSDictionary()
    @IBOutlet var addInfoText:UITextView!
    
    @IBOutlet weak var companyName: UILabel!
    
    @IBOutlet weak var pickupAddress: UILabel!
    @IBOutlet weak var dropOffAddress: UILabel!
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var locationTxt: UILabel!
    
    @IBOutlet weak var phoneNum: UILabel!
    
    @IBOutlet weak var stsrt_FromTxt: UITextField!
    
    @IBOutlet weak var endTimeTxt: UITextField!
    @IBOutlet weak var date_fromTxt: UITextField!
    
    @IBOutlet weak var date_totxt: UITextField!
    
    @IBOutlet weak var endBtn: UIButton!
    var jobId = ""
    var apiData:ForgotPasswordModel?
    var dispatcherId = ""
    var driverId = ""
    
    
    var fromNoti = "no"
    var JobDetailData:JobDetailMedel?
    
    
    var sourceLat = "30.7041"
    var sourceLong = "76.1025"
    var destinationLat = "28.7041"
    var destinationLong = "77.1025"
    var driverLat = "28.7041"
    var driverLong = "77.1025"
    
    
    var sourceAdd = ""
    var destinationAdd = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if fromNoti == "yes"
        {
            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
            {
                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
            }
            else
            {
                self.JobDetalsAPI()
            }
            self.endBtn.isHidden = true
        }
        else
        {
            self.endBtn.isHidden = false
            //                self.phoneNum.text = dict.value(forKey: "phone") as? String ?? ""
            //
            //        self.companyName.text = dict.value(forKey: "companyName") as? String ?? ""
            //             self.emailTxt.text = dict.value(forKey: "email") as? String ?? ""
            //             self.locationTxt.text = dict.value(forKey: "address") as? String ?? ""
            //
            //             self.stsrt_FromTxt.text = dict.value(forKey: "startTime") as? String ?? ""
            //
            //             self.endTimeTxt.text = dict.value(forKey: "endTime") as? String ?? ""
            //
            //             self.date_fromTxt.text = dict.value(forKey: "dateFrom") as? String ?? ""
            //
            //             self.date_totxt.text = dict.value(forKey: "dateTo") as? String ?? ""
            //
            //              self.nameTxt.text = (dict.value(forKey: "firstName") as? String ?? "") + " " + (dict.value(forKey: "lastName") as? String ?? "")
            //
            //             let d_add = (dict.value(forKey: "drpStreet") as? String ?? "") + " " + (dict.value(forKey: "drpCity") as? String ?? "")
            //
            //             let d =  (dict.value(forKey: "drpState") as? String ?? "") + " " + (dict.value(forKey: "drpZipcode") as? String ?? "")
            //
            //            self.dropOffAddress.text = d_add + " " + d
            //
            //             let p_add = (dict.value(forKey: "pupStreet") as? String ?? "") + " " + (dict.value(forKey: "pupCity") as? String ?? "")
            //
            //                let p = (dict.value(forKey: "pupState") as? String ?? "") + " " + (dict.value(forKey: "pupZipcode") as? String ?? "")
            //
            //
            //             self.pickupAddress.text = p_add + " " + p
            //
            //             self.jobId = (dict.value(forKey: "jobId") as? String ?? "")
            
            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
            {
                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
            }
            else
            {
                self.JobDetalsAPI()
            }
        }
    }
    
    
    @IBAction func MenuAct(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func PhoneCallAct(_ sender:UIButton)
    {
        
        if let phone = self.phoneNum.text as? String
        {
            
            guard let number = URL(string: "tel://" + phone) else { return }
            UIApplication.shared.open(number)
        }
    }
    
    
    //MARK: IBAction Method for Button click
    @IBAction func sendEmail(_ sender: Any) {
        //TODO:  You should chack if we can send email or not
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([self.emailTxt.text!])
            // mail.setSubject("Tatra")
            // mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            present(mail, animated: true)
        } else {
            print("Application is not able to send an email")
        }
    }
    
    //MARK: MFMail Compose ViewController Delegate method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @IBAction func locAct(_ sender: UIButton)
    {
        
        openMapForPlace()
        
        
    }
    
    func openMapForPlace() {
        
        
        let lat1 : NSString = self.driverLat as NSString
        let lng1 : NSString = self.driverLong as NSString
        
        let latitude:CLLocationDegrees =  lat1.doubleValue
        let longitude:CLLocationDegrees =  lng1.doubleValue
        
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.locationTxt.text!
        mapItem.openInMaps(launchOptions: options)
    }
    
    
    
    
    @IBAction func endJobAct(_ sender: UIButton)
    {
        
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to end job?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
            {
                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
            }
            else
            {
                if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                {
                    NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                }
                else
                {
                    
                    
                    
                    self.EndJobStartAPI()
                    
                    
                }
            }
            
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func driverLoc(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TrackLoactionVC") as! TrackLoactionVC
        vc.fromTrackDriver = "yes"
        vc.sourceLat=self.sourceLat
        vc.sourceLong=self.sourceLong
        vc.sourceAdd=self.sourceAdd
        vc.destinationLat=self.destinationLat
        vc.destinationLong=self.destinationLong
        vc.destinationAdd=self.destinationAdd
        vc.driverLat=self.driverLat
        vc.driverLong=self.driverLong
        vc.jobId = self.jobId
        vc.driverId = self.driverId
        
        vc.dispatcherId = self.dispatcherId
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- JoBEndAPI Api
    
    func EndJobStartAPI()
    {
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        
        
        let params = ["dispatcherId" : id,
                      "driverId" : self.driverId,
                      "jobId" : self.jobId]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: END_JOB_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.apiData = try decoder.decode(ForgotPasswordModel.self, from: response!)
                    
                    
                    
                    
                    let elDrawer = self.navigationController?.parent as? KYDrawerController
                    let home = self.storyboard?.instantiateViewController(withIdentifier: "ActiveDriverVC") as? ActiveDriverVC
                    
                    
                    let _nav = UINavigationController(rootViewController: home ?? UIViewController())
                    _nav.isNavigationBarHidden = true
                    elDrawer?.mainViewController = _nav
                    elDrawer?.setDrawerState(.closed, animated: true)
                    
                    
                    
                    
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
    
    
    //MARK:- accept reject Api
    
    func JobDetalsAPI()
    {
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        
        let params = ["jobId" : self.jobId,
                      "driverId" : self.driverId,
                      "dispatcherId" : self.dispatcherId]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: JOB_DETAILS_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.JobDetailData = try decoder.decode(JobDetailMedel.self, from: response!)
                    
                    if self.JobDetailData?.code == "200"
                        
                    {
                        
                        NetworkEngine.commonAlert(message: self.JobDetailData?.message ?? "", vc: self)
                    }
                    else
                    {
                        self.view.makeToast(self.JobDetailData?.message)
                        if self.JobDetailData?.data?.count ?? 0 > 0
                        {
                            let dict = self.JobDetailData?.data?[0]
                            self.companyName.text = dict?.companyName
                            // self.amountTxt.isUserInteractionEnabled = false
                            
                            let driverId = dict?.driverId ?? ""
                            
                            
                            self.emailTxt.text = dict?.driveremail ?? ""
                            self.locationTxt.text = dict?.driveraddress ?? ""
                            
                            self.stsrt_FromTxt.text = dict?.startTime ?? ""
                            
                            self.endTimeTxt.text = dict?.endTime ?? ""
                            
                            self.date_fromTxt.text = dict?.dateFrom ?? ""
                            self.date_totxt.text = dict?.dateTo ?? ""
                            self.nameTxt.text = (dict?.driverfirstName ?? "") + " " + (dict?.driverlastName ?? " ")
                            
                            let d_add = (dict?.drpStreet ?? " ") + " " + (dict?.drpCity ?? " ")
                            
                            let d =  (dict?.drpState ?? " ") + " " + (dict?.drpZipcode ?? " ")
                            
                            self.dropOffAddress.text = d_add + " " + d
                            
                            let p_add = (dict?.pupStreet ?? "") + " " + (dict?.pupCity ?? "")
                            
                            let p = (dict?.pupState ?? "") + " " + (dict?.pupZipcode ?? "")
                            
                            
                            self.pickupAddress.text = p_add + " " + p
                            self.phoneNum.text = dict?.driverphone ?? ""
                            
                            self.sourceLat = dict?.puplatitude ?? ""
                            self.sourceLong = dict?.puplongitude ?? ""
                            
                            
                            
                            self.destinationLat = dict?.drplatitude ?? ""
                            self.destinationLong = dict?.drplongitude ?? ""
                            
                            
                            self.driverLat = dict?.driverlatitude ?? ""
                            self.driverLong = dict?.driverlongitude ?? ""
                            
                            
                            
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
