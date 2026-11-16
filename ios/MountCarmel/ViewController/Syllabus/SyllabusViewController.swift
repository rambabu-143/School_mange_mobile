//
//  SyllabusViewController.swift
//  MountCarmel
//
//  Created by Niraj on 06/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import DropDown
import QuickLook
class SyllabusViewController: UIViewController {

    @IBOutlet var lblClass: UILabel!
    @IBOutlet var txtClass: UITextField!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet weak var navigationView: NavigationBarView!
    var arrClassList = [ClassListWithSectionData]()
    var selectedClassID = ""
    let imageArray = ["English", "Hindi", "Math", "EVS"]
    let titleArray = ["English", "Hindi", "Math", "EVS"]
    var classDropDown = DropDown()
    var arrSyllabusList = [SyllabusData]()
    var selectedID = ""
    var imgPath = ""
     var previewItem : URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        
        navigationView.lblTitle.text = "Syllabus"
        navigationView.delegate = self
        setHouseDropDown()
        let name = (APP_DELEGATE.userInfo?.staffId?.classTeacherID?.standard ?? "")
        
        self.txtClass.text = name + "-" + (APP_DELEGATE.userInfo?.staffId?.classTeacherID?.section ?? "")
        self.lblClass.text = self.txtClass.text
        self.callAPIForClassList { (success) in
            if(success){
            if(APP_DELEGATE.userInfo?.staffId?.isClassTeacher ?? false){
                    self.selectedID = APP_DELEGATE.userInfo?.staffId?.classTeacherID?._id ?? ""
                }
                self.callAPIForSyllabusList { (success) in
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func setHouseDropDown(){
        classDropDown.anchorView = txtClass
        classDropDown.direction = .bottom
        classDropDown.width = txtClass.frame.size.width
        classDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        
    }
    
     func configureCollectionView() {
         // Register Cell
         let cellNib = UINib(nibName: String(describing: SyllabusCell.self), bundle: nil)
         self.collectionView.register(cellNib, forCellWithReuseIdentifier: SyllabusCell.cellId)
     }
    
    @IBAction func actionSelectClass(_ sender: Any) {
        var strArr = [String]()
        for item in self.arrClassList{
            let name = (item.standard ?? "") + "-" + (item.section ?? "")
            strArr.append(name)
        }
        classDropDown.dataSource = strArr
        
        classDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedID = self.arrClassList[index].id ?? ""
            self.lblClass.text = item
            self.txtClass.text = item
            self.classDropDown.hide()
            self.callAPIForSyllabusList { (success) in
                if(success){
                    self.collectionView.reloadData()
                }
            }
           
        }
        classDropDown.show()
    }
}

extension SyllabusViewController: NavigationBarViewDelegate {
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


extension SyllabusViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: (collectionView.frame.size.width/2) - 10, height: (collectionView.frame.size.width/2) - 10)
    }
}

extension SyllabusViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSyllabusList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Dequeue cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SyllabusCell.cellId, for: indexPath) as! SyllabusCell
        cell.lblSyllabusName.text = self.arrSyllabusList[indexPath.row].subject_name
        
        
   /* if(self.arrSyllabusList[indexPath.row].subject_name?.lowercased() == "math"){
            cell.imageSyllabus.image = #imageLiteral(resourceName: "Math")
        }else{
            cell.imageSyllabus.image = #imageLiteral(resourceName: "English")
        }*/
       // cell.imageSyllabus.image = UIImage(named: self.imageArray[indexPath.row])
      
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let previewController = QLPreviewController()
        previewController.dataSource = self as! QLPreviewControllerDataSource
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        let fileURL = imgPath + "/" + (self.arrSyllabusList[indexPath.row].attachment ?? "")
        Loader.show()
        let url = URL(string: fileURL)!
        CommonFunctions.downloadfile(viewcontroller: self, url: url, mimeType: "", fileName: self.arrSyllabusList[indexPath.row].attachment ?? "") { (check, strURLPath) in
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
        }
        
    }
}
extension SyllabusViewController{
    func callAPIForClassList(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        StaffManageMentAPI.classList() { (respose, error) in
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
            
            self.arrClassList = responseData
            if(self.arrClassList.count > 0){
                //                self.txtClass.text = self.arrClassList[0].name ?? ""
                //                self.selectedID = self.arrClassList[0].id ?? ""
            }
            
            finished(true)
        }
    }
    
    func callAPIForSyllabusList(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        self.selectedID = "5e392994e0687b1082b208df"
        StaffManageMentAPI.syllabusList(studentId: self.selectedID) { (respose, error) in
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
            
            self.arrSyllabusList = responseData
            if(self.arrSyllabusList.count == 0){
                self.toast("No syllabus available for selected records.")
            }
            self.imgPath = response.path ?? ""
            finished(true)
        }
    }
}
//MARK:- QLPreviewController Datasource

extension SyllabusViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        
        return self.previewItem! as QLPreviewItem
    }
}
