//
//  StudentWiseResponse.swift
//  MountCarmel
//
//  Created by Sandip on 19/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import Foundation

class StudentWiseResponse: WSResponseData {
    var status : Bool?
    var message : String?
    var student : WiseStudentData?
    var data : StudentWiseResponseData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case student = "student"
        case data = "data"
    }
    
    required init(from decoder: Decoder) throws {
         try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        student = try values.decodeIfPresent(WiseStudentData.self, forKey: .student)
        data = try values.decodeIfPresent(StudentWiseResponseData.self, forKey: .data)
    }

}
