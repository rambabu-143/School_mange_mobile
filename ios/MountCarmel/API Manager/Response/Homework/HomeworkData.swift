//
//  HomeworkData.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 13/07/24.
//  Copyright © 2024 Mount Carmel School. All rights reserved.
//

import Foundation

class HomeworkData : WSResponseData {
    var _id : String?
    var text : String?
    var date : String?
    var attachment : String?
    var google_drive_file_id : String?
    var google_drive_link : String?
    var sent_by_staff : Sent_by_staff?
    var created_at : String?
    var updated_at : String?

    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case text = "text"
        case date = "date"
        case attachment = "attachment"
        case google_drive_file_id = "google_drive_file_id"
        case google_drive_link = "google_drive_link"
        case sent_by_staff = "sent_by_staff"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        attachment = try values.decodeIfPresent(String.self, forKey: .attachment)
        google_drive_file_id = try values.decodeIfPresent(String.self, forKey: .google_drive_file_id)
        google_drive_link = try values.decodeIfPresent(String.self, forKey: .google_drive_link)
        sent_by_staff = try values.decodeIfPresent(Sent_by_staff.self, forKey: .sent_by_staff)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }
}
