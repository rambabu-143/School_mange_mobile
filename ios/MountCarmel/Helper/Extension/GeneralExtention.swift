//
//  GeneralExtention.swift
//  BusinessForSale
//
//  Created by Chauhan Ramdevsinh on 15/09/19.
//  Copyright © 2019 HimAnshu Patel. All rights reserved.
//

import UIKit


class GeneralExtention: NSObject {

}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        return self.count >= 6
    }
    
    func isValidMobile() -> Bool {
        return self.count == 10
    }
    
    func validatePANCardNumber() -> Bool{
            let regularExpression = "[A-Z]{5}[0-9]{4}[A-Z]{1}"
            let panCardValidation = NSPredicate(format : "SELF MATCHES %@", regularExpression)
            return panCardValidation.evaluate(with: self)
        }
}

extension UIViewController {
    func toast(_ message: String, _ duration: Double = 2.0, dismissed:(() -> Void)? = nil) {
        let alert : UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        self.present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                alert.dismiss(animated: true) {
                    if let handler = dismissed {
                        handler()
                    }
                }
            }
        }
    }
    
    func toastwithColor(_ message: String,_ selectedcolor: UIColor, _ duration: Double = 2.0, dismissed:(() -> Void)? = nil) {
        let alert : UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = selectedcolor
        alert.setTitlet(font: UIFont.Bold(ofSize: 14.0), color: UIColor.black)
        self.present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                alert.dismiss(animated: true) {
                    if let handler = dismissed {
                        handler()
                    }
                }
            }
        }
    }
    
    func alert(_ message: String,_ action: String = "OK", _ handler:((_ action: UIAlertAction) -> Void)?) {
        let alert : UIAlertController = UIAlertController(title: APP_NAME, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
}


extension UINavigationBar {
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
    
    func defaultNavigationBar() {
        self.isTranslucent = false
    }
}

class ShadowView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10.0
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 10
    }
}

class BorderView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.masksToBounds = true
    }
}

extension Array {
    func toJson() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    // Safely lookup an index that might be out of bounds,
    // returning nil if it does not exist
    func get(index: Int) -> Element? {
        if 0 <= index && index < count {
            return self[index]
        } else {
            return nil
        }
    }
}
//extension UIApplication {
//    var statusBarView: UIView? {
//        if responds(to: Selector(("statusBar"))) {
//            return value(forKey: "statusBar") as? UIView
//        }
//        return nil
//    }
//}
