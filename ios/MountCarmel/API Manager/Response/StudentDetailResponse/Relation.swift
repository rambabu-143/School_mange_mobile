//
//  FeesData.swift
//  MountCarmel
//
//  Created by Sandip on 25/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import Foundation

class Relation : Codable {
	var title : String?
	var name : String?
	var qualification : String?
	var occupation : String?
	var sub_category : String?
	var subCategoryOtherSecond : String?
	var mobile : String?
	var organizationName : String?
	var designation : String?
	var officeAddress : String?
	var officePhoneNo : String?
	var email : String?
	var pancard : String?
	var relation : String?
	var qualification_id : Qualification_id?
	var occupation_id : occupation_id_id?
	var occupation_child_id : Occupation_child_id?
	var other_occupation : String?
	var organization : String?
	var office_address : String?
	var office_phone : String?
	var office_email : String?

	enum CodingKeys: String, CodingKey {

		case title = "title"
		case name = "name"
		case qualification = "qualification"
		case occupation = "Occupation"
		case sub_category = "sub_category"
		case subCategoryOtherSecond = "subCategoryOtherSecond"
		case mobile = "mobile"
		case organizationName = "organizationName"
		case designation = "designation"
		case officeAddress = "officeAddress"
		case officePhoneNo = "officePhoneNo"
		case email = "email"
		case pancard = "pancard"
		case relation = "relation"
		case qualification_id = "qualification_id"
		case occupation_id = "occupation_id"
		case occupation_child_id = "occupation_child_id"
		case other_occupation = "other_occupation"
		case organization = "organization"
		case office_address = "office_address"
		case office_phone = "office_phone"
		case office_email = "office_email"
	}

//	required init(from decoder: Decoder) throws {
//        try super.init(from: decoder)
//
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//		title = try values.decodeIfPresent(String.self, forKey: .title)
//		name = try values.decodeIfPresent(String.self, forKey: .name)
//		qualification = try values.decodeIfPresent(String.self, forKey: .qualification)
//		occupation = try values.decodeIfPresent(String.self, forKey: .occupation)
//		sub_category = try values.decodeIfPresent(String.self, forKey: .sub_category)
//		subCategoryOtherSecond = try values.decodeIfPresent(String.self, forKey: .subCategoryOtherSecond)
//		mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
//		organizationName = try values.decodeIfPresent(String.self, forKey: .organizationName)
//		designation = try values.decodeIfPresent(String.self, forKey: .designation)
//		officeAddress = try values.decodeIfPresent(String.self, forKey: .officeAddress)
//		officePhoneNo = try values.decodeIfPresent(String.self, forKey: .officePhoneNo)
//		email = try values.decodeIfPresent(String.self, forKey: .email)
//		pancard = try values.decodeIfPresent(String.self, forKey: .pancard)
//		relation = try values.decodeIfPresent(String.self, forKey: .relation)
//		qualification_id = try values.decodeIfPresent(Qualification_id.self, forKey: .qualification_id)
//		occupation_id = try values.decodeIfPresent(Occupation_id.self, forKey: .occupation_id)
//		occupation_child_id = try values.decodeIfPresent(Occupation_child_id.self, forKey: .occupation_child_id)
//		other_occupation = try values.decodeIfPresent(String.self, forKey: .other_occupation)
//		organization = try values.decodeIfPresent(String.self, forKey: .organization)
//		office_address = try values.decodeIfPresent(String.self, forKey: .office_address)
//		office_phone = try values.decodeIfPresent(String.self, forKey: .office_phone)
//		office_email = try values.decodeIfPresent(String.self, forKey: .office_email)
//	}

}

class Occupation_child_id : Codable {
    var _id : String?
    var occupation_child_name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case occupation_child_name = "occupation_child_name"
    }
    
//   required init(from decoder: Decoder) throws {
//    try super.init(from: decoder)
//
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        _id = try values.decodeIfPresent(String.self, forKey: ._id)
//        occupation_child_name = try values.decodeIfPresent(String.self, forKey: .occupation_child_name)
//    }
    
}

//class Occupation_id : Codable {
//    var _id : String?
//    var occupation_name : String?
//
//    enum CodingKeys: String, CodingKey {
//
//        case _id = "_id"
//        case occupation_name = "occupation_name"
//    }
//
////   required init(from decoder: Decoder) throws {
////        try super.init(from: decoder)
////
////        let values = try decoder.container(keyedBy: CodingKeys.self)
////        _id = try values.decodeIfPresent(String.self, forKey: ._id)
////        occupation_name = try values.decodeIfPresent(String.self, forKey: .occupation_name)
////    }
//
//}

class occupation_id_id : Codable {
    var _id : String?
    var occupation_name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case occupation_name = "occupation_name"
    }
    
//   required init(from decoder: Decoder) throws {
//        try super.init(from: decoder)
//
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        _id = try values.decodeIfPresent(String.self, forKey: ._id)
//        occupation_name = try values.decodeIfPresent(String.self, forKey: .occupation_name)
//    }
    
}

class Qualification_id : Codable {
    var _id : String?
    var qualification : String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case qualification = "qualification"
    }
    
//    required init(from decoder: Decoder) throws {
//        try super.init(from: decoder)
//
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        _id = try values.decodeIfPresent(String.self, forKey: ._id)
//        qualification = try values.decodeIfPresent(String.self, forKey: .qualification)
//    }
    
}
