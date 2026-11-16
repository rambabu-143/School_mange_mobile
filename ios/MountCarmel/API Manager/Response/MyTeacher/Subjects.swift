

import Foundation

class Subjects : WSResponseData {
	var is_subject_divide : String?
	var subject_parts : [String]?
	var _id : String?
	var __v : Int?
	var order : Int?
	var subject_name : String?
	var subject_teacher_id : [Subject_teacher_id]?

	enum CodingKeys: String, CodingKey {

		case is_subject_divide = "is_subject_divide"
		case subject_parts = "subject_parts"
		case _id = "_id"
		case __v = "__v"
		case order = "order"
		case subject_name = "subject_name"
		case subject_teacher_id = "subject_teacher_id"
	}

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		is_subject_divide = try values.decodeIfPresent(String.self, forKey: .is_subject_divide)
		subject_parts = try values.decodeIfPresent([String].self, forKey: .subject_parts)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		__v = try values.decodeIfPresent(Int.self, forKey: .__v)
		order = try values.decodeIfPresent(Int.self, forKey: .order)
		subject_name = try values.decodeIfPresent(String.self, forKey: .subject_name)
		subject_teacher_id = try values.decodeIfPresent([Subject_teacher_id].self, forKey: .subject_teacher_id)
	}

}


class Subject_teacher_id : WSResponseData {
    var _id : String?
    var staff_id : TeacherTypeData?
    var part_subject_name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case staff_id = "staff_id"
        case part_subject_name = "part_subject_name"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        staff_id = try values.decodeIfPresent(TeacherTypeData.self, forKey: .staff_id)
        part_subject_name = try values.decodeIfPresent(String.self, forKey: .part_subject_name)
    }
    
}
