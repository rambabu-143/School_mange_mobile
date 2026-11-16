//
//  SubjectListData.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 02/08/24.
//  Copyright © 2024 Mount Carmel School. All rights reserved.
//

import Foundation

class SubjectListData : WSResponseData {
    var _id: String?
    var branch_code: UInt?
    var cbse_code_x: String?
    var cbse_code_xii: String?
    var charges_by: String? // QUARTERLY | ...
    var created_at: String?
    var exam_details: [Any]?
    var is_deleted: Bool?
    var is_mcop: Bool?
    var is_subject_divide: String?
    var is_taken: Bool?
    var name_in_ar: String?
    var order: Int?
    var school: String?
    var school_code: String?
    var session_list: [Any]?
    var short_name: String?
    var standards: [Standard_Data]?
    var subject_charge: Int?
    var subject_name: String?
    var subject_parts: [Any]?
    var subject_teacher: [Any]?
    var subject_type: String? // MAIN | ...
    var updated_at: String?
    var year_session: String? // YYYY-YY


    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case branch_code = "branch_code"
        case cbse_code_x = "cbse_code_x"
        case cbse_code_xii = "cbse_code_xii"
        case charges_by = "charges_by"
        case created_at = "created_at"
        case exam_details = "exam_details"
        case is_deleted = "is_deleted"
        case is_mcop = "is_mcop"
        case is_subject_divide = "is_subject_divide"
        case is_taken = "is_taken"
        case name_in_ar = "name_in_ar"
        case order = "order"
        case school = "school"
        case school_code = "school_code"
        case session_list = "session_list"
        case short_name = "short_name"
        case standards = "standards"
        case subject_charge = "subject_charge"
        case subject_name = "subject_name"
        case subject_parts = "subject_parts"
        case subject_teacher = "subject_teacher"
        case subject_type = "subject_type"
        case updated_at = "updated_at"
        case year_session = "year_session"
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        branch_code = try values.decodeIfPresent(UInt.self, forKey: .branch_code)
        cbse_code_x = try values.decodeIfPresent(String.self, forKey: .cbse_code_x)
        cbse_code_xii = try values.decodeIfPresent(String.self, forKey: .cbse_code_xii)
        charges_by = try values.decodeIfPresent(String.self, forKey: .charges_by)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
//        exam_details = try values.decodeIfPresent([Any].self, forKey: .exam_details)
        is_deleted = try values.decodeIfPresent(Bool.self, forKey: .is_deleted)
        is_mcop = try values.decodeIfPresent(Bool.self, forKey: .is_mcop)
        is_subject_divide = try values.decodeIfPresent(String.self, forKey: .is_subject_divide)
        is_taken = try values.decodeIfPresent(Bool.self, forKey: .is_taken)
        name_in_ar = try values.decodeIfPresent(String.self, forKey: .name_in_ar)
        order = try values.decodeIfPresent(Int.self, forKey: .order)
        school = try values.decodeIfPresent(String.self, forKey: .school)
        school_code = try values.decodeIfPresent(String.self, forKey: .school_code)
//        session_list = try values.decodeIfPresent([Any].self, forKey: .session_list)
        short_name = try values.decodeIfPresent(String.self, forKey: .short_name)
        standards = try values.decodeIfPresent([Standard_Data].self, forKey: .standards)
        subject_charge = try values.decodeIfPresent(Int.self, forKey: .subject_charge)
        subject_name = try values.decodeIfPresent(String.self, forKey: .subject_name)
//        subject_parts = try values.decodeIfPresent([Any].self, forKey: .subject_parts)
//        subject_teacher = try values.decodeIfPresent([Any].self, forKey: .subject_teacher)
        subject_type = try values.decodeIfPresent(String.self, forKey: .subject_type)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        year_session = try values.decodeIfPresent(String.self, forKey: .year_session)
    }
}

class Standard_Data : WSResponseData {
    var standard_id : Standard_ID_Data?

    enum CodingKeys: String, CodingKey {
        case standard_id = "standard_id"
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        standard_id = try values.decodeIfPresent(Standard_ID_Data.self, forKey: .standard_id)
    }
}

class Standard_ID_Data : WSResponseData {
    var _id: String?
    var name: String?
    var order_no: Int?

    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case name = "name"
        case order_no = "order_no"
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        order_no = try values.decodeIfPresent(Int.self, forKey: .order_no)
    }
}
