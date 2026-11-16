//
//  ResponseModelArray.swift
//  Simah
//
//  Created by hb on 14/10/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

public class ResponseModelArray<T: WSResponseData>: Codable {
    public var code: Int?
    public var totalCount: Int?
    public var result: [T]?
    public var message: String?
    
    private enum CodingKeys: String, CodingKey {
        case code = "code"
        case result = "result"
        case message = "message"
        case totalCount = "total_count"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        result = try values.decodeIfPresent([T].self, forKey: .result)
        totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
    }
}


