//
//  StandardSectionData.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 02/08/24.
//  Copyright © 2024 Mount Carmel School. All rights reserved.
//

import Foundation

class StandardSectionHomeworkData : WSResponseData {
    var _id: String?
    var id: String?
    var is_class_teacher: Bool?
    var is_helper_teacher: Bool?
    var standard: String?
    var section: String?
    var branch_code: UInt?
    var created_at: String?
    var standard_id: ID_Name_Data?
    var section_id: ID_Name_Data?
    var class_teacher_id: ID_Name_Data?
    var helper_teacher_id: ID_Name_Data?
    var class_teacher_history: [ClassTeacherHistoryData]?
    var helper_teacher_history: [HelperTeacherHistoryData]?

    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case id = "id"
        case is_class_teacher = "is_class_teacher"
        case is_helper_teacher = "is_helper_teacher"
        case standard = "standard"
        case section = "section"
        case branch_code = "branch_code"
        case created_at = "created_at"
        case standard_id = "standard_id"
        case section_id = "section_id"
        case class_teacher_id = "class_teacher_id"
        case helper_teacher_id = "helper_teacher_id"
        case class_teacher_history = "class_teacher_history"
        case helper_teacher_history = "helper_teacher_history"
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        is_class_teacher = try values.decodeIfPresent(Bool.self, forKey: .is_class_teacher)
        is_helper_teacher = try values.decodeIfPresent(Bool.self, forKey: .is_helper_teacher)
        standard = try values.decodeIfPresent(String.self, forKey: .standard)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        branch_code = try values.decodeIfPresent(UInt.self, forKey: .branch_code)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        standard_id = try values.decodeIfPresent(ID_Name_Data.self, forKey: .standard_id)
        section_id = try values.decodeIfPresent(ID_Name_Data.self, forKey: .section_id)
//        class_teacher_id = try values.decodeIfPresent(ID_Name_Data.self, forKey: .class_teacher_id)
//        helper_teacher_id = try values.decodeIfPresent(ID_Name_Data.self, forKey: .helper_teacher_id)
//        class_teacher_history = try values.decodeIfPresent([ClassTeacherHistoryData].self, forKey: .class_teacher_history)
//        helper_teacher_history = try values.decodeIfPresent([HelperTeacherHistoryData].self, forKey: .helper_teacher_history)
    }
}

class ID_Name_Data : WSResponseData {
    var _id : String?
    var name : String?

    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case name = "name"
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

class HelperTeacherHistoryData : WSResponseData {
    var _id : String?
    var helper_teacher_id : String?
    var created_on : String?
    var updated_on : String?

    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case helper_teacher_id = "helper_teacher_id"
        case created_on = "created_on"
        case updated_on = "updated_on"
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        helper_teacher_id = try values.decodeIfPresent(String.self, forKey: .helper_teacher_id)
        created_on = try values.decodeIfPresent(String.self, forKey: .created_on)
        updated_on = try values.decodeIfPresent(String.self, forKey: .updated_on)
    }
}

class ClassTeacherHistoryData : WSResponseData {
    var _id : String?
    var class_teacher_id : String?
    var created_on : String?
    var updated_on : String?

    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case class_teacher_id = "class_teacher_id"
        case created_on = "created_on"
        case updated_on = "updated_on"
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        class_teacher_id = try values.decodeIfPresent(String.self, forKey: .class_teacher_id)
        created_on = try values.decodeIfPresent(String.self, forKey: .created_on)
        updated_on = try values.decodeIfPresent(String.self, forKey: .updated_on)
    }
}
