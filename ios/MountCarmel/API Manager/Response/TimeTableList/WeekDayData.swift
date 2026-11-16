//
//  WeekDayData.swift
//  MountCarmel
//
//  Created by Sandip on 26/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class WeekDayData: WSResponseData {
    var classVal : String?
    var section : String?
    var day : String?
    var subject : String?
    var start_time : String?
    var start_at : String?
    var end_time : String?
    var end_at : String?
    
    enum CodingKeys: String, CodingKey {
        
        case classVal = "class"
        case section = "section"
        case day = "day"
        case subject = "subject"
        case start_time = "start_time"
        case start_at = "start_at"
        case end_time = "end_time"
        case end_at = "end_at"
    }

    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        classVal = try values.decodeIfPresent(String.self, forKey: .classVal)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        day = try values.decodeIfPresent(String.self, forKey: .day)
        subject = try values.decodeIfPresent(String.self, forKey: .subject)
        start_time = try values.decodeIfPresent(String.self, forKey: .start_time)
        start_at = try values.decodeIfPresent(String.self, forKey: .start_at)
        end_time = try values.decodeIfPresent(String.self, forKey: .end_time)
        end_at = try values.decodeIfPresent(String.self, forKey: .end_at)
        
    }
}

