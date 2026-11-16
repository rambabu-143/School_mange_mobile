//
//  HomeworkViewController.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 12/07/24.
//  Copyright © 2024 Mount Carmel School. All rights reserved.
//

import Foundation
import UIKit
import QuickLook
import DropDown

class HomeworkViewController: UIViewController {
    // data
    var homeworkList: [HomeworkData] = []
    var filterHomeworkList: [HomeworkData] = []
    var subjects: [ComboSubjects] = []

    // States
    var subjectId: String? = nil
    var selectedMonth: String? = nil
    var startDate: String? = nil
    var endDate: String? = nil
    
    // UI elements
    @IBOutlet var searchInputTextField: RoundTextField!
    @IBOutlet var selectSubjectTextField: RoundTextField!
    @IBOutlet var selectMonthTextField: RoundTextField!
    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    var subjectDropDown = DropDown()
    var monthDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchInputTextField.delegate = self
        navigationView.delegate = self
        navigationView.lblTitle.text = "Homework"
        
        self.configureMonthDropdown()
        self.configureSubjectDropdown()
    }
    
    func configureSubjectDropdown() {
        subjectDropDown.anchorView = selectSubjectTextField
        subjectDropDown.direction = .bottom
        subjectDropDown.textFont = UIFont.setRegularFont(ofSize: 13.0)
        subjectDropDown.width = selectSubjectTextField.frame.size.width
        subjectDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        
        subjectDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.handleSubjectSelection(index: index, item: item)
            self.subjectDropDown.hide()
            self.fetchHomeworkData()
        }
        
        self.callAPIStudentDetails { [weak self] (check, responseData) in
            if (check) {
                guard let self = self else {return}
                let subjects = responseData?.data?.combo_id?.subjects ?? [ComboSubjects]()
                let subjectsNames = subjects.map { comboSubject in
                    comboSubject.subject_name ?? ""
                }
                self.subjects = subjects
                if let firstSubject = subjects.first {
                    self.handleSubjectSelection(index: 0, item: firstSubject.subject_name ?? "")
                }
                self.subjectId = subjects.first?._id
                self.subjectDropDown.dataSource = subjectsNames
                self.configureCollectionView()
                
                self.fetchHomeworkData()
            }
        }
    }
    
    func configureCollectionView() {
        // Register Cell
        let cellNib = UINib(nibName: String(describing: HomeworkCell.self), bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: HomeworkCell.cellId)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }

    func configureMonthDropdown() {
        monthDropDown.anchorView = selectMonthTextField
        monthDropDown.direction = .bottom
        monthDropDown.textFont = UIFont.setRegularFont(ofSize: 13.0)
        monthDropDown.width = selectMonthTextField.frame.size.width
        monthDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        
        let sessionMonthsList = getSessionMonthAndYearList()
        monthDropDown.dataSource = sessionMonthsList
        
        monthDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.handleMonthSelection(index: index, item: item)
            self.monthDropDown.hide()
            self.fetchHomeworkData()
        }

        // Setting current month as default
        let df = DateFormatter()
        df.dateFormat = "MMM yyyy"
        let currMonthYear = df.string(from: Date())
        if let defaultSelectionInt = sessionMonthsList.firstIndex(of: currMonthYear) {
            self.handleMonthSelection(index: defaultSelectionInt, item: currMonthYear)
        }
    }

    @IBAction func actionSelectMonth(_ sender: Any) {
        monthDropDown.show()
    }
    
    @IBAction func actionSelectSubject(_ sender: Any) {
        subjectDropDown.show()
    }
    
    private func fetchHomeworkData() {
        guard let dates = self.selectedMonth?.components(separatedBy: " ") else {
            self.toast("Please select a Month")
            return
        }
        guard self.subjectId != nil else {
            self.toast("Please select a Subject")
            return
        }
        let halfMonthStr = dates[0]
        let year = dates[1]
        
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "LLLL"
        var month = 0
        var monthVal = ""
        if let date = df.date(from: halfMonthStr) {
            month = Calendar.current.component(.month, from: date)
        }
        if (month < 10) {
            monthVal = "0" + String(month)
        } else {
            monthVal = String(month)
        }

        let monthStartDate = CommonFunctions.getStringToDate(
            Format: DateFormat.DateFormat_DDMMYYYY,
            strDate: "01/" + monthVal + "/" + year
        )
        
        let monthStartDateStr = CommonFunctions.getDateInString(date: monthStartDate.startOfMonth(), strDateFormat: DateFormat.DateFormat_DDMMYYYY )
        
        let monthEndDateStr = CommonFunctions.getDateInString(date: monthStartDate.endOfMonth(), strDateFormat: DateFormat.DateFormat_DDMMYYYY )
        
        self.callAPIForGetHomeworkList(startDate: monthStartDateStr, endDate: monthEndDateStr) { (success) in
            if success == true {
                self.collectionView.reloadData()
                //self.configureCollectionView()
            }
        }
    }
    
    private func handleSubjectSelection(index: Int, item: String) {
        self.subjectId = self.subjects[index]._id
        self.selectSubjectTextField.text = item
    }
    
    private func handleMonthSelection(index: Int, item: String) {
        self.selectedMonth = item
        self.selectMonthTextField.text = item
    }

    func getSessionMonthAndYearList() -> [String] {
        let sessionStartDateStr = CommonFunctions.UTCToLocal(
            date: "01/04/" + (APP_DELEGATE.userInfo?.years?.last?.yearSession?.components(separatedBy: "-").first ?? ""),
            fromFormat: DateFormat.DateFormat_ddMMYYYY,
            toFormat: DateFormat.DateFormat_ddMMYYYY
        )
        let sessionEndDateStr = CommonFunctions.UTCToLocal(
            date: "31/03/20" + (APP_DELEGATE.userInfo?.years?.last?.yearSession?.components(separatedBy: "-").last ?? ""),
            fromFormat: DateFormat.DateFormat_ddMMYYYY,
            toFormat: DateFormat.DateFormat_ddMMYYYY
        )
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        
        guard let sessionStartDate = format.date(from: sessionStartDateStr),
              let sessionEndDate = format.date(from: sessionEndDateStr) else {
            return []
        }
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(Set([.month]), from: sessionStartDate, to: sessionEndDate)
        
        var allDates: [String] = []

        let dateRangeFormatter = DateFormatter()
        dateRangeFormatter.dateFormat = "MMM yyyy"
        
        for i in 0 ... components.month! {
            guard let date = calendar.date(byAdding: .month, value: i, to: sessionStartDate) else {
                continue
            }
            let formattedDate = dateRangeFormatter.string(from: date)
            allDates += [formattedDate]
        }
        return allDates
    }
}

// Adding API functions
extension HomeworkViewController {
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
    
    func callAPIForGetHomeworkList(startDate: String, endDate: String, finished: @escaping (_ success: Bool) -> Void) {
        guard let studentId = APP_DELEGATE.selected_Student?.studentId?.ID else {
            self.toast("Student ID not available! Please contact admin")
            return
        }
        guard let subjectId = self.subjectId else {
            self.toast("Please select Subject from Subject Selector Menu")
            return
        }
        guard !startDate.isEmpty, !endDate.isEmpty else {
            self.toast("Please select Month from Month Selector Menu")
            return
        }
        Loader.show()
        StudentManagementAPI.getHomeworkList(
            studentId: studentId,
            subjectId: subjectId,
            startDate: startDate,
            endDate: endDate
        ) { (respose, error) in
            Loader.hide()
            guard let response = respose else {
                self.toast(error?.localizedDescription ?? "Invalid Response")
                finished(false)
                return
            }
            guard response.status == true else {
                self.toast(response.message ?? "Invalid Response")
                finished(false)
                return
            }
            guard let responseData = response.data else {
                self.toast(response.message ?? "Invalid Response")
                finished(false)
                return
            }
            self.homeworkList = responseData
            
            if self.homeworkList.count == 0 {
                self.toast("No Record Found")
            }
            self.filterHomeworkList = self.homeworkList
            
            finished(true)
        }
    }

    func presentBottomSheet(viewController: UIViewController) {
        viewController.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            if let sheet = viewController.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
        }
        present(viewController, animated: true, completion: nil)
    }
}

// Managing search input field
extension HomeworkViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchData(serchTxt: textField.text ?? "")
    }

    func searchData(serchTxt: String) {
        self.filterHomeworkList.removeAll()

        if serchTxt.count != 0 {
            for dicData in self.homeworkList {
                if let isMachingName = dicData.text {
                    let range = isMachingName.range(of: serchTxt, options: .caseInsensitive)
                    if range != nil {
                        self.filterHomeworkList.append(dicData)
                    }
                }
            }
        } else {
            self.filterHomeworkList = self.homeworkList
        }

        self.collectionView.reloadData()
    }
}

// Managing Navigation bar
extension HomeworkViewController: NavigationBarViewDelegate {
    func onTapMenu() {}
    
    func onTapBack() {
        guard let navigationController = self.navigationController else {return}

        if navigationController.viewControllers.count == 1 {
            self.setHomeScreen()
        } else {
            navigationController.popViewController(animated: true)
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
    
    func onTapDropDown() {}
    
    func onTapStory() {}

    func setHomeScreen() {
        if let viewController: HomeViewController = HomeViewController.storyboardInstance.initialize() {
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
        }
    }
}

extension HomeworkViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellData = self.filterHomeworkList[indexPath.row]
        let computedHeight = (24.0 * 5.0) + 16 + (cellData.google_drive_link != nil ? 28.0 : 0.0) // (text, date, staff) line height + vertical padding + attachment button height
        return CGSize.init(width: collectionView.frame.size.width - 40.0, height: computedHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 20, left: 20, bottom: 20, right: 20)
    }
}

extension HomeworkViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filterHomeworkList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeworkCell.cellId, for: indexPath) as! HomeworkCell

        let cellData = self.filterHomeworkList[indexPath.row]

        cell.lblHomeworkText.text = cellData.text ?? "Not available, Contact your teacher!"
        
        if let homeworkText = cellData.text {
            cell.onHomeworkTextPress = {
                let bottomSheetVC = HomeworkBottomSheetViewController()
                bottomSheetVC.setHomeworkText(homeworkText)
                self.presentBottomSheet(viewController: bottomSheetVC)
            }
        }
        
        let formattedDate = CommonFunctions.getDateString(
            date: cellData.created_at ?? "",
            fromFormat: DateFormat.DateFormate_MessageServer, toFormat: "MMM dd, yyyy"
        )

        cell.lblAssignedOn.text = "Assigned on " + formattedDate
        cell.lblAssignedBy.text = "Assigned by " + (cellData.sent_by_staff?.name ?? "n.a")
        
        let subjectName = self.subjects.first(where: {$0._id == self.subjectId})?.subject_name ?? ""
        
        if let attachmentLink = cellData.google_drive_link {
            cell.btnAttachmentLinkWrapper.isHidden = false
            
            cell.onButtonPress = {
                UINavigationBar.appearance().tintColor = .black
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
                let fileURL = attachmentLink
                let fileName = cellData.attachment ?? "Attached file"
                let title = subjectName.capitalized + " homework assigned on " + formattedDate
        
                let storyBoard = UIStoryboard(name: "NoticeViewController", bundle: nil)
                let viewController = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                viewController.fileName = fileName
                viewController.Title = title
                viewController.url = URL(string: fileURL)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
            cell.btnAttachmentLink.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            cell.btnAttachmentLink.titleLabel?.numberOfLines = 1
            cell.btnAttachmentLink.setTitle(cellData.attachment ?? "Attached file", for: .normal)
        } else {
            cell.btnAttachmentLinkWrapper.isHidden = true
        }
        cell.layoutIfNeeded()
        return cell
    }
}
