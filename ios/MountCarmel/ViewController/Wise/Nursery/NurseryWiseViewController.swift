//
//  NurseryWiseViewController.swift
//  MountCarmel
//
//  Created by Niraj on 12/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class NurseryWiseViewController: UIViewController {

    @IBOutlet var lblstaturecount: UILabel!
    @IBOutlet var lblEmotionCount: UILabel!
    @IBOutlet var lblintellectCount: UILabel!
    @IBOutlet var lblWorthyCount: UILabel!
    @IBOutlet var lblClass: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgProfile: RoundedImage!
    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet weak var wiseView: WiseView!
    var objStudentWiseData : StudentWiseResponseData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "WISE"
        navigationView.delegate = self
        wiseView.delegate = self
        wiseView.isHidden = true
        
        self.lblName.font = UIFont.setBoldFont(ofSize: 14.0)
        
        self.lblClass.font = UIFont.setRegularFont(ofSize: 11.0)
//        self.lblstaturecount.font = UIFont.setRegularFont(ofSize: 12.0)
//        self.lblEmotionCount.font = UIFont.setRegularFont(ofSize: 12.0)
//        self.lblintellectCount.font = UIFont.setRegularFont(ofSize: 12.0)
//        self.lblWorthyCount.font = UIFont.setRegularFont(ofSize: 12.0)
        
        let userInfo = APP_DELEGATE.userInfo
     //   let urlPath = APP_DELEGATE.urlPath + "/"
        
        //studentImageIssue
        
        let imageURL = (APP_DELEGATE.loginAPIResponse?.path ?? "") + (APP_DELEGATE.selected_Student?.studentId?.profile_pic ?? "")
        
        self.imgProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
        self.lblName.text = userInfo?.name
        let arrStudents = userInfo?.students ?? [LoginAPIStudent]()
        if(arrStudents.count > 0){
            self.lblClass.text = (arrStudents[0].studentId?.standardId?.name ?? "") + "-" + (arrStudents[0].studentId?.sectionId?.name ?? "")
        }else{
            self.lblClass.text = ""
        }
        
        self.callAPIStudentWiseCard { (check, objData) in
            if(check){
                self.objStudentWiseData = objData
                self.lblWorthyCount.text = String(self.objStudentWiseData?.worthy?.count ?? 0)
                self.lblEmotionCount.text = String(self.objStudentWiseData?.emotion?.count ?? 0)
                self.lblstaturecount.text = String(self.objStudentWiseData?.stature?.count ?? 0)
                self.lblintellectCount.text = String(self.objStudentWiseData?.intellect?.count ?? 0)
                
            }
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func btnTapWiseButtons(_ sender: UIButton) {
        
        if(sender.tag == 1 || sender.tag == 11 ){
            wiseView.arrCardTypeData = self.objStudentWiseData?.worthy?.data ?? [AllCardTypeData]()
            wiseView.cardType = "WORTHY"
            wiseView.selectedColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }else if(sender.tag == 2 || sender.tag == 22 ){
            wiseView.arrCardTypeData = self.objStudentWiseData?.intellect?.data ?? [AllCardTypeData]()
            wiseView.cardType = "INTELLECT"
            wiseView.selectedColor = #colorLiteral(red: 0.2117647059, green: 0.3803921569, blue: 0.6392156863, alpha: 1)
        }else if(sender.tag == 3 || sender.tag == 33 ){
            wiseView.arrCardTypeData = self.objStudentWiseData?.stature?.data ?? [AllCardTypeData]()
            wiseView.cardType = "STATURE"
            wiseView.selectedColor = #colorLiteral(red: 0.9620772004, green: 0.6563818455, blue: 0.2461998165, alpha: 1)
        }else if(sender.tag == 4 || sender.tag == 44 ){
            wiseView.arrCardTypeData = self.objStudentWiseData?.emotion?.data ?? [AllCardTypeData]()
            wiseView.cardType = "EMOTION"
            wiseView.selectedColor = #colorLiteral(red: 0.2901960784, green: 0.6039215686, blue: 0.4588235294, alpha: 1)
        }
        
        if(wiseView.arrCardTypeData.count > 0){
            wiseView.arrCardTypeData = wiseView.arrCardTypeData.sorted(by: { $0.wise_date ?? "" > $1.wise_date ?? "" })
            wiseView.isHidden = false
            wiseView.delegate = self
            wiseView.configureCollectionView()
        }
    }
    
    @IBAction func actionKnowMoreClick(_ sender: Any) {
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImage(#imageLiteral(resourceName: "WiseKnowMore"))// add some UIImage
        images.append(photo)
        
        // 2. create PhotoBrowser Instance, and present from your viewController.
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
}

extension NurseryWiseViewController: WiseViewDelegate {
    func onTapClose() {
        wiseView.isHidden = true
    }
}

extension NurseryWiseViewController: NavigationBarViewDelegate {
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
extension NurseryWiseViewController {
    
    func callAPIStudentWiseCard(finished:@escaping(_ success: Bool, _ responseData: StudentWiseResponseData?) -> Void) {
        Loader.show()
        
        let URLString = API_STUDENTWISE + (APP_DELEGATE.selected_Student?.admissionNo ?? "") //"11153425" //
        
        print(URLString)
        
        WiseManagementAPI.getstudentWiseCards(url: URLString, completion: { (response, error) in
            Loader.hide()
            guard let response = response else {
               // let message = error?.localizedDescription ?? "Invalid Response"
                finished(false, nil)
                return
            }
            
            guard response.status == true else {
                self.toast(response.message ?? "")
                finished(false, nil)
                return
            }
            guard let responseData = response.data else {
              //  let message = response.message ?? "Invalid Response"
                finished(false, nil)
                return
            }
            finished(true, responseData)
        })
    }
}
