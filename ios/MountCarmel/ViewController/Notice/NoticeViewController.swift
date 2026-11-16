//
//  NoticeViewController.swift
//  MountCarmel
//
//  Created by Niraj on 04/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import QuickLook
class NoticeViewController: UIViewController {

    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet weak var tableView: UITableView!
    var arrReportData = [NoticeData]()
     var arrStaffReportData = [StaffNoticeList]()
    var imgPath = ""
    var previewItem : URL?
    var previewController = QLPreviewController(){
        didSet{
            previewController.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.lblTitle.text = "Notice"
        navigationView.delegate = self
        
        self.configureTableView()
        if(APP_DELEGATE.userType == .Staff){
            self.callAPIForStaffNotice { (success) in
                self.tableView.reloadData()
            }
        }else{
            self.callAPIForStudentNotice { (success) in
                self.tableView.reloadData()
            }
        }
        
    }
    
    func configureTableView() {
    
        // Register Cell
        let cellNib = UINib(nibName: String(describing: NoticeCell.self), bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: NoticeCell.cellId)
        
        // Automatic row dimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 65
    }
}

extension NoticeViewController: NavigationBarViewDelegate {
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

extension NoticeViewController: UITableViewDelegate {
    
}

extension NoticeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(APP_DELEGATE.userType == .Staff){
            return self.arrStaffReportData.count
        }else{
            return self.arrReportData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: NoticeCell.cellId, for: indexPath) as! NoticeCell
         if(APP_DELEGATE.userType == .Staff){
            cell.setUpStaffCellData(data: self.arrStaffReportData[indexPath.row])
        }
         else{
            cell.setUpCellData(data: self.arrReportData[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var fileURL = ""
        var fileName = ""
        var title = ""
        if(APP_DELEGATE.userType == .Staff){
            fileURL = imgPath + "/" + (self.arrStaffReportData[indexPath.row].attachments?[0] ?? "")
            title = self.arrStaffReportData[indexPath.row].title ?? ""
            fileName = (self.arrStaffReportData[indexPath.row].attachments?[0] ?? "")
        }else{
            fileURL = imgPath + "/" + (self.arrReportData[indexPath.row].attachments?[0] ?? "")
            title = self.arrReportData[indexPath.row].title ?? ""
            fileName = (self.arrReportData[indexPath.row].attachments?[0] ?? "")
        }
        
        let storyBoard = UIStoryboard(name: "NoticeViewController", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            viewController.fileName = fileName
            viewController.Title = title
            viewController.url = URL(string: fileURL)
            self.navigationController?.pushViewController(viewController, animated: true)
        
        
      /*  UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        var fileURL = ""
        var fileName = ""
        if(APP_DELEGATE.userType == .Staff){
            fileURL = imgPath + "/" + (self.arrStaffReportData[indexPath.row].attachments?[0] ?? "")
            fileName = self.arrStaffReportData[indexPath.row].attachments?[0] ?? ""
        }else{
            fileURL = imgPath + "/" + (self.arrReportData[indexPath.row].attachments?[0] ?? "")
            fileName = self.arrReportData[indexPath.row].attachments?[0] ?? ""
        }
        
        Loader.show()
        let url = URL(string: fileURL)!
        CommonFunctions.downloadfile(viewcontroller: self, url: url, mimeType: "", fileName: fileName ) { (check, strURLPath) in
            Loader.hide()
            if(check){
                print(strURLPath)
                self.previewItem = strURLPath
                // Display file
                self.previewController.navigationController?.navigationBar.tintColor = UIColor.black
                self.present(self.previewController, animated: true, completion: nil)
                self.toast("syllabus downloaded successfully")
            }
        }*/
        
    }
}

//MARK:- API CALL -

extension  NoticeViewController{
    func callAPIForStudentNotice(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        StaffManageMentAPI.getNoticeListForStudents() { (respose, error) in
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
            self.imgPath = response.path ?? ""
            self.arrReportData = responseData
            if(self.arrReportData.count == 0){
                self.toast("No records found.")
            }
            finished(true)
        }
    }
    
    func callAPIForStaffNotice(finished:@escaping(_ success: Bool) -> Void){
        Loader.show()
        StaffManageMentAPI.getNoticeListForStaff() { (respose, error) in
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
            self.imgPath = response.path ?? ""
            self.arrStaffReportData = responseData
            if(self.arrStaffReportData.count == 0){
                self.toast("No records found.")
            }
            finished(true)
        }
    }
}
//MARK:- QLPreviewController Datasource

extension NoticeViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.previewItem! as QLPreviewItem
    }
}
