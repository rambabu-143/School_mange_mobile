//
//	LoginAPIUser.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginAPIUser : WSResponseData {
    
    var v : Int?
    var ID : String?
    var createdAt : String?
    var defaultLoginType : String?
    var email : String?
    var isDeleted : Bool?
    var isStaff : Bool?
    var mobile : String?
    var name : String?
    var profile_pic : String?
    var schools : [LoginAPISchool]?
    var staffId : LoginAPIStaffId?
    var students : [LoginAPIStudent]?
    var tokens : [LoginAPIToken]?
    var type : String?
    var updatedAt : String?
    var years : [LoginAPIYear]?
    
    var year_session : String?
    
    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case createdAt = "created_at"
        case defaultLoginType = "default_login_type"
        case email = "email"
        case isDeleted = "is_deleted"
        case isStaff = "is_staff"
        case mobile = "mobile"
        case name = "name"
        case profile_pic = "profile_pic"
        case schools = "schools"
        case staffId = "staff_id"
        case students = "students"
        case tokens = "tokens"
        case type = "type"
        case updatedAt = "updated_at"
        case years = "years"
        case year_session = "year_session"
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
        ID = try values.decodeIfPresent(String.self, forKey: .id)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        defaultLoginType = try values.decodeIfPresent(String.self, forKey: .defaultLoginType)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted)
        isStaff = try values.decodeIfPresent(Bool.self, forKey: .isStaff)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        profile_pic = try values.decodeIfPresent(String.self, forKey: .profile_pic)
        schools = try values.decodeIfPresent([LoginAPISchool].self, forKey: .schools)
        staffId = try values.decodeIfPresent(LoginAPIStaffId.self, forKey: .staffId)
        students = try values.decodeIfPresent([LoginAPIStudent].self, forKey: .students)
        tokens = try values.decodeIfPresent([LoginAPIToken].self, forKey: .tokens)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        years = try values.decodeIfPresent([LoginAPIYear].self, forKey: .years)
        year_session = try values.decodeIfPresent(String.self, forKey: .year_session)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(v, forKey: .v)
        try container.encode(ID, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(defaultLoginType, forKey: .defaultLoginType)
        try container.encode(email, forKey: .email)
        try container.encode(isDeleted, forKey: .isDeleted)
        try container.encode(isStaff, forKey: .isStaff)
        try container.encode(mobile, forKey: .mobile)
        try container.encode(name, forKey: .name)
        try container.encode(profile_pic, forKey: .profile_pic)
        try container.encode(schools, forKey: .schools)
        try container.encode(staffId, forKey: .staffId)
        try container.encode(students, forKey: .students)
        try container.encode(tokens, forKey: .tokens)
        try container.encode(type, forKey: .type)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(years, forKey: .years)
        try container.encode(year_session, forKey: .year_session)
    }
}
