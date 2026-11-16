//
//	LoginAPISchoolId.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginAPISchoolId : WSResponseData {
    
    var ID : String?
    var buildings : [LoginAPIBuilding]?
    var schoolAddress : String?
    var schoolEmail : String?
    var schoolName : String?
    var schoolPhone : String?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case buildings = "buildings"
        case schoolAddress = "school_address"
        case schoolEmail = "school_email"
        case schoolName = "school_name"
        case schoolPhone = "school_phone"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ID = try values.decodeIfPresent(String.self, forKey: .id)
        buildings = try values.decodeIfPresent([LoginAPIBuilding].self, forKey: .buildings)
        schoolAddress = try values.decodeIfPresent(String.self, forKey: .schoolAddress)
        schoolEmail = try values.decodeIfPresent(String.self, forKey: .schoolEmail)
        schoolName = try values.decodeIfPresent(String.self, forKey: .schoolName)
        schoolPhone = try values.decodeIfPresent(String.self, forKey: .schoolPhone)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ID, forKey: .id)
        try container.encode(buildings, forKey: .buildings)
        try container.encode(schoolAddress, forKey: .schoolAddress)
        try container.encode(schoolEmail, forKey: .schoolEmail)
        try container.encode(schoolName, forKey: .schoolName)
        try container.encode(schoolPhone, forKey: .schoolPhone)
    }
}
