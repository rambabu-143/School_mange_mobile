//
//  GalleryViewController.swift
//  MountCarmel
//
//  Created by Sandip on 10/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class GalleryViewController: UIViewController {
    @IBOutlet weak var navigationView: NavigationBarView!

    @IBOutlet var tblGalleryList: UITableView!
    var arrTitle = ["Udaipur Trip","Nasa Trip","Computer week at MCS"]
    
    var arrGalleryData = [GalleryAPIData]()
    var imgPath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "Gallerie"
        navigationView.delegate = self
        setInitialView()
        
        self.callAPIStudentDetails { (success, objData) in
            if(success){
                self.callAPIForGalleryList(dateVal: objData?.data?.date_of_admission ?? "") { (success) in
                    if(success){
                        self.tblGalleryList.reloadData()
                    }
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    func setInitialView(){
        tblGalleryList.register(UINib(nibName: "GalleryCell", bundle: nil), forCellReuseIdentifier: "GalleryCell")
    }
}

extension GalleryViewController: NavigationBarViewDelegate {
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
extension GalleryViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrGalleryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblGalleryList.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath) as? GalleryCell
        cell?.viewController = self
        cell?.btnNext.tag = indexPath.row
        cell?.setUpCell(objData : arrGalleryData[indexPath.row], strImagePath: imgPath)
        
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
    
    func viewMoreImage(index : Int){

        
        if let viewController: MoreGalleryViewController = MoreGalleryViewController.storyboardInstance.initialize() {
            viewController.objData = arrGalleryData[index]
            viewController.urlPath = imgPath
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func previewImageView(imgPath : String){
        if let viewController: ImagePreviewViewController = ImagePreviewViewController.storyboardInstance.initialize() {
            viewController.strImgURL = imgPath
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
extension GalleryViewController{
    
    func callAPIStudentDetails(finished:@escaping(_ success: Bool, _ response: StudentDetailAPIResponse?) -> Void) {
        Loader.show()
        
        StudentManagementAPI.getStuddentDetails(studentID: APP_DELEGATE.selected_Student?.studentId?.ID ?? "") { (response, error) in
            Loader.hide()
            guard let response = response else {
              //  let message = error?.localizedDescription ?? "Invalid Response"
                print(error)
                finished(false, nil)
                return
            }
            guard response.status == true else {
                self.toast(response.message ?? "")
                finished(false, nil)
                return
            }
            guard let responseData = response.message else {
                let message = response.message ?? "Invalid Response"
                finished(false, nil)
                return
            }
            finished(true, response)
        }
    }
    
    func callAPIForGalleryList(dateVal : String?,finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        let Date = CommonFunctions.UTCToLocal(date: dateVal ?? "", fromFormat: DateFormat.DateFormat_ddMMYYYY, toFormat: DateFormat.DateFormat_DDMMYYYY)
       
        
        StudentManagementAPI.gallary(dateOfAdmission: Date) { (respose, error) in
            Loader.hide()
            guard let response = respose else {
                self.toast(error?.localizedDescription ?? "Invalid Response")
                finished(false)
                return
            }
            
//            guard response.status == true else {
//                self.toast(response.message ?? "Invalid Response")
//               // CommonFunctions.logOutFromAPP()
//                finished(false)
//                return
//            }
            
            guard let responseData = response.data else {
                self.toast(response.message ?? "Invalid Response")
                finished(false)
                return
            }
            
            self.arrGalleryData = responseData
            self.imgPath = response.path ?? ""
            if(self.arrGalleryData.count == 0){
                self.toast("No records found")
            }
            finished(true)
        }
    }
}
