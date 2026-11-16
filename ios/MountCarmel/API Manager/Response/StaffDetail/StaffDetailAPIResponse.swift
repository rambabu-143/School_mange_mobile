//
//  StaffDetailAPIResponse.swift
//  MountCarmel
//
//  Created by Sandip on 23/08/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class StaffDetailAPIResponse: WSResponseData {
    var status : Bool?
    var message : String?
    var data : LoginAPIStaffId_Separate?
    var path : String?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
        case path = "path"
        
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(LoginAPIStaffId_Separate.self, forKey: .data)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        
    }
}


class LoginAPIStaffId_Separate : WSResponseData {
    
    var ID : String?
    var address : LoginAPIAddres?
    
    var createdAt : String?
    var dateOfBirth : String?
    var dateOfJoining : String?
    var departmentId : LoginAPIDepartmentId?
    var email : String?
    var employeeCode : String?
    var firstName : String?
    var name : String?
    var isDeleted : Bool?
    var isTeacher : Bool?
    var isTransport : Bool?
    var isHouseTeacher : Bool?
    var isClassTeacher : Bool?
    var isHaveStudents : Bool?
    var lastName : String?
    var mobile : String?
    var phone : String?
    var qualification : String?
   // var qualification : [LoginAPIQualification]?
    var salutation : String?
    var schoolCode : String?
    var branch_code : Int?
    var schoolNote : String?
    var staffType : String?
    var staffroomId : LoginAPIStaffroomId?
    var status : Bool?
    var transportId : LoginAPITransportId?
    var updatedAt : String?
    var classTeacherID : LoginAPIClassTeacherID?
    var houseTeacherID: LoginAPIHouseTeacherID?
    var spousename : String?
    var dateofanniversary : String?
    var profile_pic : String?
    var emergency_mobile : String?
    var emergency_name : String?
    var transport_bill_id: Transport_bill_id?
    var default_year_session : String?
    var years : [StaffYearsModal]?
    var students : [StudentsData]?
   
   
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case address
        case createdAt = "created_at"
        case dateOfBirth = "date_of_birth"
        case dateOfJoining = "date_of_joining"
        case departmentId = "department_id"
        case email = "email"
        case employeeCode = "employee_code"
        case firstName = "first_name"
        case isDeleted = "is_deleted"
        case isTeacher = "is_teacher"
        case isTransport = "is_transport"
        case isHouseTeacher = "is_house_teacher"
        case isClassTeacher = "is_class_teacher"
        case isHaveStudents = "have_students"
        case lastName = "last_name"
        case mobile = "mobile"
        case phone = "phone"
        case qualification = "qualification"
        case salutation = "salutation"
        case schoolCode = "school_code"
        case branch_code = "branch_code"
        case schoolNote = "school_note"
        case staffType = "staff_type"
        case classTeacherID = "class_teacher_id"
        case houseTeacherID = "house_teacher_id"
        case staffroomId = "staffroom_id"
        case status = "status"
        case transportId = "transport_id"
        case updatedAt = "updated_at"
        case spousename = "spouse_name"
        case dateofanniversary = "date_of_anniversary"
        case profile_pic = "profile_pic"
        case name = "name"
        case emergency_mobile = "emergency_mobile"
        case emergency_name = "emergency_name"
        case transport_bill_id = "transport_bill_id"
        case default_year_session = "default_year_session"
        case years = "years"
        case students = "students"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ID = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        emergency_mobile = try values.decodeIfPresent(String.self, forKey: .emergency_mobile)
        emergency_name = try values.decodeIfPresent(String.self, forKey: .emergency_name)
        address = try values.decodeIfPresent(LoginAPIAddres.self, forKey: .address)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        dateOfBirth = try values.decodeIfPresent(String.self, forKey: .dateOfBirth)
        dateOfJoining = try values.decodeIfPresent(String.self, forKey: .dateOfJoining)
        departmentId = try values.decodeIfPresent(LoginAPIDepartmentId.self, forKey: .departmentId)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        employeeCode = try values.decodeIfPresent(String.self, forKey: .employeeCode)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted)
        isTeacher = try values.decodeIfPresent(Bool.self, forKey: .isTeacher)
        isHouseTeacher = try values.decodeIfPresent(Bool.self, forKey: .isHouseTeacher)
        isClassTeacher = try values.decodeIfPresent(Bool.self, forKey: .isClassTeacher)
        isHaveStudents = try values.decodeIfPresent(Bool.self, forKey: .isHaveStudents)
        
        isTransport = try values.decodeIfPresent(Bool.self, forKey: .isTransport)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        qualification = try values.decodeIfPresent(String.self, forKey: .qualification)
        salutation = try values.decodeIfPresent(String.self, forKey: .salutation)
        branch_code = try values.decodeIfPresent(Int.self, forKey: .branch_code)
        schoolCode = try values.decodeIfPresent(String.self, forKey: .schoolCode)
        schoolNote = try values.decodeIfPresent(String.self, forKey: .schoolNote)
        staffType = try values.decodeIfPresent(String.self, forKey: .staffType)
        staffroomId = try values.decodeIfPresent(LoginAPIStaffroomId.self, forKey: .staffroomId)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        transportId = try values.decodeIfPresent(LoginAPITransportId.self, forKey: .transportId)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        classTeacherID = try values.decodeIfPresent(LoginAPIClassTeacherID.self, forKey: .classTeacherID)
        houseTeacherID = try values.decodeIfPresent(LoginAPIHouseTeacherID.self, forKey: .houseTeacherID)
        
        spousename = try values.decodeIfPresent(String.self, forKey: .spousename)
        dateofanniversary = try values.decodeIfPresent(String.self, forKey: .dateofanniversary)
        profile_pic = try values.decodeIfPresent(String.self, forKey: .profile_pic)
        transport_bill_id = try values.decodeIfPresent(Transport_bill_id.self, forKey: .transport_bill_id)
        default_year_session = try values.decodeIfPresent(String.self, forKey: .default_year_session)
        years = try values.decodeIfPresent([StaffYearsModal].self, forKey: .years)
        students = try values.decodeIfPresent([StudentsData].self, forKey: .students)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ID, forKey: .id)
        try container.encode(address, forKey: .address)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(dateOfBirth, forKey: .dateOfBirth)
        try container.encode(dateOfJoining, forKey: .dateOfJoining)
        try container.encode(departmentId, forKey: .departmentId)
        try container.encode(email, forKey: .email)
        try container.encode(employeeCode, forKey: .employeeCode)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(isDeleted, forKey: .isDeleted)
        try container.encode(isTeacher, forKey: .isTeacher)
        try container.encode(isTransport, forKey: .isTransport)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(mobile, forKey: .mobile)
        try container.encode(phone, forKey: .phone)
        try container.encode(emergency_mobile, forKey: .emergency_mobile)
        try container.encode(emergency_name, forKey: .emergency_name)
        
        try container.encode(qualification, forKey: .qualification)
        try container.encode(salutation, forKey: .salutation)
        try container.encode(branch_code, forKey: .branch_code)
        try container.encode(schoolCode, forKey: .schoolCode)
        try container.encode(schoolNote, forKey: .schoolNote)
        try container.encode(staffType, forKey: .staffType)
        try container.encode(staffroomId, forKey: .staffroomId)
        try container.encode(status, forKey: .status)
        try container.encode(transportId, forKey: .transportId)
        try container.encode(classTeacherID, forKey: .classTeacherID)
        try container.encode(houseTeacherID, forKey: .houseTeacherID)
        try container.encode(isClassTeacher, forKey: .isClassTeacher)
        try container.encode(isHouseTeacher, forKey: .isHouseTeacher)
        try container.encode(transportId, forKey: .transportId)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(spousename, forKey: .spousename)
        
        try container.encode(dateofanniversary, forKey: .dateofanniversary)
        try container.encode(profile_pic, forKey: .profile_pic)
        try container.encode(transport_bill_id, forKey: .transport_bill_id)
        try container.encode(default_year_session, forKey: .default_year_session)
        try container.encode(years, forKey: .years)
        try container.encode(students, forKey: .students)

    }
    
}

class StudentsData : WSResponseData{
    var _id : String?
    var student_id : StudentIDData?
    
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case student_id = "student_id"
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        student_id = try values.decodeIfPresent(StudentIDData.self, forKey: .student_id)
    }
}

class StudentIDData: WSResponseData {
    var _id : String?
    var admission_no : String?
    var school_code : String?
    var name : String?
    
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case admission_no = "admission_no"
        case name = "name"
        case school_code = "school_code"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        admission_no = try values.decodeIfPresent(String.self, forKey: .admission_no)
        school_code = try values.decodeIfPresent(String.self, forKey: .school_code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}
