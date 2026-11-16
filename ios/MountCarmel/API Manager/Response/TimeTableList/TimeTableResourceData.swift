//
//  TimeTableResourceData.swift
//  MountCarmel
//
//  Created by Sandip on 26/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class TimeTableResourceData: WSResponseData {
    var classval : String?
    var section : String?
    var monday : [WeekDayData]?
    var tuesday : [WeekDayData]?
    var wednesday : [WeekDayData]?
    var thursday : [WeekDayData]?
    var friday : [WeekDayData]?
    var saturday : [WeekDayData]?
    var sunday : [WeekDayData]?
    
    enum CodingKeys: String, CodingKey {
        
        case classval = "class"
        case section = "section"
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
        case saturday = "Saturday"
        case sunday = "Sunday"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        classval = try values.decodeIfPresent(String.self, forKey: .classval)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        monday = try values.decodeIfPresent([WeekDayData].self, forKey: .monday)
        tuesday = try values.decodeIfPresent([WeekDayData].self, forKey: .tuesday)
        wednesday = try values.decodeIfPresent([WeekDayData].self, forKey: .wednesday)
        thursday = try values.decodeIfPresent([WeekDayData].self, forKey: .thursday)
        friday = try values.decodeIfPresent([WeekDayData].self, forKey: .friday)
        saturday = try values.decodeIfPresent([WeekDayData].self, forKey: .saturday)
        sunday = try values.decodeIfPresent([WeekDayData].self, forKey: .sunday)
        
    }
}

