//
//  AssignmentsViewController.swift
//  MountCarmel
//
//  Created by Niraj on 14/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import QuickLook
import DropDown
class AssignmentsViewController: UIViewController {
    enum ViewModes {
        case assignment
        case syllabus
    }

    @IBOutlet var txtSearch: RoundTextField!
    @IBOutlet var txtMonth: RoundTextField!
    @IBOutlet var txtSelectSubject: RoundTextField!
    @IBOutlet var topView: UIView!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet weak var navigationView: NavigationBarView!
    var arrSubjects = [ComboSubjects]()
    
    let imageArray = ["English_N", "Hindi_N", "Math_N", "EVS_N"]
    let titleArray = ["English", "Hindi", "Math", "EVS"]
    var viewMode : ViewModes = .assignment
    
    var arrayAssignments = [AssignmentData]()
    var arrFilterAssignmentList = [AssignmentData]()
    
    var arraySyllabus = [StaffNoticeList]()
    var imgPath = ""
    var previewItem : URL?
    var subjectDropDown = DropDown()
    var monthDropDown = DropDown()
    var selectedID : String?
    var selectedMonth : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtSearch.delegate = self
        if self.viewMode == .syllabus {
            navigationView.lblTitle.text = "Syllabus"
            topView.isHidden = true
            navigationView.delegate = self
            if (APP_DELEGATE.userType == LoginType.Nursery ||
                APP_DELEGATE.userType == LoginType.School ||
                APP_DELEGATE.userType == LoginType.Parent){
                self.callAPIForGetSyllabusList { (success) in
                    if success == true {
                        self.configureCollectionView()
                    }
                }
            }else{
                self.configureCollectionView()
            }
            
        }else {
            topView.isHidden = false
            navigationView.lblTitle.text = "Assignments"
            navigationView.delegate = self
            self.setSubjectDropDown()
            self.callAPIStudentDetails { (check, responseData) in
                if(check){
                    self.arrSubjects = responseData?.data?.combo_id?.subjects ?? [ComboSubjects]()
                    
                    self.configureCollectionView()
                }
            }

        }
    }
    func setSubjectDropDown(){
        
        subjectDropDown.anchorView = txtSelectSubject
        subjectDropDown.direction = .bottom
        subjectDropDown.textFont = UIFont.setRegularFont(ofSize: 13.0)
        subjectDropDown.width = txtSelectSubject.frame.size.width
        subjectDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        
        monthDropDown.anchorView = txtMonth
        monthDropDown.direction = .bottom
        monthDropDown.textFont = UIFont.setRegularFont(ofSize: 13.0)
        monthDropDown.width = txtMonth.frame.size.width
        monthDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        
    }
    
     func configureCollectionView() {
         // Register Cell
         let cellNib = UINib(nibName: String(describing: AssignmentsCell.self), bundle: nil)
         self.collectionView.register(cellNib, forCellWithReuseIdentifier: AssignmentsCell.cellId)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
     }
    
    //MARK:- Action Event -
    
    @IBAction func actionSelectMonth(_ sender: Any) {
        let strDateVal = "01/04/" + (APP_DELEGATE.userInfo?.years?.last?.yearSession?.components(separatedBy: "-").first ?? "")
        
        let date = CommonFunctions.UTCToLocal(date: strDateVal, fromFormat: DateFormat.DateFormat_ddMMYYYY, toFormat: DateFormat.DateFormat_ddMMYYYY)
        
        let strendDateVal = "31/03/20" + (APP_DELEGATE.userInfo?.years?.last?.yearSession?.components(separatedBy: "-").last ?? "")
        
        let enddate = CommonFunctions.UTCToLocal(date: strendDateVal, fromFormat: DateFormat.DateFormat_ddMMYYYY, toFormat: DateFormat.DateFormat_ddMMYYYY)
        
        let allMonths = getMonthAndYearBetween(from: date, to: enddate)
       // print(allMonths)
        
        monthDropDown.dataSource = allMonths
        
        monthDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedMonth = item
            self.txtMonth.text = item
            self.monthDropDown.hide()
        }
        monthDropDown.show()
        
    }
    
    @IBAction func actionSelectSubject(_ sender: Any) {
        var strArr = [String]()
        for item in self.arrSubjects{
            let name = (item.subject_name ?? "")
            strArr.append(name)
        }
        subjectDropDown.dataSource = strArr
        
        subjectDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedID = self.arrSubjects[index]._id ?? ""
            // print("Selected item: \(item) at index: \(index)")
            self.txtSelectSubject.text = item
            
            self.subjectDropDown.hide()
        }
        subjectDropDown.show()
       
    }
    
    @IBAction func actionGoClick(_ sender: Any) {
        guard let dates = self.selectedMonth?.components(separatedBy: " ") else {
            self.toast("Please select a Month")
            return
        }
        guard self.selectedID != nil else {
            self.toast("Please select a Subject")
            return
        }
        let date = dates[0]
        
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "LLLL"
        var month = 0
        var monthVal = ""
        if let date = df.date(from: date) {
            month = Calendar.current.component(.month, from: date)
            print(month)  // 5
        }
        
        if(month < 10){
            monthVal = "0" + String(month)
        }else{
            monthVal = String(month)
        }
        let startDate = "01/" + monthVal + "/" + dates[1]
        
        let strDate = CommonFunctions.getStringToDate(Format: DateFormat.DateFormat_DDMMYYYY, strDate: startDate )
        
        var endOfDay: Date {
            var components = DateComponents()
            components.day = 1
            components.second = -1
            return Calendar.current.date(byAdding: components, to: strDate)!
        }
        
        let strstartDate = CommonFunctions.getDateInString(date: strDate.startOfMonth(), strDateFormat: DateFormat.DateFormat_DDMMYYYY )
        
        let strEndDate = CommonFunctions.getDateInString(date: strDate.endOfMonth(), strDateFormat: DateFormat.DateFormat_DDMMYYYY )
        
        print(strstartDate)
        print(strEndDate)
        
       
        
        self.callAPIForGetAssignmentList(startDate: strstartDate, endDate: strEndDate, finished:  { (success) in
            if success == true {
                self.collectionView.reloadData()
                //self.configureCollectionView()
            }
        })
    }
    
    func getMonthAndYearBetween(from start: String, to end: String) -> [String] {
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        
        guard let startDate = format.date(from: start),
              let endDate = format.date(from: end) else {
            return []
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(Set([.month]), from: startDate, to: endDate)
        
        var allDates: [String] = []
        let dateRangeFormatter = DateFormatter()
        dateRangeFormatter.dateFormat = "MMM yyyy"
        
        for i in 0 ... components.month! {
            guard let date = calendar.date(byAdding: .month, value: i, to: startDate) else {
                continue
            }
            
            let formattedDate = dateRangeFormatter.string(from: date)
            allDates += [formattedDate]
        }
        return allDates
    }

}

extension AssignmentsViewController: NavigationBarViewDelegate {
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


extension AssignmentsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: (collectionView.frame.size.width/2) - 30, height: (collectionView.frame.size.width/2) + 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets (top: 10, left: 20, bottom: 0, right: 20)
    }
}

extension AssignmentsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.viewMode == .assignment {
            return self.arrFilterAssignmentList.count
        } else {
            if (APP_DELEGATE.userType == LoginType.Nursery ||
                APP_DELEGATE.userType == LoginType.School  ||
                    APP_DELEGATE.userType == LoginType.Parent){
                return self.arraySyllabus.count
            }
            else{
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Dequeue cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssignmentsCell.cellId, for: indexPath) as! AssignmentsCell
        
        if self.viewMode == .assignment {
            cell.lblData.isHidden = false
        } else {
           // cell.lblData.isHidden = true
        }
        
        if self.viewMode == .assignment {
            cell.lblSyllabusName.text = self.arrFilterAssignmentList[indexPath.row].title ?? ""
            
        cell.imageSyllabus.image = #imageLiteral(resourceName: "pdf_Assignment")
            cell.layoutIfNeeded()
            cell.imageSyllabus.cornerRadius = cell.imageSyllabus.frame.size.height / 2
             cell.layoutIfNeeded()
            cell.lblData.text = CommonFunctions.getDateString(date: self.arrFilterAssignmentList[indexPath.row].created_at ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.ddMMMyyyy)
            
//            let imageURL = self.arrayAssignments[indexPath.row].imageURL ?? ""
//            cell.imageSyllabus.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "English_N"), options: [], context: nil)
        } else {
            cell.lblSyllabusName.text = self.arraySyllabus[indexPath.row].title ?? ""
            cell.lblData.text = CommonFunctions.getDateString(date: self.arraySyllabus[indexPath.row].start_date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
            cell.layoutIfNeeded()
            cell.imageSyllabus.layer.cornerRadius = cell.imageSyllabus.frame.height/2
            cell.imageSyllabus.clipsToBounds = true
            cell.layoutIfNeeded()
           // cell.imageSyllabus.image = UIImage(named: self.imageArray[indexPath.row])
            
           /* if(self.arraySyllabus[indexPath.row].title?.lowercased() == "math"){
                cell.imageSyllabus.image = #imageLiteral(resourceName: "Math")
            }else{
                cell.imageSyllabus.image = #imageLiteral(resourceName: "English")
            }*/
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if self.viewMode == .syllabus {
       // let previewController = QLPreviewController()
       // previewController.dataSource = self as! QLPreviewControllerDataSource
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
            let fileURL = imgPath + "/" + (self.arraySyllabus[indexPath.row].attachments?[0] ?? "")
            let fileName = self.arraySyllabus[indexPath.row].attachments?[0] ?? ""
            let title = self.arraySyllabus[indexPath.row].title ?? ""
            
            let storyBoard = UIStoryboard(name: "NoticeViewController", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                viewController.fileName = fileName
                viewController.Title = title
                viewController.url = URL(string: fileURL)
                self.navigationController?.pushViewController(viewController, animated: true)
            
        /*    let fileURL = imgPath + "/" + (self.arraySyllabus[indexPath.row].attachment ?? "")
        Loader.show()
        let url = URL(string: fileURL)!
        CommonFunctions.downloadfile(viewcontroller: self, url: url, mimeType: "", fileName: self.arraySyllabus[indexPath.row].attachment ?? "") { (check, strURLPath) in
            Loader.hide()
            if(check){
                
                self.previewItem = strURLPath! as NSURL as URL
                // Display file
                let previewController = QLPreviewController()
                previewController.dataSource = self
                previewController.navigationController?.navigationBar.tintColor = UIColor.black
                self.present(previewController, animated: true, completion: nil)
                self.toast("syllabus downloaded successfully")
                print("URL ::: \(strURLPath)")
            }
        }*/
        }else{
          //  let previewController = QLPreviewController()
          //  previewController.dataSource = self as! QLPreviewControllerDataSource
            UINavigationBar.appearance().tintColor = .black
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            
            let fileURL = imgPath + "/" + (self.arrFilterAssignmentList[indexPath.row].attachments?[0] ?? "")
            let fileName = self.arrFilterAssignmentList[indexPath.row].attachments?[0] ?? ""
            let title = self.arrFilterAssignmentList[indexPath.row].title ?? ""
            
            let storyBoard = UIStoryboard(name: "NoticeViewController", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                viewController.fileName = fileName
                viewController.Title = title
                viewController.url = URL(string: fileURL)
                self.navigationController?.pushViewController(viewController, animated: true)
            
          /*  let fileURL = imgPath + "/" + (self.arrFilterAssignmentList[indexPath.row].attachments?[0] ?? "")
            Loader.show()
            let url = URL(string: fileURL)!
            CommonFunctions.downloadfile(viewcontroller: self, url: url, mimeType: "", fileName: self.arrFilterAssignmentList[indexPath.row].attachments?[0] ?? "") { (check, strURLPath) in
                Loader.hide()
                if(check){
                    
                    self.previewItem = strURLPath! as NSURL as URL
                    // Display file
                    let previewController = QLPreviewController()
                    previewController.dataSource = self
                    previewController.navigationController?.navigationBar.tintColor = UIColor.black
                    self.present(previewController, animated: true, completion: nil)
                    self.toast("syllabus downloaded successfully")
                    print("URL ::: \(strURLPath)")
                }
            }*/
        }
        
    }
}

extension AssignmentsViewController {
    // API CALL FOR GETTING SUBJECT LIST FROM STUDENT DETAIL
    func callAPIStudentDetails(finished:@escaping(_ success: Bool, _ response: StudentDetailAPIResponse?) -> Void) {
        Loader.show()
    
        StudentManagementAPI.getStuddentDetails(studentID: APP_DELEGATE.selected_Student?.studentId?.ID ?? "") { (response, error) in
            Loader.hide()
            guard let response = response else {
               // let message = error?.localizedDescription ?? "Invalid Response"
                finished(false, nil)
                return
            }
            guard response.status == true else {
                self.toast(response.message ?? "")
                finished(false, nil)
                return
            }
            guard let _ = response.message else {
               // let message = response.message ?? "Invalid Response"
                finished(false, nil)
                return
            }
            finished(true, response)
        }
    }
    func callAPIForGetAssignmentList(startDate:String,endDate:String,finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        
        StudentManagementAPI.assignmentList(studentID:  APP_DELEGATE.selected_Student?.studentId?.ID,subjectID: self.selectedID, startDate: startDate, endDate: endDate) { (respose, error) in
            Loader.hide()
            
            
            guard let response = respose else {
                self.toast(error?.localizedDescription ?? "Invalid Response")
                finished(false)
                return
            }
            
            guard response.status == true else {
                self.toast(response.message ?? "Invalid Response")
                ////CommonFunctions.logOutFromAPP()
                finished(false)
                return
            }
            
            guard let responseData = response.data else {
                self.toast(response.message ?? "Invalid Response")
                finished(false)
                return
            }
            
            self.imgPath = response.path ?? ""
            self.arrayAssignments = responseData
            if self.arrayAssignments.count == 0{
                self.toast("No Record Found")
            }
            self.arrFilterAssignmentList = self.arrayAssignments
            
            finished(true)
        }
    }
    
    func callAPIForGetSyllabusList(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        StaffManageMentAPI.syllabusList_new(studentId: APP_DELEGATE.selected_Student?.studentId?.ID ?? "") { (respose, error) in
            Loader.hide()
            
            guard let response = respose else {
                self.toast(error?.localizedDescription ?? "Invalid Response")
                finished(false)
                return
            }
            
            guard response.status == true else {
                self.toast(response.message ?? "Invalid Response")
                ////CommonFunctions.logOutFromAPP()
                finished(false)
                return
            }
            
            guard let responseData = response.data else {
                self.toast(response.message ?? "Invalid Response")
                finished(false)
                return
            }
            guard responseData.count != 0 else {
                self.toast("No Syllabus")
                finished(false)
                return
            }
            self.imgPath = response.path ?? ""
            if self.imgPath.last == "/"{
                self.imgPath = String(self.imgPath.dropLast())
            }
            self.arraySyllabus = responseData
            finished(true)
        }
    }
}

//MARK:- QLPreviewController Datasource

extension AssignmentsViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        
        return self.previewItem! as QLPreviewItem
    }
}
extension AssignmentsViewController : UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchData(serchTxt: textField.text ?? "")
    }
    
    func searchData(serchTxt : String){
        self.arrFilterAssignmentList.removeAll()
        //print(serchTxt)
        if serchTxt.count != 0 {
            for dicData in self.arrayAssignments {
                let isMachingName : String = (dicData.title!) as String
                let range = isMachingName.range(of: serchTxt, options: .caseInsensitive)
                if range != nil {
                    self.arrFilterAssignmentList.append(dicData)
                }
                
                
            }
        } else {
            self.arrFilterAssignmentList = self.arrayAssignments
        }
        
        self.collectionView.reloadData()
    }
}
