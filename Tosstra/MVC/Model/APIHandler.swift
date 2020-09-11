//
//  APIHandler.swift
//  Tosstra
//
//  Created by Eweb on 06/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//


import Foundation
import Alamofire
import SwiftyJSON
import IQKeyboardManagerSwift
import Foundation
import Alamofire
import SVProgressHUD
import Toast_Swift

enum ApiMethod
{
    case GET
    case POST
    case PUT
}
class ApiHandler: NSObject
{
    
    static func PostMethod(url:String,parameters:[String:Any], completion: @escaping (_ data:[String:Any]? ,  _ error:String?) -> Void)
    {
        print(url)
        print(parameters)
        
        
        SVProgressHUD.show()
        SVProgressHUD.setBorderColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(APPCOLOL)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 60
        
        manager.request(url, method:.post, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response:DataResponse<Any>) in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
           SVProgressHUD.dismiss()
            
            if response.result.isSuccess
            {
                print("Response Data: \(response)")
                
                if let data = response.result.value as? [String:Any]
                {
                    completion(data , nil)
                   SVProgressHUD.dismiss()
                }else{
                    //Helper.Alertmessage(title: "Alert", message: (response.error?.localizedDescription)!, vc: nil)
                   SVProgressHUD.dismiss()
                 //   completion(nil,response.error)
                      completion(nil,response.error?.localizedDescription)
                  //  SVProgressHUD.showError(withStatus: response.result.error?.localizedDescription)
                }
            }
            else
            {
                //Helper.Alertmessage(title: "Alert", message: (response.error?.localizedDescription)!, vc: nil)
               SVProgressHUD.dismiss()
               
                print("Error \(String(describing: response.result.error?.localizedDescription))")
               // SVProgressHUD.showError(withStatus: response.result.error?.localizedDescription)
                  completion(nil,response.error?.localizedDescription)
            }
            
        }

    }
    
    static func ModelApiPostMethod(url:String,parameters:[String:Any], completion: @escaping (_ data:Data? ,  _ error:String?) -> Void)
    {
        print(url)
        print(parameters)
        
        
        SVProgressHUD.show()
        SVProgressHUD.setBorderColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(APPCOLOL)


        
        //    AF.request("http://myserver.com", method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            
        //    SVProgressHUD.dismiss()
            debugPrint(response)
            if (response.data != nil)
            {
                print("Response Data: \(response)")
                
                if let data = response.data
                {
                    completion(data , nil)
                   SVProgressHUD.dismiss()
                }else{
                    
                   SVProgressHUD.dismiss()
                    completion(nil,response.error?.localizedDescription)
                    print("Error \(String(describing: response.error))")
                    
                }
            }
            else
            {
                SVProgressHUD.dismiss()
                completion(nil,response.error?.localizedDescription)
                print("Error \(String(describing: response.error))")
                
                
            }
            
        }
    }
    
    static func ModelApiPostMethod2(url:String,parameters:[String:Any], completion: @escaping (_ data:Data? ,  _ error:String?) -> Void)
    {
        print(url)
        print(parameters)
  

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            
        //    SVProgressHUD.dismiss()
            debugPrint(response)
            if (response.data != nil)
            {
                print("Response Data: \(response)")
                
                if let data = response.data
                {
                    completion(data , nil)
                   SVProgressHUD.dismiss()
                }else{
                    
                   SVProgressHUD.dismiss()
                    completion(nil,response.error?.localizedDescription)
                    print("Error \(String(describing: response.error))")
                    
                }
            }
            else
            {
                SVProgressHUD.dismiss()
                completion(nil,response.error?.localizedDescription)
                print("Error \(String(describing: response.error))")
                
                
            }
            
        }
    }
    
    static func ModelApiGetMethod2(url:String, completion: @escaping (_ data:Data? ,  _ error:String?) -> Void)
    {
        
    }
    
    
    static func ModelApiGetMethod(url:String, completion: @escaping (_ data:Data? ,  _ error:String?) -> Void)
        {
        print(url)
    
//        SVProgressHUD.show()
//        SVProgressHUD.setBorderColor(UIColor.white)
//        SVProgressHUD.setForegroundColor(UIColor.white)
//            SVProgressHUD.setBackgroundColor(APPCOLOL)
            Alamofire.request(url).responseData{ (response) in
           // debugPrint(response)
       // SVProgressHUD.dismiss()
        
    
        if let data = response.data
        {
        completion(data , nil)
     //   SVProgressHUD.dismiss()
        }
        
        
        else
        {
 
       // SVProgressHUD.dismiss()
        completion(nil,response.error?.localizedDescription)
    
        }
        
        }
        }
        
    
    
    
    /*
     let header = ["device-id" : "123456",
     "device-type" : "IOS"]   as [String : Any]
     
     
     static func callApiWithParameters(url: String , withParameters parameters:[String:AnyObject], success:@escaping ([String:Any])->(), failure: @escaping (String)->(), method: ApiMethod, img: UIImage? , imageParamater: String,headers: [String:String])
     {
     switch method
     {
     case .GET:
     print("Api get method")
     
     AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
     print("Resposnse in api =\(response)")
     
     let statusCode = response.response?.statusCode
     //                let json = JSON(data: response.data!)
     
     do {
     
     let json = try JSON(data: response.data!)
     
     
     switch response.result
     {
     
     case .success(_):
     if(statusCode==200)
     {
     //if let data = response.result.value
     // {
     //    print (data)
     //    DispatchQueue.main.async
     //     {
     //          success(response.result.value as! [String:Any])
     //   }
     
     // }
     }
     else{
     /*
     if let data = response.result.value{
     let dict=data as! NSDictionary
     
     
     if statusCode == 593{
     DispatchQueue.main.async {
     failure("Forgot Password")
     }
     
     }else{
     DispatchQueue.main.async {
     failure(dict.value(forKey: "error_description") as! String)
     }
     
     }
     
     }
     */
     }
     break
     case .failure(_):
     failure("JSON could not be serialized because of error:\nThe data couldn’t be read because it isn’t in the correct format.")
     /*
     if let error = response.result.error{
     let str = error.localizedDescription as String
     if str.isEqual("JSON could not be serialized because of error:\nThe data couldn’t be read because it isn’t in the correct format."){
     return
     }
     DispatchQueue.main.async {
     failure(str)
     }
     
     }
     */
     
     }
     }
     catch _ {
     failure("JSON could not be serialized because of error:\nThe data couldn’t be read because it isn’t in the correct format.")
     // Error handling
     }
     
     }
     
     case .POST:
     print("Api get method")
     
     AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
     print("Resposnse in api =\(response)")
     
     let statusCode = response.response?.statusCode
     //                let json = JSON(data: response.data!)
     
     do {
     
     let json = try JSON(data: response.data!)
     
     
     switch response.result
     {
     
     case .success(_):
     /*
     if(statusCode==200)
     {
     if let data = response.result.value
     {
     print (data)
     DispatchQueue.main.async
     {
     success(response.result.value as! [String:Any])
     }
     
     }
     }
     else{
     if let data = response.result.value{
     let dict=data as! NSDictionary
     
     
     if statusCode == 593{
     DispatchQueue.main.async {
     failure("Forgot Password")
     }
     
     }else{
     DispatchQueue.main.async {
     failure(dict.value(forKey: "error_description") as! String)
     }
     
     }
     
     }
     }
     */
     print("")
     break
     case .failure(_):
     /*
     if let error = response.result.error{
     let str = error.localizedDescription as String
     if str.isEqual("JSON could not be serialized because of error:\nThe data couldn’t be read because it isn’t in the correct format."){
     return
     }
     DispatchQueue.main.async {
     failure(str)
     }
     
     }
     */
     print(response)
     }
     }
     catch _ {
     print(response)
     failure("JSON could not be serialized because of error:\nThe data couldn’t be read because it isn’t in the correct format.")
     // Error handling
     }
     
     }
     
     
     
     case .PUT:
     print("Api put method")
     default:
     print("other  method")
     }
     }
     static func apiDataPostMethod(url:String,parameters:[String:Any],Header:[String:String] , completion: @escaping (_ data:[String:Any]? ,  _ error:String?) -> Void)
     {
     print(url)
     print(parameters)
     
     
     //        SVProgressHUD.show()
     //        SVProgressHUD.setBorderColor(UIColor.white)
     //        SVProgressHUD.setForegroundColor(UIColor.white)
     //        SVProgressHUD.setBackgroundColor(UIColor.black)
     UIApplication.shared.isNetworkActivityIndicatorVisible = true
     
     let manager = AF.SessionManager.default
     manager.session.configuration.timeoutIntervalForRequest = 60
     
     manager.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: Header).responseJSON { (response:DataResponse<Any>) in
     
     UIApplication.shared.isNetworkActivityIndicatorVisible = false
     
     SVProgressHUD.dismiss()
     
     if response.result.isSuccess
     {
     print("Response Data: \(response)")
     
     if let data = response.result.value as? [String:Any]
     {
     completion(data , nil)
     SVProgressHUD.dismiss()
     }else{
     //Helper.Alertmessage(title: "Alert", message: (response.error?.localizedDescription)!, vc: nil)
     SVProgressHUD.dismiss()
     //   completion(nil,response.error)
     completion(nil,response.error?.localizedDescription)
     //  SVProgressHUD.showError(withStatus: response.result.error?.localizedDescription)
     }
     }
     else
     {
     //Helper.Alertmessage(title: "Alert", message: (response.error?.localizedDescription)!, vc: nil)
     SVProgressHUD.dismiss()
     print("Error \(String(describing: response.result.error))")
     print("Error \(String(describing: response.result.error?.localizedDescription))")
     // SVProgressHUD.showError(withStatus: response.result.error?.localizedDescription)
     completion(nil,response.error?.localizedDescription)
     }
     
     }
     }
     static func apiDataGetMethod2(url:String,parameters:[String:Any],Header:[String:String] , completion: @escaping (_ data:[String:Any]? ,  _ error:String?) -> Void)
     {
     print(url)
     print(parameters)
     
     
     //        SVProgressHUD.show()
     //        SVProgressHUD.setBorderColor(UIColor.white)
     //        SVProgressHUD.setForegroundColor(UIColor.white)
     //        SVProgressHUD.setBackgroundColor(UIColor.black)
     UIApplication.shared.isNetworkActivityIndicatorVisible = true
     
     let manager = AF.SessionManager.default
     manager.session.configuration.timeoutIntervalForRequest = 60
     
     manager.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: Header).responseJSON { (response:DataResponse<Any>) in
     
     UIApplication.shared.isNetworkActivityIndicatorVisible = false
     
     SVProgressHUD.dismiss()
     
     if response.result.isSuccess
     {
     print("Response Data: \(response)")
     
     if let data = response.result.value as? [String:Any]
     {
     completion(data , nil)
     SVProgressHUD.dismiss()
     }else{
     //Helper.Alertmessage(title: "Alert", message: (response.error?.localizedDescription)!, vc: nil)
     SVProgressHUD.dismiss()
     //   completion(nil,response.error)
     completion(nil,response.error?.localizedDescription)
     //  SVProgressHUD.showError(withStatus: response.result.error?.localizedDescription)
     }
     }
     else
     {
     //Helper.Alertmessage(title: "Alert", message: (response.error?.localizedDescription)!, vc: nil)
     SVProgressHUD.dismiss()
     print("Error \(String(describing: response.result.error))")
     print("Error \(String(describing: response.result.error?.localizedDescription))")
     // SVProgressHUD.showError(withStatus: response.result.error?.localizedDescription)
     completion(nil,response.error?.localizedDescription)
     }
     
     }
     }
     
     
     static func ModelApiPostMethod(url:String,parameters:[String:Any],Header:[String:String] , completion: @escaping (_ data:Data? ,  _ error:String?) -> Void)
     {
     print(url)
     print(parameters)
     print(Header)
     
     
     SVProgressHUD.show()
     SVProgressHUD.setBorderColor(UIColor.white)
     SVProgressHUD.setForegroundColor(UIColor.white)
     SVProgressHUD.setBackgroundColor(UIColor.black)
     UIApplication.shared.isNetworkActivityIndicatorVisible = true
     
     let manager = AF.SessionManager.default
     manager.session.configuration.timeoutIntervalForRequest = 60
     //manager.request(url, method:.post, parameters: parameters, encoding: URLEncoding.default ,headers: header)
     //["device-id":"123456","device-type":"iOS"]
     
     manager.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: Header).responseJSON { (response:DataResponse<Any>) in
     
     UIApplication.shared.isNetworkActivityIndicatorVisible = false
     
     SVProgressHUD.dismiss()
     
     if response.result.isSuccess
     {
     print("Response Data: \(response)")
     
     if let data = response.data as? Data
     {
     completion(data , nil)
     SVProgressHUD.dismiss()
     }else{
     //Helper.Alertmessage(title: "Alert", message: (response.error?.localizedDescription)!, vc: nil)
     SVProgressHUD.dismiss()
     completion(nil,response.error?.localizedDescription)
     print("Error \(String(describing: response.error))")
     
     // SVProgressHUD.showError(withStatus: response.result.error?.localizedDescription)
     }
     }
     else
     {
     //Helper.Alertmessage(title: "Alert", message: (response.error?.localizedDescription)!, vc: nil)
     SVProgressHUD.dismiss()
     completion(nil,response.error?.localizedDescription)
     print("Error \(String(describing: response.result.error))")
     
     print("Error \(String(describing: response.result.error))")
     
     // SVProgressHUD.showError(withStatus: response.result.error?.localizedDescription)
     
     }
     
     }
     }
     
     
     
     static func ModelApiGetMethod(url:String,Header:[String:String] , completion: @escaping (_ data:Data? ,  _ error:String?) -> Void)
     {
     print(url)
     
     print(Header)
     
     
     SVProgressHUD.show()
     SVProgressHUD.setBorderColor(UIColor.white)
     SVProgressHUD.setForegroundColor(UIColor.white)
     SVProgressHUD.setBackgroundColor(UIColor.black)
     UIApplication.shared.isNetworkActivityIndicatorVisible = true
     
     let manager = AF.SessionManager.default
     manager.session.configuration.timeoutIntervalForRequest = 60
     //manager.request(url, method:.post, parameters: parameters, encoding: URLEncoding.default ,headers: header)
     //["device-id":"123456","device-type":"iOS"]
     
     manager.request(url, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: Header).responseJSON { (response:DataResponse<Any>) in
     
     UIApplication.shared.isNetworkActivityIndicatorVisible = false
     
     SVProgressHUD.dismiss()
     
     if response.result.isSuccess
     {
     print("Response Data: \(response)")
     
     if let data = response.data as? Data
     {
     completion(data , nil)
     SVProgressHUD.dismiss()
     }else{
     //Helper.Alertmessage(title: "Alert", message: (response.error?.localizedDescription)!, vc: nil)
     SVProgressHUD.dismiss()
     completion(nil,response.error?.localizedDescription)
     // SVProgressHUD.showError(withStatus: response.result.error?.localizedDescription)
     }
     }
     else
     {
     //Helper.Alertmessage(title: "Alert", message: (response.error?.localizedDescription)!, vc: nil)
     SVProgressHUD.dismiss()
     completion(nil,response.error?.localizedDescription)
     print("Error \(String(describing: response.result.error))")
     
     print("Error \(String(describing: response.result.error))")
     
     // SVProgressHUD.showError(withStatus: response.result.error?.localizedDescription)
     
     }
     
     }
     }
     
     
     
     
     static func apiDataGetMethod(url:String , completion: @escaping (_ data:[String:Any]? ,  _ error:String?) -> Void)
     {
     print(url)
     
     SVProgressHUD.show()
     SVProgressHUD.setBorderColor(UIColor.white)
     SVProgressHUD.setForegroundColor(UIColor.white)
     SVProgressHUD.setBackgroundColor(UIColor.black)
     UIApplication.shared.isNetworkActivityIndicatorVisible = true
     
     let manager = AF.SessionManager.default
     manager.session.configuration.timeoutIntervalForRequest = 60
     
     manager.request(url, method:.get, parameters: nil, encoding: URLEncoding.default).responseJSON { (response:DataResponse<Any>) in
     
     UIApplication.shared.isNetworkActivityIndicatorVisible = false
     
     SVProgressHUD.dismiss()
     
     if response.result.isSuccess
     {
     print("Response Data: \(response)")
     
     if let data = response.result.value as? [String:Any]
     {
     completion(data , nil)
     
     }else{
     //Helper.Alertmessage(title: "Alert", message: (response.error?.localizedDescription)!, vc: nil)
     
     completion(nil,response.error?.localizedDescription)
     }
     }
     else
     {
     //Helper.Alertmessage(title: "Alert", message: (response.error?.localizedDescription)!, vc: nil)
     completion(nil,response.result.error?.localizedDescription)
     print("Error \(String(describing: response.result.error))")
     // SVProgressHUD.showError(withStatus: response.result.error?.localizedDescription)
     completion(nil,response.error?.localizedDescription)
     }
     
     }
     }
     */
    
    static func LOADERSHOW()
    {
        SVProgressHUD.show()
        SVProgressHUD.setBorderColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(APPCOLOL)
    }
    
  
}




