//
//  SearchStudentsAPIResponse.swift
//  MountCarmel
//
//  Created by Sandip on 08/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class SearchStudentsAPIResponse: WSResponseData {
    var status : Bool?
    var message : String?
    var data : [SearchStudentData]?
    var path : String?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
        case path = "path"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([SearchStudentData].self, forKey: .data)
        path = try values.decodeIfPresent(String.self, forKey: .path)
    }

}


class DisplinarySearchStudentsAPIResponse: WSResponseData {
    var status : Bool?
    var message : String?
    var data : SearchStudentData?
    var path : String?
    var disciplinary:DisplinaryCardCount?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
        case path = "path"
        case disciplinary = "disciplinary"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(SearchStudentData.self, forKey: .data)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        disciplinary = try values.decodeIfPresent(DisplinaryCardCount.self, forKey: .disciplinary)
    }

}

class DisplinaryCardCount: WSResponseData {
    var red : Int?
    var tardy : Int?
    var warning : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case red = "red"
        case tardy = "tardy"
        case warning = "warning"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        red = try values.decodeIfPresent(Int.self, forKey: .red)
        tardy = try values.decodeIfPresent(Int.self, forKey: .tardy)
        warning = try values.decodeIfPresent(Int.self, forKey: .warning)
    }

}
