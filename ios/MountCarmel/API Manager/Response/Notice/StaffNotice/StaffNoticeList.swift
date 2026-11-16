//
//  StaffNoticeList.swift
//  MountCarmel
//
//  Created by Sandip on 23/08/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class StaffNoticeList: WSResponseData {
    var staffs : [String]?
    var attachments : [String]?
    var _id : String?
    var title : String?
    var text : String?
    var created_at : String?
    var start_date : String?
    var end_date : String?
    
    enum CodingKeys: String, CodingKey {
        
        case staffs = "staffs"
        case attachments = "attachments"
        case _id = "_id"
        case title = "title"
        case text = "text"
        case created_at = "created_at"
        case start_date = "start_date"
        case end_date = "end_date"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
      //  staffs = try values.decodeIfPresent([String].self, forKey: .staffs)
        attachments = try values.decodeIfPresent([String].self, forKey: .attachments)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        start_date = try values.decodeIfPresent(String.self, forKey: .start_date)
        end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
    }
    
}
