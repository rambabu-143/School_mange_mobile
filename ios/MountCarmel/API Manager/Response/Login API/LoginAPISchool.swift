//
//	LoginAPISchool.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginAPISchool : WSResponseData {
    
    var isDefault : Bool?
    var schoolCode : String?
    var schoolId : LoginAPISchoolId?
    var branch_code : Int?
    
    enum CodingKeys: String, CodingKey {
        case isDefault = "is_default"
        case schoolCode = "school_code"
        case schoolId,branch_code
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isDefault = try values.decodeIfPresent(Bool.self, forKey: .isDefault)
        schoolCode = try values.decodeIfPresent(String.self, forKey: .schoolCode)
        branch_code = try values.decodeIfPresent(Int.self, forKey: .branch_code)
        schoolId = try values.decodeIfPresent(LoginAPISchoolId.self, forKey: .schoolId)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isDefault, forKey: .isDefault)
        try container.encode(schoolCode, forKey: .schoolCode)
        try container.encode(branch_code, forKey: .branch_code)
        try container.encode(schoolId, forKey: .schoolId)
    }
}
