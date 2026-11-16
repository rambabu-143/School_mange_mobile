//
//  NotificationViewController.swift
//  MountCarmel
//
//  Created by Niraj on 05/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet weak var tableView: UITableView!
    
    var arrayNotificationList : [NotificationListData] = []
    var arrNotification = [MessageData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.lblTitle.text = "Notification"
        navigationView.delegate = self
        
        self.configureTableView()
        if APP_DELEGATE.userType == LoginType.Nursery {
            self.tableView.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.7607843137, blue: 0.8274509804, alpha: 1)
        }
        
        if APP_DELEGATE.userType == LoginType.Staff {
            self.callAPIForStaffNotification { (check) in
                if(check){
                    self.tableView.reloadData()
                }
            }
        }else{
            self.callAPIForStudentNotification { (check) in
                if(check){
                    self.tableView.reloadData()
                }
            }
        }
        
       
//        Loader.show()
//        NotificationViewController.callAPIForNotificationList { (success, response, unreadCount, message) in
//            if success == true {
//                APP_DELEGATE.notificationUnreadCount = unreadCount ?? 0
//                self.arrayNotificationList = response ?? []
//                if(self.arrayNotificationList.count == 0){
//                    self.toast("There are no notification record")
//                }
//
//            } else {
//                self.toast(message ?? "Invalid response")
//            }
//
//            self.configureTableView()
//        }
    }
        
    func configureTableView() {
    
        // Register Cell
        let cellNib = UINib(nibName: String(describing: NotificationCell.self), bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: NotificationCell.cellId)
        
        // Automatic row dimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 80
        self.tableView.reloadData()
    }
}

extension NotificationViewController: NavigationBarViewDelegate {
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
        
    }
    
    func onTapStory() {
        print(#function)
    }
    
    func onTapBadgeCounts() {
        
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
    
    func setHomeScreen() {
        if let viewController: HomeViewController = HomeViewController.storyboardInstance.initialize() {
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
        }
    }
}

extension NotificationViewController: UITableViewDelegate {
    
}

extension NotificationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotification.count //arrayNotificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.cellId, for: indexPath) as! NotificationCell
    
        cell.viewController = self
        cell.btnMore.tag = indexPath.row
//        if self.arrayNotificationList[indexPath.row].readFlag == true {
//            cell.lblMessageDetais.isHidden = true
//            cell.lblSubject.textColor = .lightGray
//            cell.lblMessageDetais.textColor = .lightGray
//        } else {
//            cell.lblMessageDetais.isHidden = false
//            cell.lblSubject.textColor = .black
//            cell.lblMessageDetais.textColor = .black
//        }
       // cell.lblSubject.text = self.arrayNotificationList[indexPath.row].text
       // cell.lblMessageDetais.text = self.arrayNotificationList[indexPath.row].text
        
        cell.setCellData(data: arrNotification[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func viewMoreClick(messageIndex : Int){
        if let vc: MessagePopUpViewController = MessagePopUpViewController.storyboardInstance.initialize() {
            vc.isFromNotification = true
            vc.messageData = self.arrNotification[messageIndex]
            vc.modalPresentationStyle = .overCurrentContext
            vc.doneHandler = {
                if APP_DELEGATE.userType == LoginType.Staff {
                    self.callAPIForStaffNotification { (check) in
                        if(check){
                            self.tableView.reloadData()
                            for case let vc as HomeViewController in self.navigationController?.viewControllers ?? []{
                                vc.callAPIForNotificationCount { n_count in
                                    APP_DELEGATE.notificationUnreadCount = n_count
                                    self.navigationView.willMove(toWindow: APP_DELEGATE.window)
                                }
                            }
                        }
                    }
                }else{
                    self.callAPIForStudentNotification { (check) in
                        if(check){
                            self.tableView.reloadData()
                            for case let vc as HomeViewController in self.navigationController?.viewControllers ?? []{
                                vc.callAPIForNotificationCount{ n_count in
                                    APP_DELEGATE.notificationUnreadCount = n_count
                                    self.navigationView.willMove(toWindow: APP_DELEGATE.window)
                                }
                            }
                        }
                    }
                }
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension NotificationViewController {
//    func callAPIForNotificationList(finished:@escaping(_ success: Bool) -> Void) {
//        Loader.show()
//        NotificationsManagementAPI.notificationsList(studentID: APP_DELEGATE.userID) { (response, error) in
//            Loader.hide()
//            guard let response = response else {
//                self.toast(error?.localizedDescription ?? "Invalid Response")
//                finished(false)
//                return
//            }
//
//            guard let responseData = response.data else {
//                self.toast(response.message ?? "Invalid Response")
//                finished(false)
//                return
//            }
//
//            self.arrayNotificationList = responseData
//            if(self.arrayNotificationList.count == 0){
//                self.toast("There are no notification record")
//
//            }
//            finished(true)
//        }
//    }
    
    class func callAPIForNotificationList(finished:@escaping(_ success: Bool, _ response: Array<NotificationListData>?, _ unreadCount: Int?, _ message : String?) -> Void) {
        Loader.show()
        NotificationsManagementAPI.notificationsList(studentID: APP_DELEGATE.loginAPIResponse?.user?.students?.first?.studentId?.ID ?? "") { (response, error) in
            Loader.hide()
            guard let response = response else {
                let message = error?.localizedDescription ?? "Invalid Response"
                finished(false, nil, nil, message)
                return
            }
            guard response.status == true else {
               let message = response.message ?? "Invalid Response"
                //CommonFunctions.logOutFromAPP()
                 finished(false, nil, nil, message)
                return
            }
            guard let responseData = response.data else {
                let message = response.message ?? "Invalid Response"
                finished(false, nil, nil, message)
                return
            }
            
            let totalCount = responseData.filter { (data) -> Bool in data.readFlag == false}.count
            finished(true, responseData, totalCount, nil)
        }
    }
    
    func callAPIForStudentNotification(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        StaffManageMentAPI.getStudentsNotification() { (respose, error) in
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
            
            self.arrNotification = responseData
            if(self.arrNotification.count == 0){
                self.toast("No Notification Found.")
            }
            finished(true)
        }
    }
    
    func callAPIForStaffNotification(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        StaffManageMentAPI.getStaffNotifications() { (respose, error) in
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
            
            self.arrNotification = responseData
            finished(true)
        }
    }
}
