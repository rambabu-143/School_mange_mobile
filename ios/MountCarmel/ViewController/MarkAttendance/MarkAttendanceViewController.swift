//
//  MarkAttendanceViewController.swift
//  MountCarmel
//
//  Created by Sandip on 07/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import DropDown

class MarkAttendanceViewController: UIViewController {

    @IBOutlet var lblSelectDate: UILabel!
    @IBOutlet var lblSelectClass: UILabel!
    @IBOutlet var btnSelectClass: UIButton!
    @IBOutlet var txtDate: RoundTextField!
    @IBOutlet var txtClass: RoundTextField!
    @IBOutlet weak var navigationView: NavigationBarView!

    var arrClassList = [ClassListWithSectionData]()
    var selectedID = -1
    //DropDown Declaration
    var classDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "Mark Attendance"
        navigationView.delegate = self
        setHouseDropDown()
        lblSelectClass.font = UIFont.setBoldFont(ofSize: 13.0)
        lblSelectDate.font = UIFont.setBoldFont(ofSize: 13.0)
        
        txtClass.font = UIFont.setRegularFont(ofSize: 13.0)
        txtDate.font = UIFont.setRegularFont(ofSize: 13.0)

        txtDate.text = CommonFunctions.getDateInString(date: Date(), strDateFormat: DateFormat.DateFormat_DDMMYYYY)
        
        self.callAPIForClassList { (success) in
            if(success){
                if(self.arrClassList.count > 0){
//                    self.selectedID = 0
                    //self.selectedID = self.arrClassList[0]._id ?? ""
//                    self.txtClass.text = (self.arrClassList[0].standard ?? "") + " " + (self.arrClassList[0].section ?? "")
                }
            }
        }
        
//        if(APP_DELEGATE.userInfo?.staffId?.isClassTeacher ?? false){
//            self.selectedID = APP_DELEGATE.userInfo?.staffId?.classTeacherID?._id ?? ""
//            btnSelectClass.isUserInteractionEnabled = false
//            let name = (APP_DELEGATE.userInfo?.staffId?.classTeacherID?.standard ?? "")
//
//            self.txtClass.text = name + "-" + (APP_DELEGATE.userInfo?.staffId?.classTeacherID?.section ?? "")
//        }
        // Do any additional setup after loading the view.
    }
    
    //Set DropMenu
    func setHouseDropDown(){
        
        classDropDown.anchorView = txtClass
        classDropDown.direction = .bottom
        classDropDown.width = txtClass.frame.size.width
        classDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        
    }
    @IBAction func btnGoClick(_ sender: Any) {
        
        if(txtClass.text!.isEmpty){
            self.toast("Please select class")
            return
        }
        if(txtDate.text!.isEmpty){
            self.toast("Please select Date")
            return
        }
        if let viewController: MarkAttendenceDetailViewController = MarkAttendenceDetailViewController.storyboardInstance.initialize() {
            viewController.strDate = txtDate.text ?? ""
            // viewController.standard_id = self.selectedID
            viewController.selectedClassList = self.arrClassList[selectedID]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
       
    }
    
    @IBAction func actionSelectDate(_ sender: Any) {
        if let viewController: CalenderPopUpViewController = CalenderPopUpViewController.storyboardInstance.initialize() {
            
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.strScreenName = "MarkAttendance"
            viewController.dateHandler = { (strDate) in
                self.txtDate.text = strDate
            }
            self.present(viewController, animated: false, completion: nil)
        }
    }
    
    @IBAction func actionSelectClass(_ sender: Any) {
        var strArr = [String]()
        for item in self.arrClassList{
            let name = (item.standard ?? "") + " " + (item.section ?? "")
            strArr.append(name)
        }
        classDropDown.textFont = UIFont.setRegularFont(ofSize: 13)
        classDropDown.dataSource = strArr
        
        classDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
           // self.selectedID = self.arrClassList[index].id ?? ""
            self.selectedID = index
            self.txtClass.text = item
            self.classDropDown.hide()
        }
        classDropDown.show()
    }
    
}
extension MarkAttendanceViewController: NavigationBarViewDelegate {
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

//MARK:- API CALL -

extension MarkAttendanceViewController{
    func callAPIForClassList(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        StaffManageMentAPI.classList() { (respose, error) in
            Loader.hide()
            guard let response = respose else {
                self.toast(error?.localizedDescription ?? "Invalid Response")
                finished(false)
                return
            }
            guard response.status == true else {
                self.toast(response.message ?? "Invalid Response")
                //CommonFunctions.logOutFromAPP()
                finished(false)
                return
            }
            guard let responseData = response.data else {
                self.toast(response.message ?? "Invalid Response")
                finished(false)
                return
            }
            
            self.arrClassList = responseData
            if(self.arrClassList.count > 0){
//                self.txtClass.text = self.arrClassList[0].name ?? ""
//                self.selectedID = self.arrClassList[0].id ?? ""
            }
            
            finished(true)
        }
    }
}
