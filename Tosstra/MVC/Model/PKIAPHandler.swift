//
//  PKIAPHandler.swift
//  Tosstra
//
//  Created by Eweb on 09/09/20.
//  Copyright © 2020 Eweb. All rights reserved.
//


import Foundation
import UIKit
import StoreKit
import SVProgressHUD

enum PKIAPHandlerAlertType {
    case setProductIds
    case disabled
    case restored
    case purchased
    
    var message: String{
        switch self {
        case .setProductIds: return "Product ids not set, call setProductIds method!"
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        }
    }
}
class PKIAPHandler: NSObject {
    
    //MARK:- Shared Object
    //MARK:-
    static let shared = PKIAPHandler()
    private override init() { }
    
    //MARK:- Properties
    //MARK:- Private
    fileprivate var productIds = [String]()
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var fetchProductComplition: (([SKProduct])->Void)?
    
    fileprivate var productToPurchase: SKProduct?
    fileprivate var purchaseProductComplition: ((PKIAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)?
    
    //MARK:- Public
    var isLogEnabled: Bool = true
    
    //MARK:- Methods
    //MARK:- Public
    
    //Set Product Ids
    func setProductIds(ids: [String]) {
        self.productIds = ids
    }
    
    //MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchase(product: SKProduct, complition: @escaping ((PKIAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)) {
        
        ApiHandler.LOADERSHOW()
        
        self.purchaseProductComplition = complition
        self.productToPurchase = product
        
        if self.canMakePurchases()
        {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            log("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
            
            
        }
        else
        {
            complition(PKIAPHandlerAlertType.disabled, nil, nil)
           
        }
    }
    
    // RESTORE PURCHASE
    func restorePurchase()
    {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(complition: @escaping (([SKProduct])->Void)){
        
        self.fetchProductComplition = complition
        // Put here your IAP Products ID's
        if self.productIds.isEmpty {
            log(PKIAPHandlerAlertType.setProductIds.message)
            fatalError(PKIAPHandlerAlertType.setProductIds.message)
        }
        else {
            productsRequest = SKProductsRequest(productIdentifiers: Set(self.productIds))
            productsRequest.delegate = self
            productsRequest.start()
        }
    }
    
    //MARK:- Private
    fileprivate func log <T> (_ object: T) {
        if isLogEnabled {
            NSLog("\(object)")
        }
    }
}

//MARK:- Product Request Delegate and Payment Transaction Methods
//MARK:-
extension PKIAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    // REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        
        if (response.products.count > 0)
        {
            if let complition = self.fetchProductComplition
            {
                complition(response.products)
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
       
        
        for transaction in queue.transactions
        {
            let t: SKPaymentTransaction = transaction
            let prodID = t.payment.productIdentifier as String
            
            switch prodID
            {
            case "com.moocherApp":
                
            break
            case "com.MoocherEventOrOffer":
                break
            // implement the given in-app purchase as if it were bought
            default:
                print("iap not found")
            }
            
        }
        
        if let complition = self.purchaseProductComplition
        {
            complition(PKIAPHandlerAlertType.restored, nil, nil)
            
     
        }
       
    }
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction])
    
    
    {
        print(transactions)
        print("removed Transactions")
     
        SVProgressHUD.dismiss()
        
        
        if DEFAULT.value(forKey: "CREATEPAY2") != nil
        {
            DEFAULT.removeObject(forKey: "CREATEPAY2")
            DEFAULT.synchronize()

            DEFAULT.set("yes", forKey: "FROMBACK")
            DEFAULT.synchronize()
            //APPDEL.loadRetailerView()
        }
        if DEFAULT.value(forKey: "CREATEPAY6") != nil
               {
                   DEFAULT.removeObject(forKey: "CREATEPAY6")
                   DEFAULT.synchronize()
               // APPDEL.loadCustomerView()
                 NotificationCenter.default.post(name: Notification.Name("GroupPromotionNoti"), object: nil, userInfo: nil)
               }
        
    }
    
    // IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction
            {
                switch trans.transactionState
                {
                case .purchased:
                    log("Product purchase done")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    if let complition = self.purchaseProductComplition {
                        complition(PKIAPHandlerAlertType.purchased, self.productToPurchase, trans)
                    }
                    
                   // NetworkEngine.networkEngineObj.showAlert(messageToShow: "Product purchase done.", title: "Transaction Message!")
                    break
                    
                case .failed:
                    log("Product purchase failed")
                    
                    // NetworkEngine.networkEngineObj.showAlert(messageToShow: "Product purchase failed.", title: "Transaction Message!")
              
                    if DEFAULT.value(forKey: "CREATEPAY") != nil
                    {
                        DEFAULT.set("CREATEPAY2", forKey: "CREATEPAY2")
                        DEFAULT.removeObject(forKey: "CREATEPAY")
                        DEFAULT.synchronize()
                      
                    }
                    if DEFAULT.value(forKey: "CREATEPAY5") != nil
                                       {
                                           DEFAULT.set("CREATEPAY6", forKey: "CREATEPAY6")
                                           DEFAULT.removeObject(forKey: "CREATEPAY5")
                                           DEFAULT.synchronize()
                                         
                                       }
                    
                    
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    break
                case .restored:
                    log("Product restored")
                
                    NetworkEngine.networkEngineObj.showAlert(messageToShow: "You've successfully restored your purchase!", title: "Restored Message!")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                case .deferred:
                    log("Product deferred")
//                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                  
                    break
                    
                case .purchasing:
                    log("Product purchasing......")
                    
                    break
                default:
                    
                    print(trans.transactionState)
                
                    break
                }
                
               
            }
            
        }
    }
}
