//
//  LoginWithOTPResponse.swift
//  MountCarmel
//
//  Created by Sandip on 27/03/21.
//  Copyright © 2021 InventionHill. All rights reserved.
//

import Foundation

class LoginWithOTPResponse : WSResponseData {
    
    var data : OTPResponseData?
    var status : Bool?
    var message : String?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case status = "status"
        case message = "message"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(OTPResponseData.self, forKey: .data)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}

class OTPResponseData : WSResponseData {
    
    var is_approved : Bool?
    var is_deleted : Bool?
    var _id : String?
    var user_id : String?
    var mobile : String?
    var otp : String?
    var valid_time : String?
    var branch_code : Int?
    var year_session : String?
    var created_at : String?
    var updated_at : String?
    var __v : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case is_approved = "is_approved"
        case is_deleted = "is_deleted"
        case _id = "_id"
        case user_id = "user_id"
        case mobile = "mobile"
        case otp = "otp"
        case valid_time = "valid_time"
        case branch_code = "branch_code"
        case year_session = "year_session"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case __v = "__v"
    }

    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        is_approved = try values.decodeIfPresent(Bool.self, forKey: .is_approved)
        is_deleted = try values.decodeIfPresent(Bool.self, forKey: .is_deleted)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        otp = try values.decodeIfPresent(String.self, forKey: .otp)
        valid_time = try values.decodeIfPresent(String.self, forKey: .valid_time)
        branch_code = try values.decodeIfPresent(Int.self, forKey: .branch_code)
        year_session = try values.decodeIfPresent(String.self, forKey: .year_session)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        __v = try values.decodeIfPresent(Int.self, forKey: .__v)
       
    }
}
