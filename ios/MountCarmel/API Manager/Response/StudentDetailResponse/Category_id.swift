

import Foundation

class Category_id : WSResponseData {
	var _id : String?
	var category_name : String?

	enum CodingKeys: String, CodingKey {

		case _id = "_id"
		case category_name = "category_name"
	}

	required init(from decoder: Decoder) throws {
        try super.init(from: decoder)

		let values = try decoder.container(keyedBy: CodingKeys.self)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		category_name = try values.decodeIfPresent(String.self, forKey: .category_name)
	}

}
