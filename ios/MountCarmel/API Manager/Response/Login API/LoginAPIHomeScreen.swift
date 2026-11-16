//
//	LoginAPIHomeScreen.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginAPIHomeScreen : WSResponseData {
    
    var priority : Int?
    var title : String?
    
    
    enum CodingKeys: String, CodingKey {
        case priority = "priority"
        case title = "title"
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        priority = try values.decodeIfPresent(Int.self, forKey: .priority)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(priority, forKey: .priority)
        try container.encode(title, forKey: .title)
    }
}
