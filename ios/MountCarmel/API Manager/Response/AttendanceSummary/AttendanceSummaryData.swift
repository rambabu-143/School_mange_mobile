//
//  AttendanceSummaryData.swift
//  MountCarmel
//
//  Created by Sandip on 22/08/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class AttendanceSummaryData: WSResponseData {
    var branch_code : [Int]?
    var _id : String?
    var standard : String?
    var section : String?
    var standard_id : String?
    var section_id : String?
    var created_at : String?
    //let class_teacher_id : Class_teacher_id?
    var helper_teacher_id : String?
    var total_student : Int?
    var is_attendance_marked : Bool?
    var attendance_marked_at : String?
    var students : [SummaryStudents]?
    var total_absent : Int?
    var is_attendance_sms_sent : Bool?
    var is_holiday : Bool?
    var id : String?
    
    enum CodingKeys: String, CodingKey {
        
        case branch_code = "branch_code"
        case _id = "_id"
        case standard = "standard"
        case section = "section"
        case standard_id = "standard_id"
        case section_id = "section_id"
        case created_at = "created_at"
       // case class_teacher_id = "class_teacher_id"
        case helper_teacher_id = "helper_teacher_id"
        case total_student = "total_student"
        case is_attendance_marked = "is_attendance_marked"
        case attendance_marked_at = "attendance_marked_at"
        case students = "students"
        case total_absent = "total_absent"
        case is_attendance_sms_sent = "is_attendance_sms_sent"
        case is_holiday = "is_holiday"
        case id = "id"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
      //  branch_code = try values.decodeIfPresent([Int].self, forKey: .branch_code)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        standard = try values.decodeIfPresent(String.self, forKey: .standard)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        standard_id = try values.decodeIfPresent(String.self, forKey: .standard_id)
        section_id = try values.decodeIfPresent(String.self, forKey: .section_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
      //  class_teacher_id = try values.decodeIfPresent(Class_teacher_id.self, forKey: .class_teacher_id)
        helper_teacher_id = try values.decodeIfPresent(String.self, forKey: .helper_teacher_id)
        total_student = try values.decodeIfPresent(Int.self, forKey: .total_student)
        is_attendance_marked = try values.decodeIfPresent(Bool.self, forKey: .is_attendance_marked)
        attendance_marked_at = try values.decodeIfPresent(String.self, forKey: .attendance_marked_at)
        students = try values.decodeIfPresent([SummaryStudents].self, forKey: .students)
        total_absent = try values.decodeIfPresent(Int.self, forKey: .total_absent)
        is_attendance_sms_sent = try values.decodeIfPresent(Bool.self, forKey: .is_attendance_sms_sent)
        is_holiday = try values.decodeIfPresent(Bool.self, forKey: .is_holiday)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }
    
}
