//
//  ClassListApiResponse.swift
//  MountCarmel
//
//  Created by Sandip on 25/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class ClassListApiResponse: WSResponseData {
    var data : [ClassListWithSectionData]?
    var message : String?
    var status :Bool?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([ClassListWithSectionData].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
    }
}

class CalenderStartDateApiResponse: Codable {
    var data : StartDateData?
    var message : String?
    var status :Bool?
        
}

class StartDateData: Codable {
    var end_date : String?
    var start_date : String?
    
}
/*  {
      "status": true,
      "message": "Term Retrieved Successfully",
      "data": {
          "is_deleted": false,
          "_id": "623c58dab4edf504277aa2e7",
          "created_at": "2017-03-29T05:47:23.500Z",
          "end_date": "2023-03-31T18:29:00.000Z",
          "start_date": "2022-10-01T03:30:00.000Z",
          "term_session": "2",
          "updated_at": "2017-03-29T05:47:23.500Z",
          "year_session": "2022-23"
      }
  }*/
