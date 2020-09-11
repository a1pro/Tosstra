//
//  DiverProfileModel.swift
//  Tosstra
//
//  Created by Eweb on 11/09/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import Foundation


struct DiverProfileModel : Codable {

        let code : String?
        let status : String?
    let message : String?
        let data : [DriverUserDatum]?
        let payment : [DriverPayment]?

        enum CodingKeys: String, CodingKey {
                case code = "code"
                case status = "status"
                 case message = "message"
                case data = "data"
                case payment = "payment"
        }

}
struct DriverPayment : Codable {

        let pId : String?
        let userId : String?
        let paymentId : String?
        let paymentStatus : String?
        let amount : String?
        let plan : String?
        let purchaseDate : String?
        let expiryDate : String?
        let createdAt : String?
        let updatedAt : String?

        enum CodingKeys: String, CodingKey {
                case pId = "p_id"
                case userId = "user_id"
                case paymentId = "payment_id"
                case paymentStatus = "payment_status"
                case amount = "amount"
                case plan = "plan"
                case purchaseDate = "purchaseDate"
                case expiryDate = "expiryDate"
                case createdAt = "created_at"
                case updatedAt = "updated_at"
        }
   
}
struct DriverUserDatum : Codable {

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
        let timeZone : String?
        let latitude : String?
        let longitude : String?
        let otp : String?
        let verifiedStatus : String?
        let userType : String?
        let subUserType : String?
        let phone : String?
        let onlineStatus : String?
        let createdAt : String?
        let updatedAt : String?

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
                case timeZone = "timeZone"
                case latitude = "latitude"
                case longitude = "longitude"
                case otp = "otp"
                case verifiedStatus = "verifiedStatus"
                case userType = "userType"
                case subUserType = "SubUserType"
                case phone = "phone"
                case onlineStatus = "onlineStatus"
                case createdAt = "created_at"
                case updatedAt = "updated_at"
        }
    

}
