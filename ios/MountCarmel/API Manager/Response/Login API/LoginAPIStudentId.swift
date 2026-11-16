//
//	LoginAPIStudentId.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginAPIStudentId : WSResponseData {
    
    var ID : String?
    var admissionNo : String?
    var name : String?
    var email : String?
    var profile_pic : String?
    var school_type : String?
    var studentImg : String?
    var sms_mobile : String?
    var sectionId : LoginAPIDepartmentId?
    var standardId : LoginAPIDepartmentId?
    var standardSectionId : StandardSection?
    var year_branch : Int?
    var year_session : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case admissionNo = "admission_no"
        case name = "name"
        case sectionId = "section_id"
        case standardId = "standard_id"
        case standardSectionId = "standard_section_id"
        case studentImg = "studentImg"
        case email = "email"
        case profile_pic = "profile_pic"
        case school_type = "school_type"
        case sms_mobile = "sms_mobile"
        case year_branch = "year_branch"
        case year_session = "year_session"
       
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ID = try values.decodeIfPresent(String.self, forKey: .id)
        admissionNo = try values.decodeIfPresent(String.self, forKey: .admissionNo)
        name = try values.decodeIfPresent(String.self, forKey: .name)
         email = try values.decodeIfPresent(String.self, forKey: .email)
         profile_pic = try values.decodeIfPresent(String.self, forKey: .profile_pic)
         school_type = try values.decodeIfPresent(String.self, forKey: .school_type)
        sms_mobile = try values.decodeIfPresent(String.self, forKey: .sms_mobile)
         studentImg = try values.decodeIfPresent(String.self, forKey: .studentImg)
        sectionId = try values.decodeIfPresent(LoginAPIDepartmentId.self, forKey: .sectionId)
        standardId = try values.decodeIfPresent(LoginAPIDepartmentId.self, forKey: .standardId)
        standardSectionId = try values.decodeIfPresent(StandardSection.self, forKey: .standardSectionId)
        year_branch = try values.decodeIfPresent(Int.self, forKey: .year_branch)
        year_session = try values.decodeIfPresent(String.self, forKey: .year_session)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ID, forKey: .id)
        try container.encode(admissionNo, forKey: .admissionNo)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(profile_pic, forKey: .profile_pic)
        try container.encode(studentImg, forKey: .studentImg)
        try container.encode(school_type, forKey: .school_type)
        try container.encode(sms_mobile, forKey: .sms_mobile)
        try container.encode(sectionId, forKey: .sectionId)
        try container.encode(standardId, forKey: .standardId)
        try container.encode(standardSectionId, forKey: .standardSectionId)
        try container.encode(year_branch, forKey: .year_branch)
        try container.encode(year_session, forKey: .year_session)
    }
}
