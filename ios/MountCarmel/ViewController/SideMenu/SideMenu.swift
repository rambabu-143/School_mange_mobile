//
//  SideMenu.swift
//  MountCarmel
//
//  Created by Apple on 01/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import MobileCoreServices
import QuickLook

class SideMenu: UIViewController {
    
    @IBOutlet var btnGoToProfile: UIButton!
    @IBOutlet var btnCamera: UIButton!
    @IBOutlet var btnEditProfile: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var imgProfile: UIImageView!
    @IBOutlet private weak var imgBg: UIImageView!
    @IBOutlet private weak var lblNumber: UILabel!
    @IBOutlet private weak var lblAN: UILabel!
    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var btnSetting: UIButton!
    var viewController = UIViewController()
    
    var imageArray = ["Class_List", "House_List", "child", "Time_Table", "Mark_Attendance", "Attendance_Summary", "Attendance_Days_Entry", "WISE", "Notice", "fee", "message", "School_Calendar", "Syllabus"]
    var titleArray = ["Class List", "House List", "Child", "Time Table", "Mark Attendance", "Attandance Summary", "Attendance Days Entry", "WISE", "Notice", "Fee", "Message", "School Calendar", "Syllabus"]
    
    var imagePicker = UIImagePickerController()
    var imageData : Data?
    var emailGroupResponse : EmailGroupResponseData?
    var previewItem : URL?
    
    private var objChronicles : chroniclesModel?
    private var objNewsletter : newsletterModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.configureUI()
    }
    
    func configureCollectionView() {
        // Register Cell
        let cellNib = UINib(nibName: String(describing: SideMenuStaffCell.self), bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: SideMenuStaffCell.cellId)
    }
    
    func configureUI() {
        
        lblName.font = UIFont.setBoldFont(ofSize: 16.0)
        lblNumber.font = UIFont.setRegularFont(ofSize: 15.0)
        lblAN.font = UIFont.setRegularFont(ofSize: 13.0)
        //btnEditProfile.isHidden = true
        //btnCamera.isHidden = true
        btnGoToProfile.isHidden = false
        if APP_DELEGATE.userType == LoginType.Parent {
            //btnEditProfile.isHidden = true
            btnGoToProfile.isHidden = true
            //btnCamera.isHidden = false
            lblAN.isHidden = true
            let userInfo = APP_DELEGATE.userInfo
            var profilePic = ""
            if let val =  UserDefaults.standard.value(forKey: "ParentProfile") as? String{
                profilePic = val
            }else if let strPic = userInfo?.students?.first?.studentId?.profile_pic{
                profilePic = strPic
            }else{
                 profilePic = userInfo?.profile_pic ?? ""
            }

            let urlPath = (APP_DELEGATE.loginAPIResponse?.path ?? "") != "" ? (APP_DELEGATE.loginAPIResponse?.path ?? "") : APP_DELEGATE.parent_URL
            let imageURL = urlPath + (profilePic)
           // self.imgProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(), options: [], context: nil)
            
            SDWebImageManager.shared.loadImage(
                with: URL(string: imageURL),
                options: .highPriority,
                progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                    if(image != nil){
                        self.imgProfile.image = image
                        //self.btnEditProfile.isHidden = false
                       // self.btnCamera.isHidden = true
                    }else{
                       // self.btnEditProfile.isHidden = true
                       // self.btnCamera.isHidden = false
                        self.imgProfile.image = #imageLiteral(resourceName: "default_p")
                    }
                    print(isFinished) //9821338236
            }
            
            self.lblName.text = userInfo?.name
            
          //  var arrStudents = [LoginAPIStudent]()
         //   arrStudents = APP_DELEGATE.userInfo?.students ?? [LoginAPIStudent]()
            
          //  let strClass = (APP_DELEGATE.selected_Student?.studentId?.standardId?.name ?? "") + "-"
            
            self.lblNumber.text = APP_DELEGATE.userInfo?.mobile ?? ""
            self.lblAN.text = APP_DELEGATE.loginAPIResponse?.metaData?.schoolCode
            
            // lblNumber.text = "V B"
            // imgProfile.image = UIImage.init(named: "profile-image-4-12")
            
            self.callAPIForSelfAwernessMenu { success in
            }
            
            imageArray = ["Assignments_P", "Syllabus_S","Date_Sheet_S", "Holiday_Homework_P",  "ChoniclesIMG","NewsletterIMG","staff_notice","fees","setting_new"]
            titleArray = ["Assignments", "Syllabus","Date Sheet", "Holiday Homework", "Chronicles","NewsLetter", "Privacy Policy", "Fee", "Settings"]
            
        }else if APP_DELEGATE.userType == LoginType.School {
            if(APP_DELEGATE.userInfo?.type?.uppercased() != "STAFF"){
                lblAN.isHidden = true
                let userInfo = APP_DELEGATE.userInfo
             //   let urlPath = APP_DELEGATE.urlPath
                //studentImageIssue
                let imageURL = userInfo?.students?[0].studentId?.profile_pic ?? ""
                self.imgProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "default_p"), options: [], context: nil)
                
                let arrStudents = userInfo?.students ?? [LoginAPIStudent]()
                self.lblName.text = userInfo?.students?[0].studentId?.name ?? ""
                if(arrStudents.count > 0){
                    self.lblNumber.text = (arrStudents[0].studentId?.standardId?.name ?? "") + " " + (arrStudents[0].studentId?.sectionId?.name ?? "")
                }else{
                    self.lblNumber.text = ""
                }
            }else{
                let userInfo = APP_DELEGATE.userInfo
                let urlPath = APP_DELEGATE.urlPath + "/"
                let imageURL = urlPath + (userInfo?.staffId?.profile_pic ?? "")
                
                self.imgProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "default_p"), options: [], context: nil)
                self.lblName.text = userInfo?.name
                self.lblNumber.text = userInfo?.mobile
                self.lblAN.text = APP_DELEGATE.loginAPIResponse?.metaData?.schoolCode
            }
            self.callAPIForSelfAwernessMenu { success in
            }
            imageArray = ["Assignments", "Syllabus","Date_Sheet", "Holiday_Homework",  "ChoniclesIMG","NewsletterIMG", "staff_notice", "setting_new"]
            titleArray = ["Assignments", "Syllabus","Date Sheet", "Holiday Homework","Chronicles","NewsLetter", "Privacy Policy", "Settings"]
            
        }else if APP_DELEGATE.userType == LoginType.Nursery {
            if(APP_DELEGATE.userInfo?.type?.uppercased() != "STAFF"){
                lblAN.isHidden = true
                
                self.view.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7215686275, blue: 0.6549019608, alpha: 1)
                imgBg.isHidden = true
                btnSetting.setImage(UIImage.init(named: "setting_N"), for: .normal)
                
                let userInfo = APP_DELEGATE.userInfo
             //   let urlPath = APP_DELEGATE.urlPath
                //studentImageIssue
                let imageURL = userInfo?.students?[0].studentId?.profile_pic ?? ""
                
                self.imgProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "default_p"), options: [], context: nil)
                self.lblName.text =  userInfo?.students?[0].studentId?.name ?? ""
                self.lblName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.lblNumber.textColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                let arrStudents = userInfo?.students ?? [LoginAPIStudent]()
                if(arrStudents.count > 0){
                    self.lblNumber.text = (arrStudents[0].studentId?.standardId?.name ?? "") + " " + (arrStudents[0].studentId?.sectionId?.name ?? "")
                }else{
                    self.lblNumber.text = ""
                }
            }else{
                let userInfo = APP_DELEGATE.userInfo
                let urlPath = APP_DELEGATE.urlPath + "/"
                let imageURL = urlPath + (userInfo?.staffId?.profile_pic ?? "")
                
                self.imgProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "default_p"), options: [], context: nil)
                self.lblName.text = userInfo?.name
                self.lblNumber.text = userInfo?.mobile
                self.lblAN.text = APP_DELEGATE.loginAPIResponse?.metaData?.schoolCode
            }
            
            //
            self.callAPIForSelfAwernessMenu { success in
            }
            
            imageArray = ["assignments_N", "Syllabus_N","Date_Sheet_N", "Holiday_Homework_N",  "ChoniclesIMG","NewsletterIMG", "staff_notice", "setting_new"]
            titleArray = ["Assignments", "Syllabus","Date Sheet", "Holiday Homework", "Chronicles","NewsLetter", "Privacy Policy", "Settings"]
            
        } else{
            lblAN.isHidden = true
            let userInfo = APP_DELEGATE.userInfo
            let urlPath = (APP_DELEGATE.loginAPIResponse?.path ?? "") + "/"
            let imageURL = urlPath + (userInfo?.staffId?.profile_pic ?? "")
            
            self.imgProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "default_p"), options: [], context: nil)
            self.lblName.text = userInfo?.name
            self.lblNumber.text = userInfo?.mobile
            self.lblAN.text = APP_DELEGATE.loginAPIResponse?.metaData?.schoolCode
            imageArray = ["Mark_Attendance","Time_Table_S","email-group_S","Attendance_Days_Entry", "ChoniclesIMG","NewsletterIMG", "staff_notice","setting_new"]
            titleArray = ["My Attendance","Time Table", "Email Groups","Term Attendance", "Chronicles","NewsLetter", "Privacy Policy", "Settings"]
            
            self.callAPIForStaffDashboard { success in
            }
        }
        
    }
    
    @IBAction func btnEditProfileClick(_ sender: Any) {
        oepnImagePicker()
    }
    
    @IBAction func btnTapSetting(_ sender: UIButton) {
        let viewController: SettingsViewController = SettingsViewController.storyboardInstance.initialize()!
        let contentViewController = UINavigationController(rootViewController: viewController)
        contentViewController.navigationBar.isHidden = true
        self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    
    @IBAction func btnClickProfile(_ sender: Any) {
        if(APP_DELEGATE.userType != .Parent){
            let viewController: ProfileViewController = ProfileViewController.storyboardInstance.initialize()!
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        }
       
    }
    
    @IBAction func btnTapLogout(_ sender: UIButton) {
        APP_DELEGATE.RemoveAllDefaults()
    }
}

extension SideMenu: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if titleArray[indexPath.row].lowercased() == "self awareness"{
           // let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppSupportViewController") as! AppSupportViewController
            let viewController = UIStoryboard(name: "SelfAwarenessFormViewController", bundle: nil).instantiateViewController(withIdentifier: "SelfAwarenessFormViewController") as! SelfAwarenessFormViewController
            
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            return
        }else if titleArray[indexPath.row].lowercased() == "transport renewal"{
            let viewController = UIStoryboard(name: "TransportRenewalViewController", bundle: nil).instantiateViewController(withIdentifier: "TransportRenewalViewController") as! TransportRenewalViewController
            
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            return
        }else if /*APP_DELEGATE.userType == .Staff  &&*/ titleArray[indexPath.row].lowercased() == "stream selection"{
               // let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppSupportViewController") as! AppSupportViewController
                let viewController = UIStoryboard(name: "StreamSelectionViewController", bundle: nil).instantiateViewController(withIdentifier: "StreamSelectionViewController") as! StreamSelectionViewController
                
                let contentViewController = UINavigationController(rootViewController: viewController)
                contentViewController.navigationBar.isHidden = true
                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
                self.sideMenuViewController!.hideMenuViewController()
                return
            }
        else if titleArray[indexPath.row].lowercased() == "Term Attendance".lowercased(){
               // let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppSupportViewController") as! AppSupportViewController
                let viewController : AttendanceEntryViewController = AttendanceEntryViewController.storyboardInstance.initialize()!
                
                let contentViewController = UINavigationController(rootViewController: viewController)
                contentViewController.navigationBar.isHidden = true
                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
                self.sideMenuViewController!.hideMenuViewController()
                return
        }else if titleArray[indexPath.row].lowercased() == "Chronicles".lowercased() {
            let fileName = self.objChronicles?.data?.file_name ?? ""
            let fileURL = (self.objChronicles?.path ?? "")+fileName
            let title = self.objChronicles?.data?.name ?? ""
            
            let storyBoard = UIStoryboard(name: "NoticeViewController", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                viewController.fileName = fileName
                viewController.Title = title
                viewController.url = URL(string: fileURL)
            
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            return
        }else if titleArray[indexPath.row].lowercased() == "NewsLetter".lowercased() {
            let fileName = self.objNewsletter?.data?.file_name ?? ""
            let fileURL = (self.objNewsletter?.path ?? "")+fileName
            let title = self.objNewsletter?.data?.name ?? ""
            
            let storyBoard = UIStoryboard(name: "NoticeViewController", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                viewController.fileName = fileName
                viewController.Title = title
                viewController.url = URL(string: fileURL)
                
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            return
        }else if titleArray[indexPath.row].lowercased() == "Privacy Policy".lowercased() {

            let storyBoard = UIStoryboard(name: "NoticeViewController", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            viewController.fileName = "Privacy Policy"
            viewController.Title = "Privacy Policy"
            viewController.url = URL(string: URI_PRIVACY_POLICY)
            
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            return
        }else if titleArray[indexPath.row].lowercased() == "ID Card".lowercased() {
            let storyBoard = UIStoryboard(name: "IDCardViewController", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "IDCardViewController") as! IDCardViewController

            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            return
        }
      
        switch titleArray[indexPath.row].lowercased(){
        case "Assignments".lowercased():
            let viewController: AssignmentsViewController = AssignmentsViewController.storyboardInstance.initialize()!
            viewController.viewMode = .assignment
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case "Syllabus".lowercased():
            let viewController: AssignmentsViewController = AssignmentsViewController.storyboardInstance.initialize()!
            viewController.viewMode = .syllabus
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case "Email Groups".lowercased():
            self.callAPIForEmailGroup { (check) in
                if check{
                    self.openPreviewController()
                }
            }
            
        case "Date Sheet".lowercased():
            let viewController: DataSheetViewController = DataSheetViewController.storyboardInstance.initialize()!
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case "Settings".lowercased():
            let viewController: SettingsViewController = SettingsViewController.storyboardInstance.initialize()!
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case "Holiday Homework".lowercased():
            let viewController: HolidayHomeWorkViewController = HolidayHomeWorkViewController.storyboardInstance.initialize()!
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case "Mark Attendance".lowercased():
            let viewController: MarkAttendanceViewController = MarkAttendanceViewController.storyboardInstance.initialize()!
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case "My Attendance".lowercased():
            let myAttendanceViewController = MyAttendanceViewController()
            
            self.sideMenuViewController?.hideMenuViewController()
            
            if let hostViewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController as? HostViewController,
            let navigationController = hostViewController.children.last as? UINavigationController {
                navigationController.pushViewController(myAttendanceViewController, animated: true)
            } else {
                print("navigationController is not available")
            }
            
        case "Fee".lowercased():
            let viewController: FeeViewController = FeeViewController.storyboardInstance.initialize()!
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case "Attandance Summary".lowercased():
            let viewController: AttendanceSummaryViewController = AttendanceSummaryViewController.storyboardInstance.initialize()!
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case "Time Table".lowercased():
            let viewController: TimeTableViewController = TimeTableViewController.storyboardInstance.initialize()!
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case "Attendance Days Entry".lowercased():
            let viewController: AttendanceEntryViewController = AttendanceEntryViewController.storyboardInstance.initialize()!
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case "WISE".lowercased():
            if APP_DELEGATE.userType == LoginType.Nursery
                || APP_DELEGATE.userType == LoginType.Parent
                || APP_DELEGATE.userType == LoginType.School {
                let viewController: NurseryWiseViewController = NurseryWiseViewController.storyboardInstance.initialize()!
                let contentViewController = UINavigationController(rootViewController: viewController)
                contentViewController.navigationBar.isHidden = true
                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
                self.sideMenuViewController!.hideMenuViewController()
                
            }else {
                let viewController: WiseMainViewController = WiseMainViewController.storyboardInstance.initialize()!
                let contentViewController = UINavigationController(rootViewController: viewController)
                contentViewController.navigationBar.isHidden = true
                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
                self.sideMenuViewController!.hideMenuViewController()
            }
            
        case "".lowercased():
            let viewController: AssessmentRecordViewController = AssessmentRecordViewController.storyboardInstance.initialize()!
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case "Notice".lowercased():
            let viewController: NoticeViewController = NoticeViewController.storyboardInstance.initialize()!
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case "Message".lowercased():
            let viewController: MessageViewController = MessageViewController.storyboardInstance.initialize()!
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case "Fee".lowercased():
            let viewController: FeeViewController = FeeViewController.storyboardInstance.initialize()!
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case "Class List".lowercased():
            let viewController: ChildListViewController = ChildListViewController.storyboardInstance.initialize()!
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case "School Calendar".lowercased():
            let viewController: SchoolCalendarViewController = SchoolCalendarViewController.storyboardInstance.initialize()!
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case "School Calendar".lowercased():
            let viewController: TransportViewController = TransportViewController.storyboardInstance.initialize()!
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case "Syllabus".lowercased():
            let viewController: SyllabusViewController = SyllabusViewController.storyboardInstance.initialize()!
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case "Child".lowercased():
            let viewController: ChildListViewController = ChildListViewController.storyboardInstance.initialize()!
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        default:
            print("")
        }
        
        //[, "House List", "Child", "Mark Attendance", "Attandance Summary", "Attendance Days Entry",  , , ]
        
      /*
        switch indexPath.row {
        case 0:
            if (APP_DELEGATE.userType == LoginType.Nursery ||
                APP_DELEGATE.userType == LoginType.School || APP_DELEGATE.userType == LoginType.Parent) {
//                let viewController: AssignmentsViewController = AssignmentsViewController.storyboardInstance.initialize()!
//                viewController.viewMode = .assignment
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }
                
            else {
//                let viewController: TimeTableViewController = TimeTableViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
              //  self.sideMenuViewController!.hideMenuViewController()
            }
            
            
        case 1:
            
            if (APP_DELEGATE.userType == LoginType.Nursery ||
                APP_DELEGATE.userType == LoginType.School || APP_DELEGATE.userType == LoginType.Parent) {
//                let viewController: AssignmentsViewController = AssignmentsViewController.storyboardInstance.initialize()!
//                viewController.viewMode = .syllabus
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }else {
//                self.callAPIForEmailGroup { (check) in
//                    if check{
//                        self.openPreviewController()
//                    }
//                }
            }
            
        case 2:
            if (APP_DELEGATE.userType == LoginType.Nursery ||
                APP_DELEGATE.userType == LoginType.School || APP_DELEGATE.userType == LoginType.Parent){
//                let viewController: DataSheetViewController = DataSheetViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }else {
//                let viewController: SettingsViewController = SettingsViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }
            
        case 3:
            if (APP_DELEGATE.userType == LoginType.Nursery ||
                APP_DELEGATE.userType == LoginType.School || APP_DELEGATE.userType == LoginType.Parent) {
               // self.toast("Coming Soon")
//                let viewController: HolidayHomeWorkViewController = HolidayHomeWorkViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }else{
//   //             let viewController: TimeTableViewController = TimeTableViewController.storyboardInstance.initialize()!
//   //             let contentViewController = UINavigationController(rootViewController: viewController)
//  //              contentViewController.navigationBar.isHidden = true
//  //              self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
// //              self.sideMenuViewController!.hideMenuViewController()
                
//                let viewController: SettingsViewController = SettingsViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }
            
        case 4:
            if APP_DELEGATE.userType == LoginType.Nursery
                || APP_DELEGATE.userType == LoginType.School || APP_DELEGATE.userType == LoginType.Parent {
//                let viewController: SettingsViewController = SettingsViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }else{
//                let viewController: MarkAttendanceViewController = MarkAttendanceViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }
            
        case 5:
            if APP_DELEGATE.userType == LoginType.Parent
                || APP_DELEGATE.userType == LoginType.School
                || APP_DELEGATE.userType == LoginType.Nursery {
//                let viewController: FeeViewController = FeeViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }else {
//                let viewController: AttendanceSummaryViewController = AttendanceSummaryViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }
            
        case 6:
            if APP_DELEGATE.userType == LoginType.Nursery
                || APP_DELEGATE.userType == LoginType.School || APP_DELEGATE.userType == LoginType.Parent {
//                let viewController: TimeTableViewController = TimeTableViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }else {
//                let viewController: AttendanceEntryViewController = AttendanceEntryViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }
            
        case 7:
            if APP_DELEGATE.userType == LoginType.Nursery
                || APP_DELEGATE.userType == LoginType.Parent
                || APP_DELEGATE.userType == LoginType.School {
//                let viewController: NurseryWiseViewController = NurseryWiseViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
                
            }else {
//                let viewController: WiseMainViewController = WiseMainViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }
            
        case 8:
            if APP_DELEGATE.userType == LoginType.Nursery
                || APP_DELEGATE.userType == LoginType.School || APP_DELEGATE.userType == LoginType.Parent {
//                let viewController: AssessmentRecordViewController = AssessmentRecordViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }else {
//                let viewController: NoticeViewController = NoticeViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }
            
        case 9:
            if APP_DELEGATE.userType == LoginType.Parent
                || APP_DELEGATE.userType == LoginType.School
                || APP_DELEGATE.userType == LoginType.Nursery {
//                let viewController: MessageViewController = MessageViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }else {
//                let viewController: FeeViewController = FeeViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }
            
        case 10:
            if APP_DELEGATE.userType == LoginType.School {
//                let viewController: ChildListViewController = ChildListViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }else {
//                let viewController: MessageViewController = MessageViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }
            
        case 11:
            if APP_DELEGATE.userType == LoginType.School {
//                let viewController: FeeViewController = FeeViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }else {
//                let viewController: SchoolCalendarViewController = SchoolCalendarViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }
            
        case 12:
            if APP_DELEGATE.userType == LoginType.School {
//                let viewController: TransportViewController = TransportViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }else{
//                let viewController: SyllabusViewController = SyllabusViewController.storyboardInstance.initialize()!
//                let contentViewController = UINavigationController(rootViewController: viewController)
//                contentViewController.navigationBar.isHidden = true
//                self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
            }
            
            
        default:
            break
        }*/
    }
}

extension SideMenu: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: (collectionView.frame.size.width/2) - 20, height: (collectionView.frame.size.width/2) - 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 0, left: 20, bottom: 0, right: 0)
    }
}

extension SideMenu: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Dequeue cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SideMenuStaffCell.cellId, for: indexPath) as! SideMenuStaffCell
        cell.titleLabel.text = self.titleArray[indexPath.row]
        cell.menuImage.image = UIImage(named: self.imageArray[indexPath.row])
        
        return cell
    }
}
//MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension SideMenu : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //MARK:- ImagePicker Function -
    func oepnImagePicker() {
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let btnCancel = UIAlertAction.init(title:"Cancel" , style: .cancel) { (action) in
        }
        alertController.addAction(btnCancel)
        
        let btnTakePhoto = UIAlertAction.init(title: "Take Photo" , style: .default) { (action) in
            self.openCamera()
        }
        alertController.addAction(btnTakePhoto)
        
        let btnChooseFromLibrary = UIAlertAction.init(title: "Choose from Gallery" , style: .default) { (action) in
            self.openPhotoGallary()
        }
        alertController.addAction(btnChooseFromLibrary)
        
        self.present(alertController, animated: true, completion: nil)
    }
    //MARK: - Open Camera & Library
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.imagePicker.mediaTypes = [kUTTypeImage as String]
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func openPhotoGallary() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black ]
        UINavigationBar.appearance().tintColor = UIColor.black
        self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.imagePicker.mediaTypes = [kUTTypeImage as String]
        self.imagePicker.delegate = self
        
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - UIImagePicker Delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        imageData =  (image.jpegData(compressionQuality: 0.1)!)
        self.imgProfile.image = image
        self.dismiss(animated: true) {
            if self.imageData != nil {
                self.imgProfile.image = image
                //self.btnEditProfile.isHidden = false
                //self.btnCamera.isHidden = true
                self.apiUploadRequestWithImage()
               // self.configureUI()
            }
        }
        
    }
}
extension SideMenu {
    func apiUploadRequestWithImage() {
        
        URLCache.shared.removeAllCachedResponses()
        
       // if Connectivity.isConnectedToInternet() {

            var headersParam: [String : String] = [String : String]()
            print( "this is token ===========================",APP_DELEGATE.token)
        if APP_DELEGATE.token == ""{
            print("token was nil")
            print("token in json == ",APP_DELEGATE.loginAPIResponse?.metaData?.token)
        }
            headersParam = ["Authorization": "Bearer " + APP_DELEGATE.token]
            
            //headersParam[KEYS.IPAddressCapital] = GlobalVars.UserM.ipAddress
            //headersParam[KEYS.ContentType] = KEYS.ContentTypeApplicationJSON
            
            let finalUrl = API_UPLOADIMAGE
            
            print("URL:\(String(describing: finalUrl))")
            print("Header:\(String(describing: headersParam))")
            print("Param:\(headersParam)")
            
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                multipartFormData.append(self.imageData!, withName: "attachment", fileName: "Parent-profile.jpg", mimeType: "image/jpg")
                
                
//                for (key, value) in parameters {
//                    multipartFormData.append(self.serialize(value)!, withName: key)
     //           }
            }, to: finalUrl, method: .post, headers: headersParam, encodingCompletion: { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON(completionHandler: { (response) in
                        print(response.request!)
                        if(response.result.value != nil){
                            print(response.result.value!)
                            let dict = APIParser(response: response.result.value!)
                            print(dict.file_name )
                            UserDefaults.standard.set(dict.file_name, forKey: "ParentProfile")
                            self.toast(dict.Message)
                            
                        }
                                            
                    })
                case .failure(let encodingError):
                    break
                    
                }
            })
    }
    
    func callAPIForEmailGroup(finished:@escaping(_ success: Bool) -> Void){
        Loader.show()
        StaffManageMentAPI.getEmailGroup() { (respose, error) in
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
            self.emailGroupResponse = responseData
            finished(true)
        }
    }
    
    func callAPIForStaffDashboard(finished:@escaping(_ success: Bool) -> Void){
                    Loader.show()
                    StaffManageMentAPI.StaffDashboardApi() { (respose, error) in
                        Loader.hide()
                        guard let response = respose else {
                           // self.toast(error?.localizedDescription ?? "Invalid Response")
                            finished(false)
                            return
                        }
                        self.objChronicles = response.chronicles
                        self.objNewsletter = response.newsletter
                        
                        if self.objChronicles?.data == nil{
                            if let index = self.titleArray.firstIndex(of: "Chronicles"){
                                self.imageArray.remove(at: index)
                                self.titleArray.remove(at: index)
                            }
                        }
                        
                        if self.objNewsletter?.data == nil{
                            if let index = self.titleArray.firstIndex(of: "NewsLetter"){
                                self.imageArray.remove(at: index)
                                self.titleArray.remove(at: index)
                            }
                        }
                        
                        self.collectionView.reloadData()
                        
                        finished(true)
                    }
            }
    
    func callAPIForSelfAwernessMenu(finished:@escaping(_ success: Bool) -> Void){
                    Loader.show()
                    StudentManagementAPI.ShowSelfAwernessInMenu() { (respose, error) in
                        Loader.hide()
                        guard let response = respose else {
                           // self.toast(error?.localizedDescription ?? "Invalid Response")
                            finished(false)
                            return
                        }
                        
                        APP_DELEGATE.year_session = response.session_details?.year_session ?? ""
                        APP_DELEGATE.standardSectionData = response.nomination?.setting?.standard_section_id
                        
                        if (response.id_card?.is_show ?? false) == true{                            
                            self.imageArray.insert("id-card_image", at: self.imageArray.count-1)
                            self.titleArray.insert("ID Card", at: self.titleArray.count-1)
                        }
                        
                        
                        
                        if let responseData = response.self_awareness?.setting {
                            APP_DELEGATE.student_Branch_code = responseData.branch_code ?? 0
                    
                            let arrSDate = (responseData.start_date ?? "").components(separatedBy: "T")
                            let arrEDate = (responseData.end_date ?? "").components(separatedBy: "T")

                            let combineSdateStime = (arrSDate.first ?? "") + " " + (responseData.start_time ?? "")
                            let combineEdateEtime = (arrEDate.first ?? "") + " " + (responseData.end_time ?? "")
                            
                            print(combineSdateStime)
                            print(combineEdateEtime)
                                       
                            let S_fullDate = CommonFunctions.getStringToDate(Format: DateFormat.ddMMyyyyhhMM, strDate: combineSdateStime)
                            let E_fullDate = CommonFunctions.getStringToDate(Format: DateFormat.ddMMyyyyhhMM, strDate: combineEdateEtime)
                            
    //                        print(S_fullDate)
    //                        print(E_fullDate)
    //
    //                        print(CommonFunctions.getDateInString(date: S_fullDate, strDateFormat: DateFormat.ddMMyyyyhhMM))
    //                        print(CommonFunctions.getDateInString(date: E_fullDate, strDateFormat:  DateFormat.ddMMyyyyhhMM))
                            
                            
                            if Date() >= S_fullDate{
                                if Date() <= E_fullDate{
                                    if !self.imageArray.contains("SelfAwerness"){
                                        let stclass = APP_DELEGATE.selected_Student?.studentId?.standardId?.name ?? ""
                                        
                                        if self.containStandrad(value: stclass){
                                           // self.imageArray.append("SelfAwerness")
                                          //  self.titleArray.append("Self Awareness")
                                            
                                            self.imageArray.insert("SelfAwerness", at: self.imageArray.count-1)
                                            self.titleArray.insert("Self Awareness", at: self.titleArray.count-1)
                                        }
                                    }
                                }else{
                                    print("Date is bigger than end date")
                                }
                            }else{
                                print("Date is less than start date")
                            }
                        }
                      
                        if let reponseDataForStream = response.stream?.data{
                            APP_DELEGATE.streamSelectionInfo = reponseDataForStream
                        }
                        if let responseData = response.stream?.setting {
                            APP_DELEGATE.student_Branch_code = responseData.branch_code ?? 0
                            APP_DELEGATE.student_LastStreamSelectionEnd_time = responseData.end_date ?? ""
                            let arrSDate = (responseData.start_date ?? "").components(separatedBy: "T")
                            let arrEDate = (responseData.end_date ?? "").components(separatedBy: "T")

                            let combineSdateStime = (arrSDate.first ?? "") + " " + (responseData.start_time ?? "")
                            let combineEdateEtime = (arrEDate.first ?? "") + " " + (responseData.end_time ?? "")
                            
                            print(combineSdateStime)
                            print(combineEdateEtime)
                                       
                            let S_fullDate = CommonFunctions.getStringToDate(Format: DateFormat.ddMMyyyyhhMM, strDate: combineSdateStime)
                            let E_fullDate = CommonFunctions.getStringToDate(Format: DateFormat.ddMMyyyyhhMM, strDate: combineEdateEtime)
                                                        
                            
                            if Date() >= S_fullDate{
                                if Date() <= E_fullDate{
                                    let studentClass = APP_DELEGATE.selected_Student?.studentId?.standardId?.name ?? ""
                                    print(studentClass)
                                    if studentClass == "X" || studentClass == "x"{ // only for class 10th student
                                        if !self.imageArray.contains("StreamSelection"){
                                            //self.imageArray.append("StreamSelection")
                                            //self.titleArray.append("Stream Selection")
                                            self.imageArray.insert("StreamSelection", at: self.imageArray.count-1)
                                            self.titleArray.insert("Stream Selection", at: self.titleArray.count-1)
                                        }
                                    }
                                }else{
                                    print("Date is bigger than end date")
                                }
                            }else{
                                print("Date is less than start date")
                            }
                            
                        }
                        
                        APP_DELEGATE.Show_transport_renewal_form = response.transport_renewal_form?.is_show ?? false
                        APP_DELEGATE.Show_transport_request = response.transport_request?.is_show ?? false
                        
                        if let homevc = ((UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController as? HostViewController)?.children.last as? UINavigationController)?.viewControllers.last as? HomeViewController{
                            homevc.configureActionNeededView()
                        }
                        
                        if APP_DELEGATE.Show_transport_renewal_form{
                            
                            if !self.imageArray.contains("TransportImage"){
                                self.imageArray.insert("TransportImage", at: self.imageArray.count-1)
                                self.titleArray.insert("Transport Renewal", at: self.titleArray.count-1)
                                
                                //self.imageArray.append("TransportImage")
                               // self.titleArray.append("Transport Renewal")
                            }
                            
                        }
                        
//                        if !self.imageArray.contains("StreamSelection"){
//                            self.imageArray.append("StreamSelection")
//                            self.titleArray.append("Stream Selection")
//                        }
                        
                        self.objChronicles = response.chronicles
                        self.objNewsletter = response.newsletter
                        
                        if self.objChronicles?.data == nil{
                            if let index = self.titleArray.firstIndex(of: "Chronicles"){
                                self.imageArray.remove(at: index)
                                self.titleArray.remove(at: index)
                            }
                        }
                        
                        if self.objNewsletter?.data == nil{
                            if let index = self.titleArray.firstIndex(of: "NewsLetter"){
                                self.imageArray.remove(at: index)
                                self.titleArray.remove(at: index)
                            }
                        }
                        
                        self.collectionView.reloadData()
                        
                        finished(true)
                    }
            }
                
    private func containStandrad(value:String)->Bool{
        print(value)
        if value.lowercased() == "iv"{
            return true
        }else if value.lowercased() == "v"{
            return true
        }else if value.lowercased() == "vi"{
            return true
        }else if value.lowercased() == "vii"{
            return true
        }else if value.lowercased() == "viii"{
           return true
        }
        return false
    }
    
    func openPreviewController(){
       // Loader.show()
      //  let previewController = QLPreviewController()
       // previewController.dataSource = self as! QLPreviewControllerDataSource
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        guard let fileURL = URL(string: emailGroupResponse?.email_group_file ?? "") else {
            self.toast("Email sheet url was not correct")
            return}
        let fileName = "Email Groups.xlsx"
        let title = "Email Groups.xlsx"
        
        let storyBoard = UIStoryboard(name: "NoticeViewController", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            viewController.fileName = fileName
            viewController.Title = title
            viewController.url = fileURL
            self.present(viewController, animated: true, completion: nil)
      /*  CommonFunctions.downloadfile(viewcontroller: self, url: url, mimeType: "", fileName: "Email Groups.xlsx" ) { (check, strURLPath) in
            Loader.hide()
            if(check){
                
                self.previewItem = strURLPath! as NSURL as URL
                // Display file
                let previewController = QLPreviewController()
                previewController.dataSource = self
                previewController.navigationController?.navigationBar.tintColor = UIColor.black
                self.present(previewController, animated: true, completion: nil)
                print("URL ::: \(strURLPath)")
            }
        }*/
    }
}


//MARK:- QLPreviewController Datasource

extension SideMenu: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        
        return self.previewItem! as QLPreviewItem
    }
}
class APIParser: NSObject {
    
    var Status      : Bool = false
    var StatusCode  : Int = 500
    var Message     : String = "Network Error.\nPlease Try Again Later"
    var Result      = [String: Any]()
    var ResultArr   = [Any]()
    var Token       = ""
    var file_name   = ""
    override init() {
        super.init()
    }
    
    required init(response: Any!) {
        super.init()
        
        var data = [String: Any]()
        if let temp = response as? [String: Any] {
            data = temp
        }
        
        // getting the status
        if let value = data["status"] as? NSNumber {
            Status = value.boolValue
        } else if let value = data["status"] as? String {
            
            let aString = NSString(string: value)
            Status = aString.boolValue
            
            //Status = Bool(value)!
        } else if let value = data["status"] as? Bool {
            Status = value
        }
        
        
        
        // Getting api response message
        if let value = data["message"] as? String {
            Message = value
        }
        
        if let value = data["file_name"] as? String {
            file_name = value
        }
    }
}

    

