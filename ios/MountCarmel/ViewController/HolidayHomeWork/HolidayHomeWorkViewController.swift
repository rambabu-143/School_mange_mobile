//
//  HolidayHomeWorkViewController.swift
//  MountCarmel
//
//  Created by Sandip on 08/11/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import QuickLook

class HolidayHomeWorkViewController: UIViewController {
    
    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet weak var tableView: UITableView!
    var arrReportData = [StaffNoticeList]()
    var imgPath = ""
    var previewItem : URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationView.lblTitle.text = "Holiday Homework"
        navigationView.delegate = self
        
        self.configureTableView()
        self.callAPIForStudentNotice { (success) in
            self.tableView.reloadData()
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

extension HolidayHomeWorkViewController: NavigationBarViewDelegate {
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

extension HolidayHomeWorkViewController: UITableViewDelegate {
    
}

extension HolidayHomeWorkViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.arrReportData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: NoticeCell.cellId, for: indexPath) as! NoticeCell
       
            cell.setUpStaffCellData(data: self.arrReportData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // let previewController = QLPreviewController()
        //previewController.dataSource = self as QLPreviewControllerDataSource
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        var fileURL = ""
        var fileName = ""
        var title = ""
        
        fileURL = imgPath + (self.arrReportData[indexPath.row].attachments?[0] ?? "")
        fileName = self.arrReportData[indexPath.row].attachments?[0] ?? ""
        title = self.arrReportData[indexPath.row].title ?? ""
        
        let storyBoard = UIStoryboard(name: "NoticeViewController", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        
            viewController.Title = title
            viewController.fileName = fileName
            viewController.url = URL(string: fileURL)
            self.navigationController?.pushViewController(viewController, animated: true)
        
      /*  Loader.show()
        let url = URL(string: fileURL)!
        CommonFunctions.downloadfile(viewcontroller: self, url: url, mimeType: "", fileName: fileName ) { (check, strURLPath) in
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

extension HolidayHomeWorkViewController {
    func callAPIForStudentNotice(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        StudentManagementAPI.getHolidayHomework() { (respose, error) in
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
}

//MARK:- QLPreviewController Datasource

extension HolidayHomeWorkViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        
        return self.previewItem! as QLPreviewItem
    }
}
