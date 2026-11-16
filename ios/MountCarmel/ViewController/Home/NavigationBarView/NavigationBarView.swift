//
//  NavigationBarView.swift
//  MountCarmel
//
//  Created by Niraj on 03/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

protocol NavigationBarViewDelegate: AnyObject {
    func onTapMenu()
    func onTapBack()
    func onTapNotification()
    func onTapBadgeCounts()
    func onTapAppLogo()
    func onTapDropDown()
    func onTapStory()
}

class NavigationBarView: UIView {
    @IBOutlet var viewDropDown: UIView!
    @IBOutlet var lblDropDownName: UILabel!
    @IBOutlet var imgDropDown: RoundedImage!
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var btnbadgeCount: RoundedButton!
    @IBOutlet weak var btnAppLogo: UIButton!
    
    @IBOutlet weak var viewNotification: UIView!{
        didSet{
            viewNotification.layer.cornerRadius = 19/2
            viewNotification.clipsToBounds = true
            //viewNotification.isHidden = true
        }
    }
    @IBOutlet weak var lblNotification: UILabel!
    
    @IBOutlet weak var btnStory: UIButton!{
        didSet{
            btnStory.isHidden=true
            btnStory.layer.cornerRadius = 16.0
            btnStory.clipsToBounds = true
            btnStory.layer.borderColor = UIColor.systemBlue.cgColor
            btnStory.layer.borderWidth = 1.5
        }
    }
    @IBOutlet var container: RoundedView!
    
    weak var delegate: NavigationBarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initilize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initilize()
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        self.lblNotification.text = String(APP_DELEGATE.notificationUnreadCount)
        self.viewNotification.isHidden = !(APP_DELEGATE.notificationUnreadCount > 0)
        
//        self.btnbadgeCount.setTitle("\(APP_DELEGATE.notificationUnreadCount)", for: .normal)
//        if APP_DELEGATE.notificationUnreadCount > 0 {
//            self.btnbadgeCount.isHidden = false
//        } else {
//            self.btnbadgeCount.isHidden = true
//        }
    }
    
    func initilize() {

        // Load the Nib
        Bundle.main.loadNibNamed(String(describing: NavigationBarView.self), owner: self, options: nil)
        
        // Make container fill the view frame
        self.container.frame = self.bounds
        self.container.frame.size.width = UIScreen.main.bounds.size.width
        self.container.clipsToBounds = true
        self.addSubview(self.container)
 
        self.clipsToBounds = true
        
        self.backgroundColor = UIColor.clear
        self.lblTitle.font = UIFont.setRegularFont(ofSize: 16.0)
         self.viewDropDown.isHidden = true
        
        //btnStatus.isHidden = true
        
        if APP_DELEGATE.userType == LoginType.Parent {
           // btnbadgeCount.backgroundColor = #colorLiteral(red: 0.7396043539, green: 0.3219832778, blue: 0.3228924572, alpha: 1)
            let student = APP_DELEGATE.selected_Student
            self.lblDropDownName.text = student?.studentId?.name ?? ""
            //studentImageIssue
            let imageURL = (APP_DELEGATE.loginAPIResponse?.path ?? "") + (student?.studentId?.profile_pic ?? "")
            self.imgDropDown.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "default_p"), options: [], context: nil)
        }
        else if APP_DELEGATE.userInfo?.type?.uppercased() == "STAFF" {
          //  btnbadgeCount.backgroundColor = #colorLiteral(red: 0.7396043539, green: 0.3219832778, blue: 0.3228924572, alpha: 1)
            let student = APP_DELEGATE.selected_Student
            if(student == nil){
                let userInfo = APP_DELEGATE.userInfo
                let urlPath = APP_DELEGATE.urlPath + "/"
                let imageURL = urlPath + (userInfo?.staffId?.profile_pic ?? "")
                self.lblDropDownName.text = userInfo?.name ?? ""
                self.imgDropDown.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "default_p"), options: [], context: nil)
            }else{
                self.lblDropDownName.text = student?.studentId?.name ?? ""
                //studentImageIssue
                let imageURL = (APP_DELEGATE.loginAPIResponse?.path ?? "") + (APP_DELEGATE.selected_Student?.studentId?.profile_pic ?? "")
                self.imgDropDown.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
            }
            
        }
    }
    
    @IBAction func btnMenuTap(_ sender: UIButton) {
        delegate?.onTapMenu()
    }
    
    @IBAction func btnBackTap(_ sender: Any) {
        delegate?.onTapBack()
    }
    
    @IBAction func btnNotificationTap(_ sender: Any) {
        delegate?.onTapNotification()
    }
    
    @IBAction func btnBadgeCountTap(_ sender: Any) {
        delegate?.onTapBadgeCounts()
    }
    
    @IBAction func btnAppLogoTap(_ sender: Any) {
        delegate?.onTapAppLogo()
    }
    
    @IBAction func btnDropDownTap(_ sender: Any) {
        delegate?.onTapDropDown()
    }
    @IBAction func btnStatus(_ sender: Any) {
    }
    @IBAction func btnStoryTap(_ sender: Any) {
        delegate?.onTapStory()
    }
    
    func setUpNavigationDropDown(view_cont : UIViewController){
        if view_cont.isKind(of: HomeViewController.self) {
            if APP_DELEGATE.userType == .Parent ||  APP_DELEGATE.userInfo?.type?.uppercased() == "STAFF"{
                self.viewDropDown.isHidden = false
            }
        }else{
            self.viewDropDown.isHidden = true
        }
        
    }
}
