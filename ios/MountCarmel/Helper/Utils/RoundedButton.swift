//
//  RoundedButton.swift
//  MountCarmel
//
//  Created by Niraj on 29/02/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
open class RoundedButton: UIButton {
    
    @IBInspectable
    var maxRadius: Bool = false {
        didSet {
            self.setRadius()
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            self.setRadius()
        }
    }
    
    @IBInspectable
    var bordercolor: UIColor = .gray {
        didSet {
            self.layer.borderColor = self.bordercolor.cgColor
        }
    }
    
    @IBInspectable
    var borderwidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = self.borderwidth
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat = 0.0 {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float = 0.0 {
        didSet {
            self.layer.shadowOpacity = shadowOpacity
            self.layer.masksToBounds = false
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize = CGSize(width: 0, height: 2) {
        didSet {
            self.layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor = .gray {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setRadius()
    }
    
    private func setRadius() {
        if self.maxRadius {
            self.layer.cornerRadius = min(self.frame.size.width, self.frame.size.height) * 0.5
        } else {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
}
