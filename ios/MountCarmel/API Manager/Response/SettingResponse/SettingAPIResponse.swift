//
//  SettingAPIResponse.swift
//  MountCarmel
//
//  Created by Sandip on 15/08/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class SettingAPIResponse: WSResponseData {
    var status : Bool?
    var message : String?
    var data : [SettingData]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([SettingData].self, forKey: .data)
    }
    
}

class SettingData : WSResponseData {
    var name : String?
    var status : Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case status = "status"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
    }
    
}
class SwitchSchoolMetaData:WSResponseData{
   var token:String?
    
    enum CodingKeys: String, CodingKey {
        case token
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(token, forKey: .token)
    }
}

class SwitchSchoolModel:WSResponseData{
    var message:String?
    var status:Bool?
    var meta_data:SwitchSchoolMetaData?
   // var user : SwitchTokenModel?
        
    enum CodingKeys: String, CodingKey {
        case message
        case meta_data
        case status
       // case user
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        meta_data = try values.decodeIfPresent(SwitchSchoolMetaData.self, forKey: .meta_data)
       // user = try values.decodeIfPresent(SwitchTokenModel.self, forKey: .user)
    }
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
        try container.encode(status, forKey: .status)
        try container.encode(meta_data, forKey: .meta_data)
       // try container.encode(user, forKey: .user)
    }
}

class SwitchTokenModel : WSResponseData {
    var tokens : [LoginAPIToken]?
    enum CodingKeys: String, CodingKey {
        case tokens = "tokens"
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        tokens = try values.decodeIfPresent([LoginAPIToken].self, forKey: .tokens)
    }
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tokens, forKey: .tokens)
    }
}
