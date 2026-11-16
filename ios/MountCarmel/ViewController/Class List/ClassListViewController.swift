//
//  ClassListViewController.swift
//  MountCarmel
//
//  Created by Niraj on 05/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import DropDown

class ClassListViewController: UIViewController {

    @IBOutlet var btnGo: UIButton!
    @IBOutlet var lblSelectClass: UILabel!
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var txtClass: UITextField!
    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet weak var tableView: UITableView!
    var arrHouseReports = [HouseReportData]()
    var arrClassList = [ClassListWithSectionData]()
    private var imgPath = ""
    var selectedID = ""
    //DropDown Declaration
    var classDropDown = DropDown()
    var arrSelectedData = [String]()
    var arrSelectedIndex = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "Class List"
        navigationView.delegate = self
        self.configureTableView()
        self.setHouseDropDown()
        
        self.lblSelectClass.font = UIFont.setRegularFont(ofSize: 13.0)
        self.txtClass.placeholder = "Select"
        btnGo.titleLabel?.font = UIFont.setRegularFont(ofSize: 13.0)
        self.txtClass.font = UIFont.setRegularFont(ofSize: 13.0)
        
        let name = (APP_DELEGATE.userInfo?.staffId?.classTeacherID?.standard ?? "")
        
       // self.txtClass.text = name + "-" + (APP_DELEGATE.userInfo?.staffId?.classTeacherID?.section ?? "")
        
        self.callAPIForClassList { (check) in
            if(check){
//                if(self.arrClassList.count > 0){
//                    self.selectedID = self.arrClassList[0]._id ?? ""
//                    self.txtClass.text = (self.arrClassList[0].standard ?? "") + " " + (self.arrClassList[0].section ?? "")
//
//                    self.callAPIForClassListByID(finished: { (success) in
//                        if(success){
//                            self.tableView.reloadData()
//                        }
//                    })
//                }
                
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
    
    func configureTableView() {
    
        // Register Cell
        let cellNib = UINib(nibName: String(describing: ClassListCell.self), bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: ClassListCell.cellId)
        
        let colcellNib = UINib(nibName: String(describing: ClassCollectionCell.self), bundle: nil)
        self.collView.register(colcellNib, forCellWithReuseIdentifier: ClassCollectionCell.cellId)
//        // Automatic row dimension
//        self.tableView.rowHeight = UITableView.automaticDimension
//        self.tableView.estimatedRowHeight = UITableView.automaticDimension
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
            self.selectedID = self.arrClassList[index]._id ?? ""
            // print("Selected item: \(item) at index: \(index)")
            self.txtClass.text = item
            
            self.classDropDown.hide()
        }
        classDropDown.show()
        
//        if let viewController: CustomDropDown = CustomDropDown.storyboardInstance.initialize() {
//
//            viewController.modalPresentationStyle = .overCurrentContext
//            viewController.arrItems = strArr
//            viewController.arrSelectedItem = self.arrSelectedIndex
//            viewController.doneHandler = { (selectedItem) in
//
//                self.arrSelectedIndex = selectedItem
//                self.arrSelectedData.removeAll()
//                for i in 0..<selectedItem.count{
//                    if(selectedItem[i] == 1){
//                  let name = (self.arrClassList[i].standard ?? "") + "-" + (self.arrClassList[i].section ?? "")
//                        self.arrSelectedData.append(name)
//                    }
//                    if(self.arrSelectedData.count > 0){
//                        self.txtClass.text = "\(self.arrSelectedData.count )"
//                        self.collView.isHidden = false
//                        self.collView.reloadData()
//                    }
//                }
//
//            }
//            self.present(viewController, animated: true, completion: nil)
//        }
    }
    
    @IBAction func actionGoSelect(_ sender: Any) {
        if(txtClass.text!.isEmpty){
            self.toast("Please select class")
            return
        }
        self.callAPIForClassListByID(finished: { (success) in
            if(success){
                self.tableView.reloadData()
            }
        })
    }
}

extension ClassListViewController: NavigationBarViewDelegate {
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

extension ClassListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController: ClassListPopUpViewController = ClassListViewController.storyboardInstance.instantiateViewController(withIdentifier: "ClassListPopUpViewController") as? ClassListPopUpViewController{
            viewController.obj = self.arrHouseReports[indexPath.row]
            viewController.modalPresentationStyle = .overCurrentContext
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

extension ClassListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrHouseReports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: ClassListCell.cellId, for: indexPath) as! ClassListCell
        cell.lblCount.text = "\(indexPath.row + 1)"
        cell.setUpCell(data: self.arrHouseReports[indexPath.row],path: imgPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
         return 90
    }
}
extension ClassListViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrSelectedData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassCollectionCell", for: indexPath) as! ClassCollectionCell
       cell.btnTitle.setTitle(self.arrSelectedData[indexPath.row], for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       // let collectionViewSize = collectionView.frame.size.width
        if(arrSelectedData.count > 0){
            let label = UILabel(frame: CGRect.zero)
            label.text = arrSelectedData[indexPath.item]
            label.sizeToFit()
            return CGSize(width: label.frame.width + 100, height: 40)
        }else{
            
            return CGSize(width: 0, height: collectionView.frame.size.height)
        }
        
       // return CGSize(width: label.frame.width + 50, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
}
//MARK:- API CALL -

extension ClassListViewController{
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
            finished(true)
        }
    }
    
    func callAPIForClassListByID(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        //self.selectedID = "5e805e7fba400d5f03d1d874"
        StaffManageMentAPI.classWiseListByID(classID: self.selectedID) { (respose, error) in
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
            self.arrHouseReports = responseData
            finished(true)
        }
    }
}
