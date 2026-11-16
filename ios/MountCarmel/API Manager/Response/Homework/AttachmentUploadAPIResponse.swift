//
//  AttachmentUploadAPIResponse.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 02/08/24.
//  Copyright © 2024 Mount Carmel School. All rights reserved.
//

import Foundation

class AttachmentUploadAPIResponse : WSResponseData {
    var status: Bool?
    var message: String?
    var file_name: String?
    var originalname: String?
    var file_size: Int?
    var path: String?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case file_name = "file_name"
        case originalname = "originalname"
        case file_size = "file_size"
        case path = "path"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        file_name = try values.decodeIfPresent(String.self, forKey: .file_name)
        originalname = try values.decodeIfPresent(String.self, forKey: .originalname)
        file_size = try values.decodeIfPresent(Int.self, forKey: .file_size)
        path = try values.decodeIfPresent(String.self, forKey: .path)
    }
}

extension AttachmentUploadAPIResponse: CustomStringConvertible {
    public var description: String {
        return "\(Self.self)(file_name: \(self.file_name ?? "nil"), originalname: \(self.originalname ?? "nil"), file_size: \(self.file_size ?? 0))"
    }
}
