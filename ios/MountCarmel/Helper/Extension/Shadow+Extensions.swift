//
//  Shadow+Extensions.swift
//  DramG
//
//  Created by Niraj on 25/01/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
        // Add shadow
       func addDropShadow(path: CGPath? = nil,
                           offset: CGSize = CGSize(width: 0, height: 2),
                           radius: CGFloat = 5,
                           color: UIColor = .black,
                           opacity: CGFloat = 0.3) {
            self.layer.shadowRadius = radius
            self.layer.shadowOpacity = Float(opacity)
            self.layer.shadowColor = color.cgColor
            self.layer.shadowOffset = offset
            self.layer.masksToBounds = false
       }
}
