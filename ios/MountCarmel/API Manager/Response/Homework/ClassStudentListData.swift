//
//  ClassStudentListData.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 02/08/24.
//  Copyright © 2024 Mount Carmel School. All rights reserved.
//

import Foundation

class ClassStudentListData: WSResponseData {
    var _id: String?
    var is_transport: Bool?
    var admission_no: String?
    var name: String?
    var standard_id: String?
    var standard_section_id: StandardSection?
    var date_of_admission: String?
    var email: String?
    var gender: String?
    var sms_mobile: String?
    var house_id: House?
    var profile_pic: String?
    var studentImg: String?
    var combo_id: Combo?
    var prev_admission_no: String?
    var wise: Wise?
    var disciplinary: Disciplinary?
    var attendance_data: AttendanceData?

    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case is_transport = "is_transport"
        case admission_no = "admission_no"
        case name = "name"
        case standard_id = "standard_id"
        case standard_section_id = "standard_section_id"
        case date_of_admission = "date_of_admission"
        case email = "email"
        case gender = "gender"
        case sms_mobile = "sms_mobile"
        case house_id = "house_id"
        case profile_pic = "profile_pic"
        case studentImg = "studentImg"
        case combo_id = "combo_id"
        case prev_admission_no = "prev_admission_no"
        case wise = "wise"
        case disciplinary = "disciplinary"
        case attendance_data = "attendance_data"
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        is_transport = try values.decodeIfPresent(Bool.self, forKey: .is_transport)
        admission_no = try values.decodeIfPresent(String.self, forKey: .admission_no)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        standard_id = try values.decodeIfPresent(String.self, forKey: .standard_id)
        standard_section_id = try values.decodeIfPresent(StandardSection.self, forKey: .standard_section_id)
        date_of_admission = try values.decodeIfPresent(String.self, forKey: .date_of_admission)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        sms_mobile = try values.decodeIfPresent(String.self, forKey: .sms_mobile)
//        house_id = try values.decodeIfPresent(House.self, forKey: .house_id)
        profile_pic = try values.decodeIfPresent(String.self, forKey: .profile_pic)
        studentImg = try values.decodeIfPresent(String.self, forKey: .studentImg)
//        combo_id = try values.decodeIfPresent(Combo.self, forKey: .combo_id)
        prev_admission_no = try values.decodeIfPresent(String.self, forKey: .prev_admission_no)
//        wise = try values.decodeIfPresent(Wise.self, forKey: .wise)
//        disciplinary = try values.decodeIfPresent(Disciplinary.self, forKey: .disciplinary)
//        attendance_data = try values.decodeIfPresent(AttendanceData.self, forKey: .attendance_data)
    }
}

class StandardSection: WSResponseData {
    var _id: String?
    var standard: String?
    var section: String?
    var id: String?

    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case standard = "standard"
        case section = "section"
        case id = "id"
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        standard = try values.decodeIfPresent(String.self, forKey: .standard)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }
    
    public override func encode(to encoder: any Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(standard, forKey: .standard)
        try container.encode(section, forKey: .section)
        try container.encode(id, forKey: .id)
    }
}

class House: WSResponseData {
    var house_incharge_id: [ID_Name_Data]?
    var _id: String?
    var house_no: String?

    enum CodingKeys: String, CodingKey {
        case house_incharge_id = "house_incharge_id"
        case _id = "_id"
        case house_no = "house_no"
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        house_no = try values.decodeIfPresent(String.self, forKey: .house_no)
        house_incharge_id = try values.decodeIfPresent([ID_Name_Data].self, forKey: .house_incharge_id)
    }
}

class Combo: WSResponseData {
    var subjects: [String]?
    var sections: [String]?
    var standard_sections: [Any]?
    var _id: String?
    var name: String?
    var prev_combo_id: String?
    var standard_id: String?
    var order: Int?
    var branch_code: Int?

    enum CodingKeys: String, CodingKey {
        case subjects = "subjects"
        case sections = "sections"
        case standard_sections = "standard_sections"
        case _id = "_id"
        case name = "name"
        case prev_combo_id = "prev_combo_id"
        case standard_id = "standard_id"
        case order = "order"
        case branch_code = "branch_code"
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        subjects = try values.decodeIfPresent([String].self, forKey: .subjects)
        sections = try values.decodeIfPresent([String].self, forKey: .sections)
//        standard_sections = try values.decodeIfPresent([Any].self, forKey: .standard_sections)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        prev_combo_id = try values.decodeIfPresent(String.self, forKey: .prev_combo_id)
        standard_id = try values.decodeIfPresent(String.self, forKey: .standard_id)
        order = try values.decodeIfPresent(Int.self, forKey: .order)
        branch_code = try values.decodeIfPresent(Int.self, forKey: .branch_code)
    }
}

class Wise: WSResponseData {
    var total: Int?

    enum CodingKeys: String, CodingKey {
        case total = "total"
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }
}

class Disciplinary: WSResponseData {
    var total: Int?
    var pink: Int?
    var yellow: Int?
    var red: Int?

    enum CodingKeys: String, CodingKey {
        case total = "total"
        case pink = "pink"
        case yellow = "yellow"
        case red = "red"
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        pink = try values.decodeIfPresent(Int.self, forKey: .pink)
        yellow = try values.decodeIfPresent(Int.self, forKey: .yellow)
        red = try values.decodeIfPresent(Int.self, forKey: .red)
    }
}

class AttendanceData: WSResponseData {
    var today_attendance: String?
    var total_days: Int?
    var total_present: Float?
    var total_absent: Float?

    enum CodingKeys: String, CodingKey {
        case today_attendance = "today_attendance"
        case total_days = "total_days"
        case total_present = "total_present"
        case total_absent = "total_absent"
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        today_attendance = try values.decodeIfPresent(String.self, forKey: .today_attendance)
        total_days = try values.decodeIfPresent(Int.self, forKey: .total_days)
        total_present = try values.decodeIfPresent(Float.self, forKey: .total_present)
        total_absent = try values.decodeIfPresent(Float.self, forKey: .total_absent)
    }
}
