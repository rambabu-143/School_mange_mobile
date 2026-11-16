//
//  HomeViewController.swift
//  MountCarmel
//
//  Created by Apple on 01/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import SDWebImage

fileprivate let isClearCacheEnabled = true
internal var isDeleteSnapEnabled = false

class HomeViewController: UIViewController {

    @IBOutlet weak var actionNeededView: UIView!
    @IBOutlet weak var actionNeededTitle: UILabel!
    @IBOutlet weak var actionNeededHeading: UILabel!
    @IBOutlet weak var actionNeededDescription: UILabel!
    
    @IBOutlet weak var actionNeededViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var lblGreetingStatus: UILabel!
    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet weak var tabBarView: TabBarView!
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var collectionViewHorizontal: UICollectionView!
    @IBOutlet weak var viewTopCollection: UIView!
    
    // Top level Horizontal list view
    var imageArray = ["Class_List", "House_List", "child", "Disciplinary_Card"/*"Time_Table"*/]
    var titleArray = ["Class List", "House List", "Child", "Disciplinary Card"/*"Time Table"*/]
    var cellBgColor = [#colorLiteral(red: 0.5462506413, green: 0.7703248858, blue: 0.8425061703, alpha: 1), #colorLiteral(red: 0.8408686519, green: 0.7620797753, blue: 0.1854289472, alpha: 1), #colorLiteral(red: 0.8588235294, green: 0.7058823529, blue: 0.2549019608, alpha: 1), #colorLiteral(red: 0.2823529412, green: 0.4666666667, blue: 0.137254902, alpha: 1)] // Color for Junior Code students
    var StaffColorForCell = [#colorLiteral(red: 0.5607843137, green: 0.1607843137, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.2784313725, green: 0.462745098, blue: 0.6588235294, alpha: 1),#colorLiteral(red: 0.8588235294, green: 0.7058823529, blue: 0.2549019608, alpha: 1),#colorLiteral(red: 0.2823529412, green: 0.4666666667, blue: 0.137254902, alpha: 1)] // Color for Staff
    var CommonColorForCell = [#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.8588235294, green: 0.7058823529, blue: 0.2549019608, alpha: 1),#colorLiteral(red: 0.2823529412, green: 0.4666666667, blue: 0.137254902, alpha: 1)] // Color for Senior Students
    
    // Grid view
    var imageArrayHorizontal = [["Mark_Attendance", "Attendance_Summary"], ["Disciplinary_Card", "WISE"]]
    var titleArrayHorizontal = [["Mark Attendance", "Attendance Summary"], ["Disciplinary Card", "WISE"]]
    var cellBgColorHorizontal = [[#colorLiteral(red: 0.8484866619, green: 0.4934764504, blue: 0.503978014, alpha: 1), #colorLiteral(red: 0.6747093201, green: 0.8929780126, blue: 0.3211398125, alpha: 1)], [#colorLiteral(red: 0.9170966744, green: 0.8086184859, blue: 0.1855668426, alpha: 1), #colorLiteral(red: 0.5502712131, green: 0.7739598155, blue: 0.8386949301, alpha: 1)]]
    
    private var viewModel: IGHomeViewModel = IGHomeViewModel()
    private var storyJson = [String:Any]()
    
    private var smsCount = 0
    
    private var isStaff:Bool{
        if APP_DELEGATE.userType == LoginType.Staff{
            return true
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        navigationView.btnBack.isHidden = true
        navigationView.lblTitle.isHidden = true
        tabBarView.delegate = self
        navigationView.delegate = self
        navigationView.setUpNavigationDropDown(view_cont: self)
        
        self.configureCollectionView()
        self.configureDataAccordingLoginType()
    
//        NotificationViewController.callAPIForNotificationList { (success, response, unreadCount, message) in
//            APP_DELEGATE.notificationUnreadCount = unreadCount ?? 0
//            self.navigationView.willMove(toWindow: APP_DELEGATE.window)
//        }
        
        APP_DELEGATE.UpdateFcmToken()
        
        self.setGreetings()

        self.fetchStudentDetails()
        
      /*  DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
            fatalError("crashlytics testing")
        }*/
     
        self.callAPIForStaffUploads(isstaff: isStaff) { success in
            if success{
                if UserDefaults.standard.bool(forKey: "StoryChecked") == false{
                    self.onTapStory()
                }
            }
        }
        
        hideActionNeededView()        
    }
    
    func fetchStudentDetails() {
        if APP_DELEGATE.userType == LoginType.Parent || APP_DELEGATE.userType == LoginType.School || APP_DELEGATE.userType == LoginType.Nursery {
            self.callAPIStudentDetails { (success, data) in
                if success {
                    APP_DELEGATE.partStudentDetails = [
                        "social_media_consent_visible": data?.data?.social_media_consent?.is_visible ?? nil,
                        "social_media_policy_path": data?.data?.social_media_consent?.path ?? nil
                    ]
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.callAPIForNotificationCount { _ in }

    }

    private func callAPIForStaffUploads(isstaff:Bool,finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
      StaffManageMentAPI.storyUploads(isstaff: isstaff) { (respose,url, error) in
            Loader.hide()
            if let res = respose, let U = url{
                    self.navigationView.btnStory.isHidden = false
                if U.contains(".mp4"){
                    self.navigationView.btnStory.setImage(U.thumbnail(), for: .normal)
                }else{
                    self.navigationView.btnStory.sd_setImage(with: URL(string: url ?? ""), for: .normal, placeholderImage: #imageLiteral(resourceName: "profile-placeholder"),options: [], context: nil)
                }
                self.storyJson = res
                
                finished(true)
            }else{
                finished(false)
            }
        }
    }
    
    internal func callAPIForNotificationCount(completion:@escaping(Int)->()){
       // Loader.show()
        StaffManageMentAPI.GetNotificationCount(isstaff: isStaff) { smsCount, notificationCount, error in
           // Loader.hide()
            APP_DELEGATE.notificationUnreadCount = notificationCount
            self.navigationView.willMove(toWindow: APP_DELEGATE.window)
            
            self.smsCount = smsCount
            self.collectionView.reloadData()
            
            UIApplication.shared.applicationIconBadgeNumber = (notificationCount + smsCount)
            
            completion(notificationCount)
        }
    }
    
    func setGreetings(){
        
        self.lblGreetingStatus.font = UIFont.setRegularFont(ofSize: 18.0)
        
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 6..<12 : self.lblGreetingStatus.text = "Good Morning!"
        case 12..<17 : self.lblGreetingStatus.text = "Good Afternoon!"
        case 17..<24 : self.lblGreetingStatus.text = "Good Evening!"
        default: self.lblGreetingStatus.text = "Good Night!"
        }
    }
    
    func hideActionNeededView() {
        actionNeededView.isHidden = true
        actionNeededViewHeightConstraint.constant = 0
    }
    
    func showActionNeededView() {
        actionNeededView.isHidden = false
        actionNeededViewHeightConstraint.constant = 112
    }
    
    func configureActionNeededView() {
       if APP_DELEGATE.Show_transport_request == true {
            actionNeededTitle.text = "Good News!"
            actionNeededHeading.text = "School Transport is available for your ward in (2025-26)"
            actionNeededDescription.text = "Click here for more details"
            showActionNeededView()
            return
       }

       hideActionNeededView()
    }
    
    func layoutCollectionViewCell(){
        self.collectionView.reloadData()
    }
    
    func configureCollectionView() {
        // Register Cell
        let cellNib = UINib(nibName: String(describing: SideMenuStaffCell.self), bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: SideMenuStaffCell.cellId)
        
        // Register Cell
        let cellNibHorizontal = UINib(nibName: String(describing: HomeScreenCell.self), bundle: nil)
        self.collectionViewHorizontal.register(cellNibHorizontal, forCellWithReuseIdentifier: HomeScreenCell.cellId)
    }
    
    func configureDataAccordingLoginType() {
        print(APP_DELEGATE.userType)
        if APP_DELEGATE.userType == LoginType.Parent {
            self.imageArray = ["ar-1", "Gallery_S-1", "staff_notice", "staff_message"]
            self.titleArray = ["AR", "Gallerie", "Notice", "Messages"]
            
            self.titleArrayHorizontal = [["Attendance", "School Calendar"], ["Disciplinary Card"/*"Time Table"*/, "WISE", ], ["Homework"]]
            self.imageArrayHorizontal = [["Attendance_S", "School_Calendar_S"], ["Disciplinary_Card"/*"Time_Table_S"*/, "WISE"], ["Holiday_Homework_P"]]
            self.cellBgColorHorizontal = [[#colorLiteral(red: 0.8484866619, green: 0.4934764504, blue: 0.503978014, alpha: 1), #colorLiteral(red: 0.6747093201, green: 0.8929780126, blue: 0.3211398125, alpha: 1)], [#colorLiteral(red: 0.9170966744, green: 0.8086184859, blue: 0.1855668426, alpha: 1), #colorLiteral(red: 0.5502712131, green: 0.7739598155, blue: 0.8386949301, alpha: 1)], [#colorLiteral(red: 0.7960784314, green: 0.7137254902, blue: 1, alpha: 1)]]
            
            if juniorBranchCodes.contains(APP_DELEGATE.selected_Student?.studentId?.year_branch ?? 0){
                self.imageArrayHorizontal = [["Attendance_N", "School_Calendar_N"], ["Disciplinary_Card"/*"Time_Table_N"*/, "WISE"], ["Holiday_Homework_N"]]
            }else if seniorBranchCodes.contains(APP_DELEGATE.selected_Student?.studentId?.year_branch ?? 0){
                self.imageArrayHorizontal = [["Attendance", "School_Calendar"], ["Disciplinary_Card"/*"Time_Table"*/, "WISE"], ["Holiday_Homework"]]
            }
        }else if APP_DELEGATE.userType == LoginType.School {
            self.imageArray = ["ar-1", "Gallery_S-1", "staff_notice", "staff_message"]
            self.titleArray = ["AR", "Gallerie", "Notice", "Messages"]

            self.titleArrayHorizontal = [["Attendance", "School Calendar"], ["Disciplinary Card"/*"Time Table"*/, "WISE", ], ["Homework"]]
            self.imageArrayHorizontal = [["Attendance", "School_Calendar"], ["Disciplinary_Card"/*"Time_Table"*/, "WISE"], ["Holiday_Homework"]]
            self.cellBgColorHorizontal = [[#colorLiteral(red: 0.8484866619, green: 0.4934764504, blue: 0.503978014, alpha: 1), #colorLiteral(red: 0.6747093201, green: 0.8929780126, blue: 0.3211398125, alpha: 1)], [#colorLiteral(red: 0.9170966744, green: 0.8086184859, blue: 0.1855668426, alpha: 1), #colorLiteral(red: 0.5502712131, green: 0.7739598155, blue: 0.8386949301, alpha: 1)], [#colorLiteral(red: 0.7960784314, green: 0.7137254902, blue: 1, alpha: 1)]]
           // self.imageArrayHorizontal = [["Attendance_S", "School_Calendar_S"], ["Time_Table_S", "WISE"]]
        }else if APP_DELEGATE.userType == LoginType.Nursery {
            self.imageArray = ["ar-1", "Gallery_S-1", "staff_notice", "staff_message"]
            self.titleArray = ["AR", "Gallerie", "Notice", "Messages"]
            
            self.titleArrayHorizontal = [["Attendance", "School Calendar"], ["Disciplinary Card"/*"Time Table"*/, "WISE", ], ["Homework"]]
            self.imageArrayHorizontal = [["Attendance_N", "School_Calendar_N"], ["Disciplinary_Card"/*"Time_Table_N"*/, "WISE"], ["Holiday_Homework_N"]]
            self.cellBgColorHorizontal = [[#colorLiteral(red: 0.8484866619, green: 0.4934764504, blue: 0.503978014, alpha: 1), #colorLiteral(red: 0.6747093201, green: 0.8929780126, blue: 0.3211398125, alpha: 1)], [#colorLiteral(red: 0.9170966744, green: 0.8086184859, blue: 0.1855668426, alpha: 1), #colorLiteral(red: 0.5502712131, green: 0.7739598155, blue: 0.8386949301, alpha: 1)], [#colorLiteral(red: 0.7960784314, green: 0.7137254902, blue: 1, alpha: 1)]]
        }else{
             self.imageArray = ["staff_class", "staff_home", "staff_notice", "staff_message"]
             self.titleArray = ["Class List", "House List", "Notice", "Messages"]
            
            self.titleArrayHorizontal = [["Mark Attendance", "Attendance Summary"], ["Disciplinary Card", "WISE"], ["Assign Homework", "View Assigned Homeworks"]]
            self.imageArrayHorizontal = [["Mark_Attendance", "Attendance_Summary"], ["Disciplinary_Card", "WISE"], ["Holiday_Homework", "Holiday_Homework_N"]]
            self.cellBgColorHorizontal = [[#colorLiteral(red: 0.8484866619, green: 0.4934764504, blue: 0.503978014, alpha: 1), #colorLiteral(red: 0.6747093201, green: 0.8929780126, blue: 0.3211398125, alpha: 1)], [#colorLiteral(red: 0.9170966744, green: 0.8086184859, blue: 0.1855668426, alpha: 1), #colorLiteral(red: 0.5502712131, green: 0.7739598155, blue: 0.8386949301, alpha: 1)], [#colorLiteral(red: 0.7960784314, green: 0.7137254902, blue: 1, alpha: 1), .white]]
        }
    }
    //MARK:- Action Event -
    
    @IBAction func btnWiseClick(_ sender: Any) {
        if let viewController: WiseMainViewController = WiseMainViewController.storyboardInstance.initialize() {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    @IBAction func btnAttendanceDayClick(_ sender: Any) {
        if let viewController: AttendanceEntryViewController = AttendanceEntryViewController.storyboardInstance.initialize() {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    @IBAction func btnHomeworkClick(_ sender: Any) {
        if let viewController: HomeworkViewController = HomeworkViewController.storyboardInstance.initialize() {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    @IBAction func handleActionNeededPress(_ sender: UIButton) {        
        var year = APP_DELEGATE.year_session
        let years = year.split(separator: "-")
        if years.count == 2,
           let startYear = Int(years[0].trimmingCharacters(in: .whitespacesAndNewlines)),
           let endYear = Int(years[1].trimmingCharacters(in: .whitespacesAndNewlines)) {
            year = "\(startYear+1)-\(endYear+1)"
        }
        
        if let viewController: WebViewScreenController = WebViewScreenController.storyboardInstance.initialize() {
            viewController.navbarTitle = "Transport Request \(year)"
            
            let sid = if APP_DELEGATE.userType == LoginType.Nursery ||
                APP_DELEGATE.userType == LoginType.School ||
                APP_DELEGATE.userType == LoginType.Parent {
                APP_DELEGATE.selected_Student?.studentId?.ID ?? ""
            } else {
                APP_DELEGATE.userInfo?.staffId?.ID ?? ""
            }
            
            viewController.urlToOpen = URL(string: API_TRANSPORT_REQUEST.replacingOccurrences(of: API_KEY_ID, with: sid))
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: - Student Details API
extension HomeViewController {
    func callAPIStudentDetails(finished:@escaping(_ success: Bool, _ response: StudentDetailAPIResponse?) -> Void) {
        Loader.show()

        StudentManagementAPI.getStuddentDetails(studentID: APP_DELEGATE.selected_Student?.studentId?.ID ?? "") { (response, error) in
            Loader.hide()
            guard let response = response else {
                let _ = error?.localizedDescription ?? "Invalid Response"
                finished(false, nil)
                return
            }
            guard response.status == true else {
                self.toast(response.message ?? "")
                finished(false, nil)
                return
            }
            guard let _ = response.message else {
                let _ = response.message ?? "Invalid Response"
                finished(false, nil)
                return
            }
            finished(true, response)
        }
    }
}

extension HomeViewController: NavigationBarViewDelegate {
    func onTapDropDown() {
        
        if let vc: SelectStudentPopViewController = SelectStudentPopViewController.storyboardInstance.initialize() {
            
            vc.modalPresentationStyle = .overCurrentContext
            vc.doneHandler = { (strDesc) in
               
                
                if(APP_DELEGATE.userInfo?.type?.uppercased() == "STAFF"){
                    // In Staff Login on zero index we need to show Staff Data.So student Data shoud start with index 1
                    
                    if(strDesc == 0){
                        let userInfo = APP_DELEGATE.userInfo
                        let urlPath = APP_DELEGATE.urlPath + "/"
                        let imageURL = urlPath + (userInfo?.staffId?.profile_pic ?? "")
                        
                        self.navigationView.lblDropDownName.text = userInfo?.name ?? ""
                        self.navigationView.imgDropDown.sd_setImage(with: URL(string: imageURL ), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
                        APP_DELEGATE.selected_Student = nil
                        APP_DELEGATE.userType = LoginType.Staff
                        
                    }else{
                        let student = APP_DELEGATE.userInfo?.students?[strDesc - 1]
                        APP_DELEGATE.selected_Student = student
                        self.navigationView.lblDropDownName.text = student?.studentId?.name ?? ""
                        //studentImageIssue
                        self.navigationView.imgDropDown.sd_setImage(with: URL(string: student?.studentId?.profile_pic ?? ""), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
                        
                        if juniorBranchCodes.contains(student?.studentId?.year_branch ?? 0){
                            APP_DELEGATE.userType = LoginType.Nursery
                        }else{
                            APP_DELEGATE.userType = LoginType.School
                        }
                        
                      /*  if student?.studentId?.school_type?.uppercased() == "JUNIOR"{
                            APP_DELEGATE.userType = LoginType.Nursery
                        }else{
                            APP_DELEGATE.userType = LoginType.School
                        }*/
                    }
                    APP_DELEGATE.manageApplicationRoot()
                }else{
                    
                    let student = APP_DELEGATE.userInfo?.students?[strDesc]
                    APP_DELEGATE.selected_Student = student
                    self.navigationView.lblDropDownName.text = student?.studentId?.name ?? ""
                    //studentImageIssue
                    self.navigationView.imgDropDown.sd_setImage(with: URL(string: student?.studentId?.profile_pic ?? ""), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
                    self.tabBarView.configureUIAccordingLoginType()
                }
                
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    func onTapMenu() {
        
    }
    
    func onTapBack() {
        
    }
    func onTapStory() {
        DispatchQueue.main.async {
            if let stories = self.viewModel.getStories(response: self.storyJson), let stories_copy = try? stories.copy().otherStories {
                let storyPreviewScene = IGStoryPreviewController.init(stories: stories_copy, handPickedStoryIndex:  0, handPickedSnapIndex: 0)
                storyPreviewScene.view.backgroundColor = .black
                storyPreviewScene.modalPresentationStyle = .fullScreen
                UserDefaults.standard.set(true, forKey: "StoryChecked")
                self.present(storyPreviewScene, animated: true, completion: nil)
            }
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
//        let a : Int? = nil
//        print(a!)
    }
}

extension HomeViewController: TabBarViewDelegate {
    func onTapSettings() {
        if let viewController: SettingsViewController = SettingsViewController.storyboardInstance.initialize() {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func onTapNotice() {
        if (APP_DELEGATE.userType == LoginType.Nursery || APP_DELEGATE.userType == LoginType.School || APP_DELEGATE.userType == LoginType.Parent ){
            if let viewController: MyTeacherViewController = MyTeacherViewController.storyboardInstance.initialize() {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        else {
            /*if let viewController: NoticeViewController = NoticeViewController.storyboardInstance.initialize() {
                self.navigationController?.pushViewController(viewController, animated: true)
            }*/
            if let viewController: FeeViewController = FeeViewController.storyboardInstance.initialize() {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func onTapProfile() {
        if let viewController: ProfileViewController = ProfileViewController.storyboardInstance.initialize() {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func onTapMessages() {
        let alertController = UIAlertController.init(title: "Heads Up!", message: "If you log out, you will stop receving further notifications from school.", preferredStyle: .alert)
        
        let btnCancel = UIAlertAction.init(title:"Cancel" , style: .cancel) { (action) in
        }
        alertController.addAction(btnCancel)
        
        let btnTakePhoto = UIAlertAction.init(title: "Continue" , style: .default) { (action) in
            APP_DELEGATE.RemoveAllDefaults()
            
        }
        alertController.addAction(btnTakePhoto)
        
        self.present(alertController, animated: true, completion: nil)
        
//        if let viewController: MessageViewController = MessageViewController.storyboardInstance.initialize() {
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }
    }
    
    func onTapFee() {
        
        if APP_DELEGATE.userType == LoginType.Parent || APP_DELEGATE.userType == LoginType.Nursery {
            self.dismiss(animated: true, completion: nil)
        }else {
            if let viewController: FeeViewController = FeeViewController.storyboardInstance.initialize() {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 100 {
            return CGSize.init(width: (collectionView.frame.size.width/4) - 0, height: (collectionView.frame.size.width/4) - 0)
        }else {
            if APP_DELEGATE.userType == LoginType.Staff {
                if (indexPath.section == 0 && indexPath.row == 0) ||
                    (indexPath.section == 1 && indexPath.row == 1) ||
                    (indexPath.section == 2 && indexPath.row == 0) {
                    return CGSize.init(width: (collectionView.frame.size.width/2) + 15, height: (collectionView.frame.size.height/2) - (DeviceType.IS_IPHONE_6 ? 30 : 80))
                }
                return CGSize.init(width: (collectionView.frame.size.width/2) - 25, height: (collectionView.frame.size.height/2) - (DeviceType.IS_IPHONE_6 ? 30 : 80))
            }
            if (indexPath.section == 0 && indexPath.row == 0) || (indexPath.section == 1 && indexPath.row == 1) {
                return CGSize.init(width: (collectionView.frame.size.width/2) + 15, height: (collectionView.frame.size.height/2) - (DeviceType.IS_IPHONE_6 ? 30 : 80))
            }
            if (indexPath.section == 2 && indexPath.row == 0) {
                return CGSize.init(width: (collectionView.frame.size.width), height: (collectionView.frame.size.height/2) - (DeviceType.IS_IPHONE_6 ? 30 : 80))
            }
            return CGSize.init(width: (collectionView.frame.size.width/2) - 25, height: (collectionView.frame.size.height/2) - (DeviceType.IS_IPHONE_6 ? 30 : 80))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 200 {
            
            if APP_DELEGATE.userType == LoginType.Nursery || APP_DELEGATE.userType == LoginType.School || APP_DELEGATE.userType == LoginType.Parent || APP_DELEGATE.userType == LoginType.Staff {
                return UIEdgeInsets (top: 10, left: 0, bottom: 0, right: 0)
            }
            
            if section == 1 {
                return UIEdgeInsets (top: 10, left: 0, bottom: 0, right: 0)
            }else{
                return UIEdgeInsets (top: 0, left: 10, bottom: 0, right: 0)
            }
        }
        
        return UIEdgeInsets (top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 100 {
            if indexPath.row == 0 {
                if (
                    APP_DELEGATE.userType == LoginType.School
                    || APP_DELEGATE.userType == LoginType.Nursery
                    || APP_DELEGATE.userType == LoginType.Parent
                ) {
                    
                    if let partStudentDetails = APP_DELEGATE.partStudentDetails,
                       let showConsentVisibleModal = partStudentDetails["social_media_consent_visible"] as? Bool?,
                       showConsentVisibleModal == true,
                       let policyUri = partStudentDetails["social_media_policy_path"] as? String?,
                       policyUri != nil
                    {
                        let smConsentFormViewController = SMConsentFormViewController()
                        smConsentFormViewController.policyUri = policyUri
                        smConsentFormViewController.modalPresentationStyle = .pageSheet
                        
                        smConsentFormViewController.sheetPresentationController?.prefersGrabberVisible = true
                        smConsentFormViewController.sheetPresentationController?.detents = [.large()]
                        
                        smConsentFormViewController.onDismissWithResult = { success in
                            if (success) {
                                self.fetchStudentDetails()
                                if let viewController: AssessmentRecordViewController = AssessmentRecordViewController.storyboardInstance.initialize() {
                                    self.navigationController?.pushViewController(viewController, animated: true)
                                }
                            } else {
                                print("JS closed the sheet with a cancel state.");
                            }
                        };
                        self.present(smConsentFormViewController, animated: true, completion: nil)
                    } else if let viewController: AssessmentRecordViewController = AssessmentRecordViewController.storyboardInstance.initialize() {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                    
                }
                else {
                    if let viewController: ClassListViewController = ClassListViewController.storyboardInstance.initialize() {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
                
            }else if indexPath.row == 1 {
                if APP_DELEGATE.userType == LoginType.Parent
                    || APP_DELEGATE.userType == LoginType.School
                    || APP_DELEGATE.userType == LoginType.Nursery {
                    if let viewController: GalleryViewController = GalleryViewController.storyboardInstance.initialize() {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
                else{
                    if let viewController: HouseListViewController = HouseListViewController.storyboardInstance.initialize() {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
               
            }else if indexPath.row == 2 {
                
                if let viewController: NoticeViewController = NoticeViewController.storyboardInstance.initialize() {
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                
            } else if indexPath.row == 3 {
                if let viewController: MessageViewController = MessageViewController.storyboardInstance.initialize() {
                    
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }else {
            if indexPath.section == 0 && indexPath.row == 0 {
                
                if APP_DELEGATE.userType == LoginType.Parent
                    || APP_DELEGATE.userType == LoginType.School
                    || APP_DELEGATE.userType == LoginType.Nursery {
                    if let viewController: ParentAttendanceViewController = ParentAttendanceViewController.storyboardInstance.initialize() {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }else{
                    if let viewController: MarkAttendanceViewController = MarkAttendanceViewController.storyboardInstance.initialize() {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
                
            }else if indexPath.section == 0 && indexPath.row == 1 {
                if APP_DELEGATE.userType == LoginType.Parent
                    || APP_DELEGATE.userType == LoginType.School
                    || APP_DELEGATE.userType == LoginType.Nursery {
                    if let viewController: SchoolCalendarViewController = SchoolCalendarViewController.storyboardInstance.initialize() {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }else {
                    if let viewController: AttendanceSummaryViewController = AttendanceSummaryViewController.storyboardInstance.initialize() {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            }else if indexPath.section == 1 && indexPath.row == 0 {
                if APP_DELEGATE.userType == LoginType.Parent
                    || APP_DELEGATE.userType == LoginType.School
                    || APP_DELEGATE.userType == LoginType.Nursery{
                    
                   // self.toast("Coming Soon!!")
                    if let viewController: DisciplinaryCardViewController = DisciplinaryCardViewController.storyboardInstance.initialize() {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                   /* if let viewController: TimeTableViewController = TimeTableViewController.storyboardInstance.initialize() {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }*/
                }else{
//                    if let viewController: AttendanceEntryViewController = AttendanceEntryViewController.storyboardInstance.initialize() {
//                        self.navigationController?.pushViewController(viewController, animated: true)
//                    }
                    if let viewController = UIStoryboard(name: "DisciplinaryCardViewController", bundle: nil).instantiateViewController(withIdentifier: "DiscplinaryCardStaffViewController") as? DiscplinaryCardStaffViewController{
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
                
            }else if indexPath.section == 1 && indexPath.row == 1 {
                if APP_DELEGATE.userType == LoginType.Nursery
                           || APP_DELEGATE.userType == LoginType.Parent
                    || APP_DELEGATE.userType == LoginType.School {
                    if let viewController: NurseryWiseViewController = NurseryWiseViewController.storyboardInstance.initialize() {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }else {
                    if let viewController: WiseMainViewController = WiseMainViewController.storyboardInstance.initialize() {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            }else if indexPath.section == 1 && indexPath.row == 2 {
                if let viewController: ChildListViewController = ChildListViewController.storyboardInstance.initialize() {
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }else if indexPath.section == 1 && indexPath.row == 3 {
                if let viewController: ChildListViewController = ChildListViewController.storyboardInstance.initialize() {
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            } else if indexPath.section == 2 && indexPath.row == 0 {
                if APP_DELEGATE.userType == LoginType.Staff {
                    if let viewController: StaffHomeworkViewController = StaffHomeworkViewController.storyboardInstance.initialize() {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                } else if let viewController: HomeworkViewController = HomeworkViewController.storyboardInstance.initialize() {
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            } else if indexPath.section == 2 && indexPath.row == 1 {
                if APP_DELEGATE.userType == LoginType.Staff {
                    if let viewController: AssignedHomeworksViewController = AssignedHomeworksViewController.storyboardInstance.initialize() {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            }
        }
    }
}
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 100 {
            return titleArray.count
        }else {
            return imageArrayHorizontal[section].count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 100 {
            return 1
        }else {
            return imageArrayHorizontal.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 100 {
            // Dequeue cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SideMenuStaffCell.cellId, for: indexPath) as! SideMenuStaffCell
            
            cell.titleLabel.text = self.titleArray[indexPath.row]
            cell.menuImage.image = UIImage(named: self.imageArray[indexPath.row])
            cell.menuImage.layer.cornerRadius = cell.menuImage.frame.width/2
            cell.menuImage.layer.masksToBounds = true
            cell.menuImage.backgroundColor = UIColor.white
            cell.contentView.backgroundColor = UIColor.clear
            
            if APP_DELEGATE.userType == LoginType.Nursery {
                cell.menuImage.layer.cornerRadius = cell.menuImage.frame.width/2
                cell.menuImage.layer.masksToBounds = true
                cell.menuImage.backgroundColor = cellBgColor[indexPath.row]
                if(indexPath.row == 2 || indexPath.row == 3){
                    cell.menuImage.contentMode = .center
                }
            }
            else if APP_DELEGATE.userType == LoginType.Staff {
                cell.menuImage.backgroundColor = StaffColorForCell[indexPath.row]
                cell.menuImage.contentMode = .center
            }else{
                cell.menuImage.backgroundColor = CommonColorForCell[indexPath.row]
                if(indexPath.row == 2 || indexPath.row == 3){
                    cell.menuImage.contentMode = .center
                }
                
                if juniorBranchCodes.contains(APP_DELEGATE.selected_Student?.studentId?.year_branch ?? 0){
                    cell.menuImage.layer.cornerRadius = cell.menuImage.frame.width/2
                    cell.menuImage.layer.masksToBounds = true
                    cell.menuImage.backgroundColor = cellBgColor[indexPath.row]
                    if(indexPath.row == 2 || indexPath.row == 3){
                        cell.menuImage.contentMode = .center
                    }
                }else if seniorBranchCodes.contains(APP_DELEGATE.selected_Student?.studentId?.year_branch ?? 0){
                    
                }
            }
            
            cell.viewNotification.isHidden = true
            if cell.titleLabel.text == "Messages" && smsCount != 0{
                cell.viewNotification.isHidden = false
                cell.lblNotification.text = String(smsCount)
            }
            
            return cell
        }else {
            // Dequeue cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeScreenCell.cellId, for: indexPath) as! HomeScreenCell
            cell.titleLabel.text = self.titleArrayHorizontal[indexPath.section][indexPath.row]
            cell.menuImage.image = UIImage(named: self.imageArrayHorizontal[indexPath.section][indexPath.row])
            if APP_DELEGATE.userType == LoginType.Nursery {
                cell.viewBg.backgroundColor = cellBgColorHorizontal[indexPath.section][indexPath.row]
            }
            
            if APP_DELEGATE.userType == LoginType.Parent{
                
                if juniorBranchCodes.contains(APP_DELEGATE.selected_Student?.studentId?.year_branch ?? 0){
                    cell.viewBg.backgroundColor = cellBgColorHorizontal[indexPath.section][indexPath.row]
                }else if seniorBranchCodes.contains(APP_DELEGATE.selected_Student?.studentId?.year_branch ?? 0){
                    
                }
            }
            
            return cell
        }
        
    }
}
