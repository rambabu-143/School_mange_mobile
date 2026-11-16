//
//  MessageViewController.swift
//  MountCarmel
//
//  Created by Niraj on 04/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet weak var tableView: UITableView!
    var arrMessags = [MessageData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.lblTitle.text = "Messages"
        navigationView.delegate = self
        
        self.configureTableView()
        
        if APP_DELEGATE.userType == LoginType.Nursery {
            self.bgView.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.7607843137, blue: 0.8274509804, alpha: 1)
        }
        if APP_DELEGATE.userType == LoginType.Staff {
            self.callAPIForStaffMessages { (success) in
                self.tableView.reloadData()
            }
        }else{
            self.callAPIForStudentAllMessages { (success) in
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func configureTableView() {
    
        // Register Cell
        let cellNib = UINib(nibName: String(describing: MessageCell.self), bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: MessageCell.cellId)
        
        // Automatic row dimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 55
    }
    
}

extension MessageViewController: NavigationBarViewDelegate {
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

extension MessageViewController: UITableViewDelegate {
    
}

extension MessageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMessags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.cellId, for: indexPath) as! MessageCell
        cell.lblSubject.textColor = .black
        cell.lblMessageDetais.textColor = .black
        cell.viewController = self
        cell.btnMore.tag = indexPath.row
//        if indexPath.row == 1 {
//            cell.lblMessageDetais.isHidden = false
//            cell.lblSubject.textColor = .black
//            cell.lblMessageDetais.textColor = .black
//            cell.massegeImage.image = #imageLiteral(resourceName: "message-unread")
//        }else {
//            cell.lblMessageDetais.isHidden = false
//            cell.lblSubject.textColor = .black
//            cell.lblMessageDetais.textColor = .black
//            cell.massegeImage.image = #imageLiteral(resourceName: "message-read")
//        }
        cell.setCellData(data: self.arrMessags[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func viewMoreClick(messageIndex : Int){
        
        if let vc: MessagePopUpViewController = MessagePopUpViewController.storyboardInstance.initialize() {
            vc.isFromNotification = false
            vc.modalPresentationStyle = .overCurrentContext
            vc.messageData = self.arrMessags[messageIndex]
            vc.doneHandler = {
                if APP_DELEGATE.userType == LoginType.Staff {
                    self.callAPIForStaffMessages { (success) in
                        self.tableView.reloadData()
                        for case let vc as HomeViewController in self.navigationController?.viewControllers ?? []{
                            vc.callAPIForNotificationCount { _ in }
                        }

                    }
                }else{
                    self.callAPIForStudentAllMessages { (success) in
                        self.tableView.reloadData()
                        for case let vc as HomeViewController in self.navigationController?.viewControllers ?? []{
                            vc.callAPIForNotificationCount { _ in }
                        }

                    }
                }
            }
            self.present(vc, animated: true, completion: nil)
            
        }
    }
    
}

//MARK:- API CALL -

extension MessageViewController{
    /*
     - API Call for Getting All Messages for one Students
     - In Api we pass student ID which receives in LoginResponse student Key
    */
    
    func callAPIForStudentAllMessages(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        StaffManageMentAPI.getStudentsAllMessages() { (respose, error) in
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
            
            self.arrMessags = responseData
            finished(true)
        }
    }
    
    func callAPIForStaffMessages(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        StaffManageMentAPI.getStaffMessages() { (respose, error) in
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
            
            self.arrMessags = responseData
            finished(true)
        }
    }
}
