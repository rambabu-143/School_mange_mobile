//
//  AssignedHomeworksViewController.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 16/08/24.
//  Copyright © 2024 Mount Carmel School. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import QuickLook
import DropDown

class AssignedHomeworksViewController: UIViewController {
    // data
    var homeworkList: [StaffHomeworkData] = [] {
        didSet {
            searchData(serchTxt: searchInputTextField?.text ?? "")
        }
    }
    var filterHomeworkList: [StaffHomeworkData] = []
    
    var undoDeleteData : (Int, StaffHomeworkData)? = nil // (index, data)

    // States
    var startDate: String? = nil
    var endDate: String? = nil
    
    // UI Elements
    @IBOutlet var startDatePicker: UIDatePicker!
    @IBOutlet var endDatePicker: UIDatePicker!
    @IBOutlet var searchInputTextField: RoundTextField!
    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchInputTextField.delegate = self
        navigationView.delegate = self
        navigationView.lblTitle.text = "View Assigned Homeworks"
        
        configureCollectionView()
        configureDates()
        fetchHomeworkData()
    }
    
    func configureDates() {
        self.callAPIForStartDate(term: "3") { [weak self] success, data in
            guard let self = self else {return}
            if success {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = DateFormat.DateFormate_MessageServer

                if let sessionStartDateStr = data?.start_date, let sessionStartDate = dateFormatter.date(from: sessionStartDateStr) {
                    self.startDatePicker.minimumDate = sessionStartDate
                    self.endDatePicker.minimumDate = sessionStartDate
                }
                
                if let sessionEndDateStr = data?.end_date, let sessionEndDate = dateFormatter.date(from: sessionEndDateStr) {
                    self.startDatePicker.maximumDate = sessionEndDate
                    self.endDatePicker.maximumDate = sessionEndDate
                }
            }
        }
    }
    
    func configureCollectionView() {
        // Register Cell
        let cellNib = UINib(nibName: String(describing: AssignedHomeworksCell.self), bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: AssignedHomeworksCell.cellId)
        
        // Add the refresh control to your UIScrollView object.
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        self.collectionView.refreshControl = refreshControl
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.reloadData()
    }
    
    @objc func handleRefreshControl() {
        fetchHomeworkData { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
    
    @IBAction func actionFetchHomework(_ sender: UIButton) {
        fetchHomeworkData()
    }

    private func getDateStr(date: Date) -> String {
        return CommonFunctions.getDateInString(date: date, strDateFormat: DateFormat.DateFormat_DDMMYYYY)
    }
    
    private func fetchHomeworkData(onsuccess: (() -> Void)? = nil) {
        guard endDatePicker.date >= startDatePicker.date else {
            toast("End date must be on or after Start date!")
            return
        }
        
        let startDateStr = getDateStr(date: startDatePicker.date)
        
        let endDateStr = getDateStr(date: endDatePicker.date)
        
        self.callAPIForGetHomeworkList(startDate: startDateStr, endDate: endDateStr) { (success) in
            if success == true {
                self.collectionView.reloadData()
                onsuccess?()
            }
        }
    }
}

// Adding API functions
extension AssignedHomeworksViewController {
    func callAPIForGetHomeworkList(startDate: String, endDate: String, finished: @escaping (_ success: Bool) -> Void) {
        guard !startDate.isEmpty else {
            self.toast("Please select start date!")
            return
        }
        guard !endDate.isEmpty else {
            self.toast("Please select end date!")
            return
        }
        Loader.show()
        StaffManageMentAPI.getHomeworkList(
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
            
            finished(true)
        }
    }
    
    func callAPIForDeleteHomework(homeworkId: String, startDate: String, endDate: String, finished: @escaping (_ success: Bool) -> Void) {
        guard !homeworkId.isEmpty else {
            self.toast("Homework Id not available!")
            return
        }
        guard !startDate.isEmpty else {
            self.toast("Please select start date!")
            return
        }
        guard !endDate.isEmpty else {
            self.toast("Please select end date!")
            return
        }
        Loader.show()
        StaffManageMentAPI.deleteHomework(
            homeworkId: homeworkId,
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
            
            finished(true)
        }
    }
    
    func callAPIForStartDate(term:String,finished:@escaping(_ success: Bool,_ startDate: StartDateData?) -> Void) {
        Loader.show()
        StaffManageMentAPI.GetStartDate(term: term) { (respose, error) in
            Loader.hide()
            guard let response = respose else {
                self.toast(error?.localizedDescription ?? "Invalid Response")
                finished(false,nil)
                return
            }
            
            guard let responseData = response.data else {
                self.toast(response.message ?? "Invalid Response")
                finished(false,nil)
                return
            }
            print(responseData)
            finished(true, responseData)
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
extension AssignedHomeworksViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchData(serchTxt: textField.text ?? "")
    }

    func searchData(serchTxt: String) {
        self.filterHomeworkList.removeAll()

        if serchTxt.count != 0 {
            for dicData in self.homeworkList {
                let range: Range? = if let isMatchingDescription = dicData.text {
                    isMatchingDescription.range(of: serchTxt, options: .caseInsensitive)
                } else {
                    nil
                }
                if range != nil {
                    self.filterHomeworkList.append(dicData)
                }
            }
        } else {
            self.filterHomeworkList = self.homeworkList
        }

        self.collectionView?.reloadData()
    }
}

// Managing Navigation bar
extension AssignedHomeworksViewController: NavigationBarViewDelegate {
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

extension AssignedHomeworksViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellData = self.filterHomeworkList[indexPath.row]
        let computedHeight = (24.0 * 6.0) + 16 + (cellData.google_drive_link != nil ? 28.0 : 0.0) // (class, subject, text(2), date, staff) line height + vertical padding + attachment button height
        return CGSize.init(width: collectionView.frame.size.width - 40.0, height: computedHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 20, left: 20, bottom: 20, right: 20)
    }
}

extension AssignedHomeworksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filterHomeworkList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssignedHomeworksCell.cellId, for: indexPath) as! AssignedHomeworksCell
        
        let cellDataIndex = indexPath.row

        let cellData = self.filterHomeworkList[cellDataIndex]
        
        cell.lblSubjectName.text = "Subject: \(cellData.subject_id?.subject_name ?? "N.A.")"
        
        let homeworkAssignedToClass = if let standardTxt = (cellData.selected_section?.standard ?? cellData.standard_section?.standard) {
            standardTxt + " " + (cellData.selected_section?.section ?? cellData.standard_section?.section ?? "")
        } else {
            "N.A."
        }
        let homeworkAssignedTo = if let count = cellData.students?.count, count > 0 {
            String(count)
        } else {
            "ALL"
        }
        
        cell.lblClassName.text = "Class: \(homeworkAssignedToClass) (\(homeworkAssignedTo))"

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
        
        cell.onDelete = { [weak self] in
            guard let self = self else {return}
            let confirmAlert = UIAlertController(
                title: "Are you sure you want to delete this homework?",
                message: nil,
                preferredStyle: .alert
            )
            confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            confirmAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] uiAlertAction in
                guard let self = self else {return}
                
                if let valueIndex = self.homeworkList.firstIndex(where: { staffHomeworkData in
                    staffHomeworkData._id == cellData._id
                }) {
                    let value = self.homeworkList.remove(at: valueIndex)
                    
                    self.undoDeleteData = (valueIndex, cellData)
                    
                    if let homeworkId = value._id {
                        let startDateStr = getDateStr(date: self.startDatePicker.date)
                        
                        let endDateStr = getDateStr(date: self.endDatePicker.date)
                        
                        self.callAPIForDeleteHomework(
                            homeworkId: homeworkId,
                            startDate: startDateStr,
                            endDate: endDateStr
                        ) { [weak self] (success) in
                            guard let self = self else {return}
                            if success == true {
                                self.collectionView.reloadData()
                            } else if let undoDeleteData = self.self.undoDeleteData {
                                self.homeworkList.insert(undoDeleteData.1, at: undoDeleteData.0)
                            }
                        }
                    }
                }
            }))
            self.present(confirmAlert, animated: true)
        }
        
//        let subjectName = self.subjects.first(where: {$0._id == self.subjectId})?.subject_name ?? ""
        let subjectName = ""
        
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
