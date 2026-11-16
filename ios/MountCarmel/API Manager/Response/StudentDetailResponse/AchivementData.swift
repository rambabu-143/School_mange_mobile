//
//  AchivementData.swift
//  MountCarmel
//
//  Created by Sandip on 25/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class AchivementData: WSResponseData {
    var coscholastic : [AchivementDataType]?
    var scholastic : AchivementDataType?
   
    
    enum CodingKeys: String, CodingKey {
        
        case coscholastic = "coscholastic"
        case scholastic = "scholastic"
       
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coscholastic = try values.decodeIfPresent([AchivementDataType].self, forKey: .coscholastic)
        scholastic = try values.decodeIfPresent(AchivementDataType.self, forKey: .scholastic)
        
    }
    
}

class AchivementDataType: WSResponseData {
    var _id : String?
    var name : String?
    var message1 : String?
    var message2 : String?
    var bg_color : String?
   
    
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case name = "name"
        case message1 = "message1"
        case message2 = "message2"
        
        
        
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        message1 = try values.decodeIfPresent(String.self, forKey: .message1)
        message2 = try values.decodeIfPresent(String.self, forKey: .message2)
        
        
    }
    
}

