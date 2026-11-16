//
//  StudentDetailAPIResponse.swift
//  MountCarmel
//
//  Created by Sandip on 25/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class StudentDetailAPIResponse: WSResponseData {
    var status : Bool?
    var message : String?
    var data : StudentDetailData?
    var path : String?
    var promoted_class:String?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
        case path = "path"
        case promoted_class = "promoted_class"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        promoted_class = try values.decodeIfPresent(String.self, forKey: .promoted_class)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        data = try values.decodeIfPresent(StudentDetailData.self, forKey: .data)
    }
    
}

struct TransportRenewbleModel:Codable{
    var status : Bool?
    var message : String?
    //var data : StudentDetailData?
    var path : String?
    var promoted_class:String?
    var next_year_session:String?
    var branch_details:TransportBranchDetails?
}

struct TransportBranchDetails:Codable{
    let branch_address:String?
}
