//
//  NotificationModel.swift
//  Tosstra
//
//  Created by Eweb on 10/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import Foundation

struct NotificationModel : Codable {

        let code : String?
        let data : [NotiDatum]?
        let message : String?
        let status : String?

        enum CodingKeys: String, CodingKey {
                case code = "code"
                case data = "data"
                case message = "message"
                case status = "status"
        }

}

struct NotiDatum : Codable {

        let createdAt : String?
        let dispatcherId : String?
        let driverId : String?
        let event : String?
        let id : String?
        let message : String?
        let type : String?
        let updatedAt : String?
    let notificationTime : String?
let jobId : String?
     let notificationDate : String?
    
        enum CodingKeys: String, CodingKey {
                case createdAt = "created_at"
                case dispatcherId = "dispatcherId"
                case driverId = "driverId"
                case event = "event"
                case id = "id"
                case message = "message"
                case type = "type"
                case updatedAt = "updated_at"
             case notificationTime = "notificationTime"
             case jobId = "jobId"
            case notificationDate = "notificationDate"
            
        }
    


}
