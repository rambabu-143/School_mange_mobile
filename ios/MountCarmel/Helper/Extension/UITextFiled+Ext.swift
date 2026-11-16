//
//  UITextFiled+Ext.swift
//  SwipeMyRide
//
//  Created by Niraj on 22/07/19.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

@IBDesignable
class RoundTextField : UITextField {
    
    var padding = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)

    @IBInspectable var left: CGFloat = 50 {
        didSet {
            adjustPadding()
        }
    }
    
    @IBInspectable var right: CGFloat = 0 {
        didSet {
            adjustPadding()
        }
    }
    
    @IBInspectable var top: CGFloat = 5 {
        didSet {
            adjustPadding()
        }
    }
    
    @IBInspectable var bottom: CGFloat = 0 {
        didSet {
            adjustPadding()
        }
    }

    
    @IBInspectable var cornerRadius : CGFloat = 0{
        didSet{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var bgColor : UIColor? {
        didSet {
            backgroundColor = bgColor
        }
    }
    
    @IBInspectable var leftImageWithCountry : UIImage?{
        didSet {
            if let image = leftImageWithCountry{
                leftViewMode = .always
                let imageView = UIImageView(frame: CGRect(x: 20, y: 0, width: 20, height: 20))
                imageView.image = image
                imageView.contentMode = .scaleAspectFit
                imageView.tintColor = tintColor
                let view = UIView(frame : CGRect(x: 0, y: 0, width: 100, height: 20))
                view.addSubview(imageView)
                
                let button = UIButton(frame: CGRect(x: 50, y: 0, width: 20, height: 20))
                button.setTitle("+1", for: UIControl.State.normal)
                button.setTitleColor(UIColor.black, for: UIControl.State.normal)
                view.addSubview(button)
                
                let viewSeprater = UIView(frame : CGRect(x: 80, y: 2, width: 1, height: 18))
                viewSeprater.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3946137764)
                view.addSubview(viewSeprater)
                
                leftView = view
            }else {
                leftViewMode = .never
            }
        }
    }
    
    @IBInspectable var leftImage : UIImage? {
        didSet {
            if let image = leftImage{
                leftViewMode = .always
                let imageView = UIImageView(frame: CGRect(x: 20, y: 2, width: 20, height: 20))
                imageView.image = image
                imageView.contentMode = .scaleAspectFit
                imageView.tintColor = tintColor
                let view = UIView(frame : CGRect(x: 0, y: 0, width: 25, height: 20))
                view.addSubview(imageView)
    
                leftView = view
            }else {
                leftViewMode = .never
            }
        }
    }
    
    @IBInspectable var rightImage : UIImage? {
        didSet {
            if let image = rightImage {
                rightViewMode = .always
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                button.setImage(image, for: UIControl.State.normal)
                button.setImage(UIImage.init(named: "ic_eye_open"), for: UIControl.State.selected)
                button.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
                let view = UIView(frame : CGRect(x: 0, y: 0, width: 35, height: 20))
                view.addSubview(button)
                rightView = view
            }else {
                rightViewMode = .never
            }
        }
    }
    
    @IBInspectable var rightOnlyImage : UIImage? {
        didSet {
            if let image = rightOnlyImage {
                rightViewMode = .always
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                button.setImage(image, for: UIControl.State.normal)
                button.setImage(UIImage.init(named: "ic_eye_open"), for: UIControl.State.selected)
               
                let view = UIView(frame : CGRect(x: 0, y: 0, width: 35, height: 20))
                view.addSubview(button)
                rightView = view
            }else {
                rightViewMode = .never
            }
        }
    }
    
    @IBInspectable var placeholderColor : UIColor? {
        didSet {
            let rawString = attributedPlaceholder?.string != nil ? attributedPlaceholder!.string : ""
            let str = NSAttributedString(string: rawString, attributes: [NSAttributedString.Key.foregroundColor : placeholderColor!])
            attributedPlaceholder = str
        }
    }
    
    @objc func showPassword(sender: UIButton!) {
        self.isSecureTextEntry.toggle()
        sender.isSelected.toggle()
    }
    
//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.insetBy(dx: 50, dy: 5)
//    }
//
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.insetBy(dx: 50, dy: 5)
//    }
    
    func adjustPadding() {
        padding = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }
}

