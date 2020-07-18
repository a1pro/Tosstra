//
//  JobDetailMedel.swift
//  Tosstra
//
//  Created by Eweb on 14/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import Foundation
struct JobDetailMedel : Codable {

        let code : String?
        let data : [JobDatum2]?
        let status : String?
let message : String?
        enum CodingKeys: String, CodingKey {
                case code = "code"
                case data = "data"
                case status = "status"
            case message = "message"
        }
  

}

struct JobDatum2 : Codable {

        let additinalInstructions : String?
        let address : String?
        let companyName : String?
        let createdAt : String?
        let dateFrom : String?
        let dateTo : String?
        let dispatcherId : String?
        let dotNumber : String?
        let driverId : String?
        let drpCity : String?
        let drpState : String?
        let drpStreet : String?
        let drpZipcode : String?
        let email : String?
        let endTime : String?
        let firstName : String?
        let jobCompleteStatus : String?
        let jobId : String?
        let lastName : String?
        let latitude : String?
        let longitude : String?
        let offerForSelectedDrivers : String?
        let onlineStatus : String?
        let phone : String?
        let profileImg : String?
        let pupCity : String?
        let pupState : String?
        let pupStreet : String?
        let pupZipcode : String?
        let rate : String?
        let rateType : String?
        let startTime : String?
        let subUserType : String?
        let updatedAt : String?
        let userType : String?
        let workStartStatus : String?

        enum CodingKeys: String, CodingKey {
                case additinalInstructions = "additinal_Instructions"
                case address = "address"
                case companyName = "companyName"
                case createdAt = "created_at"
                case dateFrom = "dateFrom"
                case dateTo = "dateTo"
                case dispatcherId = "dispatcherId"
                case dotNumber = "dotNumber"
                case driverId = "driverId"
                case drpCity = "drpCity"
                case drpState = "drpState"
                case drpStreet = "drpStreet"
                case drpZipcode = "drpZipcode"
                case email = "email"
                case endTime = "endTime"
                case firstName = "firstName"
                case jobCompleteStatus = "jobCompleteStatus"
                case jobId = "jobId"
                case lastName = "lastName"
                case latitude = "latitude"
                case longitude = "longitude"
                case offerForSelectedDrivers = "offerForSelectedDrivers"
                case onlineStatus = "onlineStatus"
                case phone = "phone"
                case profileImg = "profileImg"
                case pupCity = "pupCity"
                case pupState = "pupState"
                case pupStreet = "pupStreet"
                case pupZipcode = "pupZipcode"
                case rate = "rate"
                case rateType = "rateType"
                case startTime = "startTime"
                case subUserType = "SubUserType"
                case updatedAt = "updated_at"
                case userType = "userType"
                case workStartStatus = "workStartStatus"
        }
    

}
