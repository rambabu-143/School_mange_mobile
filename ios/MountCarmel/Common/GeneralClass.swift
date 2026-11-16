//
//  GeneralClass.swift
//  MountCarmel
//
//  Created by Sandip on 24/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

struct ScreenSize{
    
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    
}


//MARK: - Device Type -

struct DeviceType{
    
    static let IS_IPHONE_4_OR_LESS      =  ScreenSize.SCREEN_MAX_LENGTH < 568.0
    
    static let IS_IPHONE_5              =  ScreenSize.SCREEN_MAX_LENGTH == 568.0
    
    static let IS_IPHONE_6              =  ScreenSize.SCREEN_MAX_LENGTH == 667.0
    
    static let IS_IPHONE_6_PLUS         =  ScreenSize.SCREEN_MAX_LENGTH >= 736.0 // 6PLUS and X
    
    static let IS_IPHONE_6_PLUS_Only    =  ScreenSize.SCREEN_MAX_LENGTH == 736.0 // 6PLUS
    
    static let IS_IPAD                  =  UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    
    static let IS_IPHONE_X              =  ScreenSize.SCREEN_MAX_LENGTH == 812.0
    
     static let IS_IPHONE_X_PLUS              =  ScreenSize.SCREEN_MAX_LENGTH >= 812.0
    
}
extension UIFont {
    
    static func Regular(ofSize size: CGFloat) -> UIFont {
        
        return UIFont(name: "georgia", size: size)!
        
    }
    
    static func Medium(ofSize size: CGFloat) -> UIFont {
        
        return UIFont(name: "Montserrat-Medium", size: size)!
        
    }
    
    static func Italic(ofSize size: CGFloat) -> UIFont {
        
        return UIFont(name: "georgia-italic", size: size)!
        
    }
    
    
    
    static func Bold(ofSize size: CGFloat) -> UIFont {
        
        return UIFont(name: "georgia-bold", size: size)!
        
    }
    
    
    
    static func setRegularFont(ofSize size: CGFloat) -> UIFont {
        
        return UIFont(name: "georgia", size: self.getFontSize(size: size))!
        
    }
    
    
    
    static func setMediumFont(ofSize size: CGFloat) -> UIFont {
        
        return UIFont(name: "Montserrat-Medium", size: self.getFontSize(size: size))!
        
    }
    
    static func setItalicFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "georgia-italic", size: self.getFontSize(size: size))!
    }
    static func setBoldFont(ofSize size: CGFloat) -> UIFont {
        
        return UIFont(name: "georgia-bold", size: self.getFontSize(size: size))!
        
    }
    
    
    
    static func getFontSize(size: CGFloat) -> CGFloat {
        
        let point_size = size
        
        let value = DeviceType.IS_IPHONE_6_PLUS || DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_X_PLUS ? point_size + 2 : (DeviceType.IS_IPHONE_6 ? point_size + 1 : point_size-(point_size > 16 ? 2 : 1))
        
        return value
        
    }
    
}
extension UIAlertController {
    
    //Set background color of UIAlertController
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }
    
    //Set title font and title color
    func setTitlet(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attributeString = NSMutableAttributedString(string: title)//1
        if let titleFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : titleFont],//2
                                          range: NSMakeRange(0, title.utf8.count))
        }
        
        if let titleColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor],//3
                                          range: NSMakeRange(0, title.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedTitle")//4
    }
    
    //Set message font and message color
    func setMessage(font: UIFont?, color: UIColor?) {
        guard let message = self.message else { return }
        let attributeString = NSMutableAttributedString(string: message)
        if let messageFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : messageFont],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        
        if let messageColorColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : messageColorColor],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedMessage")
    }
    
    //Set tint color of UIAlertController
    func setTint(color: UIColor) {
        self.view.tintColor = color
    }
}
