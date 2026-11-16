//
//  TimeTableViewController.swift
//  MountCarmel
//
//  Created by Sandip on 08/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import DropDown

class TimeTableViewController: UIViewController {

    @IBOutlet var lblSelectClass: UILabel!
    @IBOutlet var txtClass: RoundTextField!
    @IBOutlet var viewTop: UIView!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var collview: UICollectionView!
    @IBOutlet weak var navigationView: NavigationBarView!
    var arrWeek = ["Mon","Tue","Wed","Thu","Fri"]
    var arrTitle = ["Morning Assembly","Computer","Math","English","Lunch Break","Biology","Painting"]
    var selectedIndex = 0
    
    var arrClassList = [ClassListWithSectionData]()
    var selectedID = ""
    var arrResource = [TimeTableResourceData]()
    var arrWeekData = [WeekDayData]()
    //DropDown Declaration
    var classDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "Time Table"
        navigationView.delegate = self
        
        lblSelectClass.font = UIFont.setRegularFont(ofSize: 14.0)
        txtClass.font = UIFont.setRegularFont(ofSize: 13.0)
        if(APP_DELEGATE.userType == LoginType.Staff){
            viewTop.isHidden = false
        }else{
            viewTop.isHidden = true
        }
        setInitialView()
    }
    
    func setInitialView(){
        tblView.register(UINib(nibName: "TimeTableCell", bundle: nil), forCellReuseIdentifier: "TimeTableCell")
        collview.reloadData()
        
        setHouseDropDown()
        
        if APP_DELEGATE.userType == LoginType.Nursery || APP_DELEGATE.userType == LoginType.School || APP_DELEGATE.userType == LoginType.Parent {
            self.tblView.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.7607843137, blue: 0.8274509804, alpha: 1)
            self.selectedID = APP_DELEGATE.selected_Student?.studentId?.ID ?? ""
            self.callAPIForTimeTableByID { (success) in
                
            }
            
        }else{
            self.callAPIForClassList { (success) in
                self.callAPIForTimeTableByID { (success) in
                    
                }
            }
        }
        
        
       
    }
    //Set DropMenu
    func setHouseDropDown(){
        
        classDropDown.anchorView = txtClass
        classDropDown.direction = .bottom
        classDropDown.textFont = UIFont.setRegularFont(ofSize: 13.0)
        classDropDown.width = txtClass.frame.size.width
        classDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        
    }
    //MARK:- Action Event -
    
    @IBAction func actionSelectClass(_ sender: Any) {
        var strArr = [String]()
        for item in self.arrClassList{
            let name = (item.standard ?? "") + " " + (item.section ?? "")
            strArr.append(name)
        }
        
        classDropDown.dataSource = strArr
        
        classDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            // print("Selected item: \(item) at index: \(index)")
            self.selectedID = self.arrClassList[index].id ?? ""
            self.txtClass.text = item
            self.classDropDown.hide()
            self.callAPIForTimeTableByID { (success) in
                
            }
        }
        classDropDown.show()
    }
    
}

extension TimeTableViewController: NavigationBarViewDelegate {
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
extension TimeTableViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrWeek.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayCell", for: indexPath) as! WeekDayCell
        cell.lblName.font =  UIFont.setBoldFont(ofSize: 14.0)
        cell.lblName.text = arrWeek[indexPath.row]
        if(selectedIndex == indexPath.row){
            cell.viewLine.isHidden = false
        }else{
            cell.viewLine.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size.width
        return CGSize(width: (collectionViewSize)/5, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        collview.reloadData()
        if(arrWeek[indexPath.row] == "Mon"){
             self.arrWeekData = self.arrResource[0].monday ?? [WeekDayData]()
        }else if(arrWeek[indexPath.row] == "Tue"){
            self.arrWeekData = self.arrResource[0].tuesday ?? [WeekDayData]()
        }else if(arrWeek[indexPath.row] == "Wed"){
            self.arrWeekData = self.arrResource[0].wednesday ?? [WeekDayData]()
        }else if(arrWeek[indexPath.row] == "Thu"){
            self.arrWeekData = self.arrResource[0].thursday ?? [WeekDayData]()
        }else if(arrWeek[indexPath.row] == "Fri"){
            self.arrWeekData = self.arrResource[0].friday ?? [WeekDayData]()
        }
        self.tblView.reloadData()
    }
    
    
}
extension TimeTableViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrWeekData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "TimeTableCell", for: indexPath) as? TimeTableCell
        if(self.arrWeekData[indexPath.row].subject == "Morning Assembly"){
            cell?.lblCount.text = "M"
            cell?.viewCount.backgroundColor = #colorLiteral(red: 0.1480000019, green: 0.2960000038, blue: 0.8029999733, alpha: 1)
        }else if(self.arrWeekData[indexPath.row].subject == "Lunch Break"){
            cell?.lblCount.text = "L"
            cell?.viewCount.backgroundColor = #colorLiteral(red: 0.9620772004, green: 0.6563818455, blue: 0.2461998165, alpha: 1)
        }else {
            if(indexPath.row>0){
                if(indexPath.row != 4){
                    cell?.lblCount.text = "\(indexPath.row)"
                }
            }
            
            cell?.viewCount.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        
        cell?.lblTitle.text = self.arrWeekData[indexPath.row].subject
        cell?.lblTime.text = (self.arrWeekData[indexPath.row].start_time ?? "") + " - " + (self.arrWeekData[indexPath.row].end_time ?? "")
        
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
//MARK:- API CALL-

extension TimeTableViewController{
    
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
            self.txtClass.text = (self.arrClassList[0].standard ?? "") + "-" + (self.arrClassList[0].section ?? "")
            self.selectedID = self.arrClassList[0].id ?? ""
            finished(true)
        }
    }
    
    func callAPIForTimeTableByID(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        StaffManageMentAPI.TimeTableByID(ClassID: self.selectedID, completion: { (respose, error) in
            Loader.hide()
            guard let response = respose else {
                self.toast(error?.localizedDescription ?? "Invalid Response")
                finished(false)
                return
            }
            
            guard let responseData = response.data else {
                self.toast(response.message ?? "Invalid Response")
                finished(false)
                return
            }
            
            self.arrResource = responseData.resource ?? [TimeTableResourceData]()
            self.arrWeekData = self.arrResource[0].monday ?? [WeekDayData]()
            self.tblView.reloadData()
            finished(true)
        })
    }
}
