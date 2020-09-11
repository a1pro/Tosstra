//
//  PaymentViewController.swift
//  Tosstra
//
//  Created by Eweb on 09/09/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import UIKit
import StoreKit
import Alamofire
import SVProgressHUD
class PaymentViewController: UIViewController {
    
    var attrs = [
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17.0),
        NSAttributedString.Key.foregroundColor : APPCOLOL,
        NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
    
    var attributedString = NSMutableAttributedString(string:"")
    @IBOutlet weak var restore: UIButton!
    @IBOutlet weak var home: UIButton!
    @IBOutlet weak var privacy: UIButton!
    @IBOutlet weak var termcon: UIButton!
    
    //MARK:- for payment method
    var productsArray:[SKProduct]!
    let receiptFileURL = Bundle.main.appStoreReceiptURL
    
    
    var payment_id = "123455"
    var pay_success = "1"
    var payment_status = "1"
    var expiryDate = ""
    var purchaseDate = "1"
    var plan = "Monthly"
    var amount = "29.99 USD"
    
    var apiData:ForgotPasswordModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PKIAPHandler.shared.setProductIds(ids: ["com.Tosstra.monthlySubscription"])
        PKIAPHandler.shared.fetchAvailableProducts { [weak self](products)   in
            guard let sSelf = self else {return}
            sSelf.productsArray = products
            print(products)
        }
        print(receiptFileURL)
        
        
        // Do any additional setup after loading the view.
        let buttonTitleStr = NSMutableAttributedString(string:"Restore", attributes:attrs)
        // attributedString.append(buttonTitleStr)
        restore.setAttributedTitle(buttonTitleStr, for: .normal)
        
        
        let buttonTitleStr2 = NSMutableAttributedString(string:"Go to Home", attributes:attrs)
        //  buttonTitleStr2.append(buttonTitleStr2)
        home.setAttributedTitle(buttonTitleStr2, for: .normal)
        
        
        let buttonTitleStr3 = NSMutableAttributedString(string:"Term of Service", attributes:attrs)
        // buttonTitleStr3.append(buttonTitleStr3)
        termcon.setAttributedTitle(buttonTitleStr3, for: .normal)
        
        
        let buttonTitleStr4 = NSMutableAttributedString(string:"Privacy Policy", attributes:attrs)
        //buttonTitleStr4.append(buttonTitleStr4)
        privacy.setAttributedTitle(buttonTitleStr4, for: .normal)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        PKIAPHandler.shared.setProductIds(ids:  ["com.Tosstra.monthlySubscription"])
        PKIAPHandler.shared.fetchAvailableProducts { [weak self](products)   in
            guard let sSelf = self else {return}
            sSelf.productsArray = products
            print(products)
            
        }
    }
    
    @IBAction func buyNowBtn(_ sender: UIButton)
    {
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.expiryDate = ""
            ApiHandler.LOADERSHOW()
            self.plan = "Monthly"
            self.amount = "29.99 USD"
            if let id = self.productsArray
            {
                if self.productsArray.count>0//self.productsArray.count>1
                {
                    
                    PKIAPHandler.shared.purchase(product: self.productsArray[0]) { (alert, product, transaction) in
                        if let tran = transaction, let prod = product
                        {
                            //use transaction details and purchased product as you want
                            print(product)
                            print(transaction)
                        }
                        
                        self.getData()
                        
                        
                        
                        
                    }
                    
                }
                else
                    
                {
                    print("Product not found.")
                    SVProgressHUD.dismiss()
                    
                }
                
            }
            else
                
            {
                SVProgressHUD.dismiss()
                print("Product not found.")
                
            }
            
        }
        
        
        print("Buy now click")
        
        
    }
    
    
    //MARK:- Replce this url for live app
    
    func receiptValidation()
    {
        //    SandBox: “https://sandbox.itunes.apple.com/verifyReceipt”
        //
        //    iTunes Store : “https://buy.itunes.apple.com/verifyReceipt”
        
        // let  verifyReceiptURL = "https://sandbox.itunes.apple.com/verifyReceipt"
        let receiptURL = Bundle.main.appStoreReceiptURL
        let receipt = NSData(contentsOf: receiptURL!)
        
        
        let appleServer = receiptURL?.lastPathComponent == "sandboxReceipt" ? "sandbox" : "buy"
        
        let verifyReceiptURL = "https://\(appleServer).itunes.apple.com/verifyReceipt"
        
        
        
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString! as AnyObject, "password" : "99852e3cd1ab4f628794dbc1bfa925ae" as AnyObject]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let storeURL = URL(string: verifyReceiptURL)!
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.httpBody = requestData
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    print("receiptValidation =======>",jsonResponse)
                    if let date = self?.getExpirationDateFromResponse(jsonResponse as! NSDictionary)
                    {
                        print(date)
                    }
                } catch let parseError {
                    print(parseError)
                }
            })
            task.resume()
        } catch let parseError {
            print(parseError)
        }
    }
    
    func getExpirationDateFromResponse(_ jsonResponse: NSDictionary) -> Date?
    {
        
        if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
            
            let lastReceipt = receiptInfo.lastObject as! NSDictionary
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            
            if let expiresDate = lastReceipt["expires_date"] as? String
            {
                return formatter.date(from: expiresDate)
            }
            
            return nil
        }
        else {
            return nil
        }
    }
    
    func getData()
    {
        ApiHandler.LOADERSHOW()
        var requestContents: [String: Any] = [:]
        if let receiptURL = Bundle.main.appStoreReceiptURL
        {
            if let receipt = NSData(contentsOf: receiptURL)
                   {
                        requestContents = [
                            "receipt-data": receipt.base64EncodedString(options: []),
                           "password": "21c50c15a08f47759883da6f4f1153a1"
                       ]
                    let appleServer = receiptURL.lastPathComponent == "sandboxReceipt" ? "sandbox" : "buy"
                    
                    let stringURL = "https://\(appleServer).itunes.apple.com/verifyReceipt"
                    
                    print("Loading user receipt: \(stringURL)...")
                    
                    Alamofire.request(stringURL, method: .post, parameters: requestContents, encoding: JSONEncoding.default)
                        .responseJSON { response in
                            if let value = response.result.value as? NSDictionary
                            {
                                print("Data in = ")
                                print(value)
                                print(response)
                                
                                if let receiptInfo: NSArray = value["latest_receipt_info"] as? NSArray
                                {
                                    
                                    let lastReceipt = receiptInfo.lastObject as! NSDictionary
                                    
                                    if let transaction_id  =  lastReceipt["transaction_id"] as? String
                                    {
                                        self.payment_id = transaction_id
                                    }
                                    if let transaction_id  =  lastReceipt["transaction_id"] as? String
                                    {
                                        self.payment_id = transaction_id
                                        
                                    }
                                    if let expires_date  =  lastReceipt["expires_date"] as? String
                                    {
                                        self.expiryDate = expires_date
                                    }
                                    
                                    if let purchase_date  =  lastReceipt["purchase_date"] as? String
                                    {
                                        self.purchaseDate = purchase_date
                                    }
                                    
                                    print("lastReceipt in = ")
                                    print(lastReceipt)
                                    
                                    SVProgressHUD.dismiss()
                                    if  self.expiryDate == ""
                                    {
                                        
                                        
                                        let date = Date()
                                        var components = DateComponents()
                                        components.setValue(1, for: .month)
                                        let expirationDate = Calendar.current.date(byAdding: components, to: date)!
                                        let f:DateFormatter = DateFormatter()
                                        f.timeZone = NSTimeZone.local
                                        f.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
                                        f.timeZone = TimeZone(abbreviation: "UTC")
                                        
                                        self.expiryDate = f.string(from: expirationDate)
                                        
                                        
                                        
                                    }
                                    self.UserPaymentApi()
                                }
                              
                                
                            } else {
                                print("Receiving receipt from App Store failed: \(response.result)")
                                SVProgressHUD.dismiss()
                            }
                    }
                   }
            else
                   {
                        SVProgressHUD.dismiss()
                      print("receipt not valid")
                   }
            
        }
        else
        {
            print("receiptURL not valid")
             SVProgressHUD.dismiss()
        }
        
       
        
        
    }
    func dateDiff(dateStr:String) -> Int32
    {
        let f:DateFormatter = DateFormatter()
        f.timeZone = NSTimeZone.local
        f.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
        f.timeZone = TimeZone(abbreviation: "UTC")
        
        let now = f.string(from: Date())
        let startDate = f.date(from: dateStr)
        let endDate = f.date(from: now)
        var _: Calendar = Calendar.current
        
        print("current  date = \(String(describing: startDate))")
        print("expire  date = \(String(describing: endDate))")
     
        var timeAgo:Int32 = 0
      
        if ((endDate != nil) &&  (startDate != nil))
        {
            if endDate!.compare(startDate!) != ComparisonResult.orderedDescending
            {
                print("Valid")
                timeAgo = 1
            }
            else
            {
                print("Not Valid")
                timeAgo = 0
            }
        }
            
        else
        {
            print("Not Valid")
            timeAgo = 0
        }
        
        return timeAgo;
    }
    
    func UserPaymentApi()
    {
        ApiHandler.LOADERSHOW()
        
        
        var userid = "16"
        if let newuserID = DEFAULT.value(forKey: "USERID") as? String
        {
            userid = "\(newuserID)"
        }
        let params = ["user_id" : userid,
                      "payment_id" : self.payment_id,
                      "pay_success" : "1",
                      "payment_status" : "1",
                      "amount" : self.amount,
                      "plan" : self.plan,
                      "expiryDate" : self.expiryDate,
                      "purchaseDate" : self.purchaseDate
            ]   as [String : AnyObject]
        
        print(params)
        ApiHandler.ModelApiPostMethod2(url: UPADATEPAYMENTAPI, parameters: params) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.apiData = try decoder.decode(ForgotPasswordModel.self, from: response!)
                    
                    if self.apiData?.code == "200"
                        
                    {
                        self.view.makeToast(self.apiData?.message)
                        
                    }
                    else
                    {
                        
                        
                        let dayDiffrent =  self.dateDiff(dateStr: self.expiryDate)
                        if  dayDiffrent == 1
                        {
                            DEFAULT.set("yes", forKey: "PAYBACK")
                            DEFAULT.set("yes", forKey: "ISPAID")
                            
                            DEFAULT.synchronize()
                           if #available(iOS 13.0, *)
                                                              {
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
            else
            {
                self.view.makeToast(error)
            }
        }
        
        /*
         
         ApiHandler.ModelApiPostMethod2(url: UPADATEPAYMENTAPI, parameters: params) { (response, error) in
         
         if error == nil
         {
         print(response)
         
         SVProgressHUD.dismiss()
         
         if let dict = response as? NSDictionary
         {
         if dict.value(forKey: "code") as! String == "201"
         {
         let dayDiffrent =  self.dateDiff(dateStr: self.expiryDate)
         if  dayDiffrent == 1
         {
         DEFAULT.set("yes", forKey: "PAYBACK")
         DEFAULT.set("yes", forKey: "ISPAID")
         
         DEFAULT.synchronize()
         self.navigationController?.popViewController(animated: true)
         }
         }
         
         
         
         
         
         
         }
         
         }
         else
         {
         SVProgressHUD.dismiss()
         print(error)
         }
         }
         
         */
    }
    
    
    @IBAction func BackAct(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func restoreAct(_ sender: UIButton)
    {
        
        self.expiryDate = ""
        PKIAPHandler.shared.restorePurchase()
        if  let receiptURL = Bundle.main.appStoreReceiptURL
        {
            if let receipt = NSData(contentsOf: receiptURL)
            {
                self.getData()
            }
        }
        
    }
    
    @IBAction func HomeAct(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func termCondiAct(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StatticVC") as! StatticVC
        vc.url = Terms_and_Conditions
        vc.pageTitle = "Term of Services"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func PrivacyAct(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StatticVC") as! StatticVC
        vc.url = Privacy
        vc.pageTitle = "Privacy Policy"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
