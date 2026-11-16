//
//  DataSheetViewController.swift
//  MountCarmel
//
//  Created by Apple on 11/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import WebKit

class DataSheetViewController: UIViewController {

    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var tblDateSheet: UITableView!
    // var objDataSheet : DataSheetData?
    var arrObjDataSheet = [StaffNoticeList]()
    var urlPath = ""
    var isFromFee = false
    var strTitle = ""
    var imgPath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationView.delegate = self
        
        if isFromFee {
            navigationView.lblTitle.text = strTitle
            loadWebView()
        }else{
            navigationView.lblTitle.text = "Date Sheet"
            self.configureTableView()
            
            self.callGetDataSheetAPI { (success) in
                if(success){
                  //  self.loadWebView()
                    self.tblDateSheet.reloadData()
                }
            }
        }
        
    }
    
    private func configureTableView() {
        tblDateSheet.delegate = self
        tblDateSheet.dataSource = self
        // Register Cell
        let cellNib = UINib(nibName: String(describing: NoticeCell.self), bundle: nil)
        self.tblDateSheet.register(cellNib, forCellReuseIdentifier: NoticeCell.cellId)
        
        // Automatic row dimension
        self.tblDateSheet.rowHeight = UITableView.automaticDimension
        self.tblDateSheet.estimatedRowHeight = 65
    }
    
    private func loadWebView(){
        Loader.show()
        var strUrl = ""
        if isFromFee {
            navigationView.lblTitle.text = strTitle
             strUrl = urlPath
        }else{
            // strUrl = urlPath + "/" + (objDataSheet?.attachment ?? "")
            
        }
        
        let url = URL(string: strUrl)!
        webView.backgroundColor = UIColor.white
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
    }
}

extension DataSheetViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Loader.hide()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Loader.hide()
    }
}

extension DataSheetViewController: NavigationBarViewDelegate {
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
extension DataSheetViewController{
   /* func callGetDataSheetAPI(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        ParentManagementAPI.getDataSheet { (respose, error) in
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
            
            self.arrObjDataSheet = responseData
            self.urlPath = response.path ?? ""
           
            finished(true)
        }
    }*/
    
   private func callGetDataSheetAPI(finished:@escaping(_ success: Bool) -> Void) {
         Loader.show()
         ParentManagementAPI.getDataSheet { (respose, error) in
             Loader.hide()
             guard let responseData = respose?.data else {
                 self.toast(respose?.message ?? "Invalid Response")
                 finished(false)
                 return
             }
             
             guard responseData.count != 0 else{
                 self.toast(respose?.message ?? "Invalid Response")
                 finished(false)
                 return
             }
             
             self.arrObjDataSheet = responseData
             self.imgPath = respose?.path ?? ""
             finished(true)
         }
      }
    
}

extension DataSheetViewController: UITableViewDelegate {
    
}

extension DataSheetViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrObjDataSheet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: NoticeCell.cellId, for: indexPath) as! NoticeCell
       
            cell.setUpStaffCellData(data: self.arrObjDataSheet[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        var fileURL = ""
        var fileName = ""
        var title = ""
        
        fileURL = imgPath + (self.arrObjDataSheet[indexPath.row].attachments?[0] ?? "")
        fileName = self.arrObjDataSheet[indexPath.row].attachments?[0] ?? ""
        title = self.arrObjDataSheet[indexPath.row].title ?? ""
        
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
