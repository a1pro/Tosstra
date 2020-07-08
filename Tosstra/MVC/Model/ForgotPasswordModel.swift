//
//  ForgotPasswordModel.swift
//  Tosstra
//
//  Created by Eweb on 07/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import Foundation

struct ForgotPasswordModel : Codable {

        let code : String?
        let message : String?
        let status : String?
        let otp : String?
        enum CodingKeys: String, CodingKey {
                case code = "code"
                case message = "message"
                case status = "status"
            case otp = "otp"
        }
    
}
