//
//  LogBookModel.swift
//  Tosstra
//
//  Created by Eweb on 15/10/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import Foundation
struct LogBookModel : Codable {

        let code : String?
        let data : [BookDatum]?
        let status : String?
      let message : String?
        enum CodingKeys: String, CodingKey {
                case code = "code"
                case data = "data"
                case status = "status"
             case message = "message"
        }
    
    
}
struct BookDatum : Codable {

        let address : String?
        let companyName : String?
        let createdAt : String?
        let dateTime : String?
        let dateTimeD : String?
        let dateTimeM : String?
        let driverId : String?
        let driverSignature : String?
        let driverSignature2 : String?
        let id : String?
        let logBookCheckBox : [String]?
        let mechanicSignature : String?
        let odometerReading : String?
        let remarks : String?
        let trailer : String?
        let truckNumber : String?
        let updatedAt : String?
    let logBookTime : String?

        enum CodingKeys: String, CodingKey {
                case address = "address"
                case companyName = "companyName"
                case createdAt = "created_at"
                case dateTime = "dateTime"
                case dateTimeD = "dateTimeD"
                case dateTimeM = "dateTimeM"
                case driverId = "driverId"
                case driverSignature = "driverSignature"
                case driverSignature2 = "driverSignature2"
                case id = "id"
                case logBookCheckBox = "logBookCheckBox"
                case mechanicSignature = "mechanicSignature"
                case odometerReading = "odometerReading"
                case remarks = "remarks"
                case trailer = "trailer"
                case truckNumber = "truckNumber"
                case updatedAt = "updated_at"
            case logBookTime = "logBookTime"
            
        }
    
    
}
