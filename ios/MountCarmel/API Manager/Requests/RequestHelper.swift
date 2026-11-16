//
//  BaseRequestClass.swift
//  BusinessForSale
//
//  Created by Chauhan Ramdevsinh on 09/02/20.
//  Copyright © 2020 HimAnshu Patel. All rights reserved.
//

import UIKit

struct JSON {
    static let encoder = JSONEncoder()
}
extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}
