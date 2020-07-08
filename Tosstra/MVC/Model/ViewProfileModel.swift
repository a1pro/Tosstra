//
//  ViewProfileModel.swift
//  Tosstra
//
//  Created by Eweb on 06/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import Foundation
struct ViewProfileModel : Codable {

        let code : String?
        let status : String?
     let message : String?
    
        let data : [ViewProfileDatum]?

        enum CodingKeys: String, CodingKey {
                case code = "code"
                case status = "status"
                case message = "message"
                case data = "data"
        }
    
    
}
struct ViewProfileDatum : Codable {

        let id : String?
        let firstName : String?
        let lastName : String?
        let address : String?
        let profileImg : String?
        let companyName : String?
        let email : String?
        let password : String?
        let dotNumber : String?
        let deviceId : String?
        let deviceType : String?
        let otp : String?
        let verifiedStatus : String?
        let userType : String?
        let subUserType : String?
        let phone : String?
        let createdAt : String?
        let updatedAt : String?
     let onlineStatus : String?

        enum CodingKeys: String, CodingKey {
                case id = "id"
                case firstName = "firstName"
                case lastName = "lastName"
                case address = "address"
                case profileImg = "profileImg"
                case companyName = "companyName"
                case email = "email"
                case password = "password"
                case dotNumber = "dotNumber"
                case deviceId = "deviceId"
                case deviceType = "deviceType"
                case otp = "otp"
                case verifiedStatus = "verifiedStatus"
                case userType = "userType"
                case subUserType = "SubUserType"
                case phone = "phone"
                case createdAt = "created_at"
                case updatedAt = "updated_at"
            case onlineStatus = "onlineStatus"
        }
    
      
}
