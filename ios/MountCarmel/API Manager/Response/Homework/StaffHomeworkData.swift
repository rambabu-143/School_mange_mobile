//
//  HomeworkData.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 18/08/24.
//  Copyright © 2024 Mount Carmel School. All rights reserved.
//

import Foundation

class StaffHomeworkData : WSResponseData {
    var _id : String?
    var text : String?
    var date : String?
    var attachment : String?
    var google_drive_file_id : String?
    var google_drive_link : String?
    var selected_section : Selected_Section?
    var standard_section : Selected_Section?
    var sent_by_staff : Sent_by_staff?
    var students : [String]?
    var subject_id: Subject_Name_Id?
    var created_at : String?
    var updated_at : String?

    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case text = "text"
        case date = "date"
        case attachment = "attachment"
        case google_drive_file_id = "google_drive_file_id"
        case google_drive_link = "google_drive_link"
        case selected_section = "selected_section"
        case standard_section = "standard_section"
        case sent_by_staff = "sent_by_staff"
        case students = "students"
        case subject_id = "subject_id"
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
        selected_section = try values.decodeIfPresent(Selected_Section.self, forKey: .selected_section)
        standard_section = try values.decodeIfPresent(Selected_Section.self, forKey: .standard_section)
        sent_by_staff = try values.decodeIfPresent(Sent_by_staff.self, forKey: .sent_by_staff)
        students = try values.decodeIfPresent([String].self, forKey: .students)
        subject_id = try values.decodeIfPresent(Subject_Name_Id.self, forKey: .subject_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }
}

class Selected_Section : WSResponseData {
    var _id : String?
    var id : String?
    var standard : String?
    var section : String?
    
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case id = "id"
        case standard = "standard"
        case section = "section"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        standard = try values.decodeIfPresent(String.self, forKey: .standard)
        section = try values.decodeIfPresent(String.self, forKey: .section)
    }
}

class Subject_Name_Id : WSResponseData {
    var _id : String?
    var subject_name : String?
    
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case subject_name = "subject_name"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        subject_name = try values.decodeIfPresent(String.self, forKey: .subject_name)
    }
}
