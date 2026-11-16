//
//  AppSupportViewController.swift
//  MountCarmel
//
//  Created by Mandeep Singh on 25/12/22.
//  Copyright © 2022 InventionHill. All rights reserved.
//

import UIKit
import DropDown

class AppSupportViewController: UIViewController {
    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet weak var txtAdmission: TextFieldCustom!
    @IBOutlet weak var txtTitle: TextFieldCustom!{didSet{txtTitle.delegate=self}}
    @IBOutlet weak var txtDescription: UITextView!{didSet{txtDescription.delegate=self}}
    @IBOutlet weak var viewTextView: UIView!
    
    private let txtDesPlaceholder = "Type here ..."
    private let arrTitles = ["Login related","User id / Password", "Specific module", "Others"]
    private var commonDropDown = DropDown()
    
    private var admissionTextCount = 0{
        didSet{
            if admissionTextCount > 8{
                txtAdmission.layer.borderColor = UIColor.systemRed.cgColor
            }else{
                if #available(iOS 13.0, *) {
                    txtAdmission.layer.borderColor = UIColor.systemGray3.cgColor
                } else {
                    txtAdmission.layer.borderColor = UIColor.lightGray.cgColor
                }
            }
        }
    }
    
    private var commentsTextCount = 0{
        didSet{
            if commentsTextCount > 300{
                viewTextView.layer.borderColor = UIColor.systemRed.cgColor
            }else{
                if #available(iOS 13.0, *) {
                    viewTextView.layer.borderColor = UIColor.systemGray3.cgColor
                } else {
                    viewTextView.layer.borderColor = UIColor.lightGray.cgColor
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.lblTitle.text = "App Support"
        navigationView.delegate = self
        
        txtDescription.text = txtDesPlaceholder
        txtDescription.textColor = UIColor.lightGray
        
        txtAdmission.addTarget(self, action: #selector(self.admissionDidChange(_:)), for: .editingChanged)
        
        txtTitle.text = arrTitles.first
    }
    
    @objc func admissionDidChange(_ textField: UITextField) {
       admissionTextCount = txtAdmission.text!.count
    }
    
    
    @IBAction func btnSubmit(_ sender: Any) {
        
        if admissionTextCount > 8{
            
        }
        if commentsTextCount > 300{
            
        }
    }
    
}

extension AppSupportViewController:UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text.count)
        commentsTextCount = textView.text.count
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = txtDesPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
}

extension AppSupportViewController:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        commonDropDown.anchorView = textField
        commonDropDown.direction = .bottom
        commonDropDown.textFont = UIFont.setRegularFont(ofSize: 13.0)
        commonDropDown.width = textField.frame.size.width/1.4
        commonDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        commonDropDown.dataSource = arrTitles
        
        commonDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            // print("Selected item: \(item) at index: \(index)")
            textField.text = item
            self.commonDropDown.hide()
        }
        commonDropDown.show()
        
        return false
    }
}

extension AppSupportViewController: NavigationBarViewDelegate{
    func onTapDropDown() {
    }
    func onTapMenu() {
    }
    
    func onTapBack() {
        if self.navigationController?.viewControllers.count ?? 0 == 1 {
            self.setHomeScreen()
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func onTapNotification() {
        if let viewController: NotificationViewController = NotificationViewController.storyboardInstance.initialize() {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func onTapBadgeCounts() {
        if let viewController: NotificationViewController = NotificationViewController.storyboardInstance.initialize() {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func onTapAppLogo() {
        let viewcontrollers = self.navigationController?.viewControllers
        var flag = true
        viewcontrollers?.forEach({ (vc) in
            if  let viewController = vc as? HomeViewController {
                flag = false
                self.navigationController!.popToViewController(viewController, animated: true)
            }
        })
        if flag {
            self.setHomeScreen()
        }
    }
    func onTapStory() {
        print(#function)
    }
    func setHomeScreen() {
        if let viewController: HomeViewController = HomeViewController.storyboardInstance.initialize() {
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
        }
    }
}
