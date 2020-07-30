//
//  JobModel.swift
//  Tosstra
//
//  Created by Eweb on 09/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import Foundation

struct JobModel : Codable {

        let code : String?
        let status : String?
        let message : String?
        let data : [JobDatum]?

        enum CodingKeys: String, CodingKey {
                case code = "code"
                case status = "status"
                case message = "message"
                case data = "data"
        }
   
}

struct JobDatum : Codable {

         let jobId : String?
              let dispatcherId : String?
              let driverId : String?
              let workStartStatus : String?
              let rateType : String?
              let rate : String?
              let pupStreet : String?
              let pupCity : String?
              let pupState : String?
              let pupZipcode : String?
              let drpStreet : String?
              let drpCity : String?
              let drpState : String?
              let drpZipcode : String?
              let dateFrom : String?
              let dateTo : String?
              let startTime : String?
              let endTime : String?
              let additinalInstructions : String?
              let createdAt : String?
              let updatedAt : String?
              let firstName : String?
              let lastName : String?
              let address : String?
              let profileImg : String?
              let companyName : String?
              let email : String?
              let dotNumber : String?
              let latitude : String?
              let longitude : String?
              let userType : String?
              let subUserType : String?
              let phone : String?
              let onlineStatus : String?
                let puplatitude : String?
                 let puplongitude : String?
                 let drplatitude : String?
                 let drplongitude : String?
               let jobStatus : String?
     let jobStartStatus : String?

              enum CodingKeys: String, CodingKey {
                      case jobId = "jobId"
                      case dispatcherId = "dispatcherId"
                      case driverId = "driverId"
                      case workStartStatus = "workStartStatus"
                      case rateType = "rateType"
                      case rate = "rate"
                      case pupStreet = "pupStreet"
                      case pupCity = "pupCity"
                      case pupState = "pupState"
                      case pupZipcode = "pupZipcode"
                      case drpStreet = "drpStreet"
                      case drpCity = "drpCity"
                      case drpState = "drpState"
                      case drpZipcode = "drpZipcode"
                      case dateFrom = "dateFrom"
                      case dateTo = "dateTo"
                      case startTime = "startTime"
                      case endTime = "endTime"
                      case additinalInstructions = "additinal_Instructions"
                      case createdAt = "created_at"
                      case updatedAt = "updated_at"
                      case firstName = "firstName"
                      case lastName = "lastName"
                      case address = "address"
                      case profileImg = "profileImg"
                      case companyName = "companyName"
                      case email = "email"
                      case dotNumber = "dotNumber"
                      case latitude = "latitude"
                      case longitude = "longitude"
                      case userType = "userType"
                      case subUserType = "SubUserType"
                      case phone = "phone"
                      case onlineStatus = "onlineStatus"
                case puplatitude = "puplatitude"
                case puplongitude = "puplongitude"
                case drplatitude = "drplatitude"
                case drplongitude = "drplongitude"
                case jobStatus = "jobStatus"
                 case jobStartStatus = "jobStartStatus"
                
                
              }


}
