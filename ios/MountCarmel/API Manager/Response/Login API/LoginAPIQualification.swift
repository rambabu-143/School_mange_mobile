//
//	LoginAPIQualification.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginAPIQualification : WSResponseData {
    
    var name : String?
    var passingYear : String?
    var qualificationId : LoginAPIQualificationId?
    var university : String?
    
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case passingYear = "passing_year"
        case qualificationId = "qualification_id"
        case university = "university"
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        passingYear = try values.decodeIfPresent(String.self, forKey: .passingYear)
        qualificationId = try values.decodeIfPresent(LoginAPIQualificationId.self, forKey: .qualificationId)
        university = try values.decodeIfPresent(String.self, forKey: .university)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(passingYear, forKey: .passingYear)
        try container.encode(qualificationId, forKey: .qualificationId)
        try container.encode(university, forKey: .university)
    }
}
