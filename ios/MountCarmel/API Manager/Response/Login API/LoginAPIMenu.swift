//
//	LoginAPIMenu.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginAPIMenu : WSResponseData {
    
    var homeScreen : [LoginAPIHomeScreen]?
    var side : [LoginAPIHomeScreen]?
    
    enum CodingKeys: String, CodingKey {
        case homeScreen = "home_screen"
        case side = "side"
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        homeScreen = try values.decodeIfPresent([LoginAPIHomeScreen].self, forKey: .homeScreen)
        side = try values.decodeIfPresent([LoginAPIHomeScreen].self, forKey: .side)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(homeScreen, forKey: .homeScreen)
        try container.encode(side, forKey: .side)
    }
}
