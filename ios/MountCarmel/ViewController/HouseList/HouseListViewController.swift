//
//  HouseListViewController.swift
//  MountCarmel
//
//  Created by Niraj on 05/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import DropDown

struct SelectedData {
    var id: String?
    var name: String?
}

class HouseListViewController: UIViewController {

    @IBOutlet var btnGo: UIButton!
    @IBOutlet var lblSelectClass: UILabel!
    @IBOutlet var lblSelectHouse: UILabel!
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var txtClass: UITextField!
    @IBOutlet var txtHouse: UITextField!
    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet weak var tableView: UITableView!
    
    var tmpArrList = [HouseListData]()
    var arrHouseList = [HouseListData]()
    var arrClassList = [ClassListWithSectionData]()
    var arrHouseReports = [HouseReportData]()
    private var imgPath = ""
    var selectedID = ""
    var selectedClass = ""
    var arrSelectedIndex = [Int]()
    var arrSelectedHouseIndex = [Int]()
    //DropDown Declaration
    var houseDropDown = DropDown()
    var classDropDown = DropDown()
    
    var arrSelectedData = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "House List"
        navigationView.delegate = self
        setHouseDropDown()
        
        self.lblSelectClass.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblSelectHouse.font = UIFont.setRegularFont(ofSize: 13.0)
        
        btnGo.titleLabel?.font = UIFont.setRegularFont(ofSize: 13.0)
        self.txtClass.font = UIFont.setRegularFont(ofSize: 13.0)
        self.txtHouse.font = UIFont.setRegularFont(ofSize: 13.0)

        self.configureTableView()
        self.callAPIForGetHouseList { (check) in
            self.tableView.reloadData()
            self.callAPIForClassList { (check) in
                
            }
        }
    }
    
    //Set DropMenu
    func setHouseDropDown(){
        houseDropDown.anchorView = txtHouse
        houseDropDown.direction = .bottom
        houseDropDown.textFont = UIFont.setRegularFont(ofSize: 13)
        houseDropDown.width = txtHouse.frame.size.width
        houseDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        
        classDropDown.anchorView = txtClass
        classDropDown.direction = .bottom
        classDropDown.textFont = UIFont.setRegularFont(ofSize: 13)
        classDropDown.width = txtClass.frame.size.width
        classDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        
    }
    
    func setHouseListDropDownData(){
        var strArr = [String]()
        for item in self.arrHouseList{
            strArr.append(item.houseno!)
        }
//        houseDropDown.dataSource = strArr
//
//        houseDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            self.selectedID = self.arrHouseList[index].id ?? ""
//            // print("Selected item: \(item) at index: \(index)")
//            self.txtHouse.text = item
//            self.houseDropDown.hide()
//        }
//        houseDropDown.show()
        if let viewController: CustomDropDown = CustomDropDown.storyboardInstance.initialize() {
            
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.strTitle = "Select House"
            viewController.arrItems = strArr
            viewController.arrSelectedItem = self.arrSelectedHouseIndex
            viewController.doneHandler = { (selectedItem) in
                
                self.arrSelectedHouseIndex = selectedItem
                self.arrSelectedData.removeAll()
                var arrStrData = [String]()
                for i in 0..<selectedItem.count{
                    if(selectedItem[i] == 1){
                        arrStrData.append(self.arrHouseList[i].houseno ?? "")
                    }
                }
                if(arrStrData.count > 0){
                    self.txtHouse.text = "\(arrStrData.count )"
                    
                }
                self.setCollectionData(arrData: arrStrData)
                
            }
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func configureTableView() {
    
        // Register Cell
        let cellNib = UINib(nibName: String(describing: HouseListCell.self), bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: HouseListCell.cellId)
        
        let colcellNib = UINib(nibName: String(describing: ClassCollectionCell.self), bundle: nil)
        self.collView.register(colcellNib, forCellWithReuseIdentifier: ClassCollectionCell.cellId)
        
        // Automatic row dimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 55
    }
    
    //MARK:- Action Event -
    @IBAction func actionSelectHouse(_ sender: Any) {
        if(self.arrHouseList.count == 1){
            //self.arrHouseList.removeAll()
            self.callAPIForGetHouseList { (check) in
               // self.tableView.reloadData()
                self.setHouseListDropDownData()
            }
        }else{
            setHouseListDropDownData()
        }
    }
    
    @IBAction func actionSelectClass(_ sender: Any) {
        var strArr = [String]()
        for item in self.arrClassList{
            let name = (item.standard ?? "") + " " + (item.section ?? "")
            strArr.append(name)
        }
//        classDropDown.dataSource = strArr
//
//        classDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            // print("Selected item: \(item) at index: \(index)")
//            self.selectedClass = self.arrClassList[index].id ?? ""
//            self.txtClass.text = item
//            self.classDropDown.hide()
//        }
//        classDropDown.show()
        if let viewController: CustomDropDown = CustomDropDown.storyboardInstance.initialize() {
            
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.strTitle = "Select Class"
            viewController.arrItems = strArr
            viewController.arrSelectedItem = self.arrSelectedIndex
            viewController.doneHandler = { (selectedItem) in
                
                self.arrSelectedIndex = selectedItem
                self.arrSelectedData.removeAll()
                var arrStrData = [String]()
                
                for i in 0..<selectedItem.count{
                    if(selectedItem[i] == 1){
                        let name = (self.arrClassList[i].standard ?? "") + "-" + (self.arrClassList[i].section ?? "")
                        arrStrData.append(name)
                    }
                }
                if(arrStrData.count > 0){
                    self.txtClass.text = "\(arrStrData.count )"
                    
                }
                 self.setCollectionData(arrData: arrStrData)
            }
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func setCollectionData(arrData:[String]){
        
        for i in 0..<arrSelectedHouseIndex.count{
            if(arrSelectedHouseIndex[i] == 1){
                arrSelectedData.append(self.arrHouseList[i].houseno ?? "")
            }
        }
        
        for i in 0..<arrSelectedIndex.count{
            if(arrSelectedIndex[i] == 1){
               
                let name = (self.arrClassList[i].standard ?? "") + "-" + (self.arrClassList[i].section ?? "")
                arrSelectedData.append(name)
            }
        }
        
        self.collView.isHidden = true
        self.collView.reloadData()
    }
    @IBAction func actionGoClick(_ sender: Any) {

        if(self.txtHouse.text!.isEmpty && self.txtClass.text!.isEmpty){
            self.toast("Please select atleast one house & class")
        }
        else if(self.txtHouse.text!.isEmpty){
            self.toast("Please select house")
        }
        else if(self.txtClass.text!.isEmpty){
            self.toast("Please select class")
        } else{
            self.callAPIForHouseReport { (success) in
                self.tableView.reloadData()
            }
        }
    }
}

extension HouseListViewController: NavigationBarViewDelegate {
    func onTapDropDown() {
        
    }
    func onTapMenu() {
        
    }
    
    func onTapBack() {
        self.navigationController?.popViewController(animated: true)
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

extension HouseListViewController: UITableViewDelegate {
    
}

extension HouseListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrHouseReports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: HouseListCell.cellId, for: indexPath) as! HouseListCell
        cell.lblCount.text = "\(indexPath.row + 1)"
        cell.setUpCell(data: self.arrHouseReports[indexPath.row], path: imgPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
extension HouseListViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrSelectedData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassCollectionCell", for: indexPath) as! ClassCollectionCell
        cell.viewController = self
      cell.btnTitle.setTitle(self.arrSelectedData[indexPath.row], for: .normal)
        cell.btnTitle.titleLabel?.font = UIFont.setRegularFont(ofSize: 13.0)
      
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
    
    func deleteRecord(cell : ClassCollectionCell){
        if let indexPath = self.collView.indexPath(for: cell){
            print(indexPath.row)
            
            let check = self.arrHouseList.contains { (itemData) -> Bool in
                itemData.houseno == self.arrSelectedData[indexPath.row]
            }
            if(check){
                
                self.arrSelectedData.remove(at: indexPath.row)
                if let row = self.arrSelectedHouseIndex.firstIndex(where: {$0 == 1}) {
                    self.arrSelectedHouseIndex[row] = 0
                }
               // self.arrSelectedHouseIndex[indexPath.row] = 0
                let arrCheck = self.arrSelectedHouseIndex.filter { (check) -> Bool in
                    check == 1
                }
                print(arrCheck.count)
                DispatchQueue.main.async{
                    if(arrCheck.count == 0){
                        self.txtHouse.text = ""
                    }else{
                        self.txtHouse.text = "\(arrCheck.count)"
                    }
                    
                }
            }else{
                let check = self.arrSelectedIndex.contains { (itemData) -> Bool in
                    itemData == 1
                }
                if(check){
                    self.arrSelectedData.remove(at: indexPath.row)
                    if let row = self.arrSelectedIndex.firstIndex(where: {$0 == 1}) {
                        self.arrSelectedIndex[row] = 0
                    }
                   // self.arrSelectedIndex[indexPath.row] = 0
                    let arrCheck = self.arrSelectedIndex.filter { (check) -> Bool in
                        check == 1
                    }
                    print(arrCheck.count)
                    DispatchQueue.main.async{
                        if(arrCheck.count == 0){
                            self.txtClass.text = ""
                        }else{
                            self.txtClass.text = "\(arrCheck.count)"
                        }
                        
                    }
                }
            }
            

//
//
//
            self.collView.reloadData()
            
//            if(indexPath.row < count){
//                //self.arrSelectedHouseIndex.remove(at: indexPath.row)
//
//                self.arrSelectedHouseIndex.remove(at: indexPath.row)
//
//                self.arrSelectedData.remove(at: indexPath.row)
//
//                self.arrSelectedHouseIndex.insert(0, at: indexPath.row)
//
//                count = count - 1
//
//                print(count)
//                DispatchQueue.main.async{
//                    self.txtHouse.text = "\(count)"
//
//                }
//                self.collView.reloadData()
//            }
//            else{
//
//                var count11 = 0
//                for i in 0..<self.arrSelectedIndex.count {
//                    if(self.arrSelectedIndex[i] == 1){
//                        count11 = count11 + 1
//                    }
//                }
//
//                self.arrSelectedIndex.remove(at: indexPath.row)
//                self.arrSelectedData.remove(at: indexPath.row)
//                self.arrSelectedIndex.insert(0, at: indexPath.row)
//
//                count11 = count11 - 1
//
//                self.collView.reloadData()
//                DispatchQueue.main.async{
//                    self.txtClass.text = "\(count11)"
//                }
//            }
       }
    }
    
}
extension HouseListViewController {

        func callAPIForGetHouseList(finished:@escaping(_ success: Bool) -> Void) {
            Loader.show()
            StaffManageMentAPI.houseList() { (respose, error) in
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
                
                self.arrHouseList = responseData
                finished(true)
            }
        }
    
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
    
    func callAPIForHouseListByID(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        StaffManageMentAPI.houseListByID(houseID: self.selectedID) { (respose, error) in
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
            
            self.arrHouseList = [responseData]
            finished(true)
        }
    }
    
    func callAPIForHouseReport(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        
        var arrClass = [String]()
        var arrHouse = [String]()
       // selectedClass = "5e3ecdb41e4c4291e437f032"
       
        for i in 0..<self.arrSelectedIndex.count{
            if(self.arrSelectedIndex[i] == 1){
                arrClass.append(self.arrClassList[i].id ?? "")
            }
        }
        
        for i in 0..<self.arrSelectedHouseIndex.count{
            if(self.arrSelectedHouseIndex[i] == 1){
                arrHouse.append(self.arrHouseList[i].id ?? "")
            }
        }
        
        
//        var dictParam = [String:Any]()
//        dictParam["standard_sections"] = arrClass
//        dictParam["houses"] = arrHouse
        
        let requestParam = HouseReport(standard_sections: arrClass, houses: arrHouse)
        StaffManageMentAPI.houseListReport(body: requestParam) { (respose, error) in
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
            
            self.arrHouseReports = responseData
            self.imgPath = response.path ?? ""
            if(self.arrHouseReports.count == 0){
                self.toast("There are no record for the selected details")
            }
            finished(true)
        }
    }
}

