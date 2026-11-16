//
//  WebViewController.swift
//  MountCarmel
//
//  Created by user on 18/05/22.
//  Copyright © 2022 InventionHill. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController, Rotatable {

    @IBOutlet weak var webView: WKWebView!{didSet{webView.navigationDelegate = self}}
    @IBOutlet weak var lblTitle: UILabel!
    
    var url : URL?
    var Title = ""
    var fileName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.modalPresentationStyle = .overFullScreen
        
        lblTitle.text = Title
        
        if let ForceUrl = url{
            Loader.show()
            webView.load(URLRequest(url: ForceUrl))
            return
        }
        
        self.toast("File does not exist on server!!")
    }
    
    @IBAction func btnShare(_ sender: Any) {
        guard let ForceUrl = url else { return }
        self.download(from: ForceUrl)
    }
    
    private func ShowActivityController(_ data:Data){
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let activityController =  UIActivityViewController(activityItems: [data], applicationActivities: nil)
            self.present(activityController, animated: true)
        }
    }

    @IBAction func btnBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
     
        if let nav = self.navigationController {
            if nav.viewControllers.count == 1{
                self.setHomeScreen()
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }else {
            self.dismiss(animated: true, completion: nil)
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

extension WebViewController:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
   }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        Loader.hide()
        toast(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
            Loader.hide()
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Loader.hide()
        toast(error.localizedDescription)
 }
}

extension WebViewController:URLSessionDownloadDelegate{
    
    // MARK: download videos
     private func download(from url: URL) {
         Loader.show()
         
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
            
        let downloadTask = session.downloadTask(with: url)
        downloadTask.resume()
    }
    
    // MARK: protocol stub for download completion tracking
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        Loader.hide()
        print("===================",location)
        do{
            let pdfData = try Data(contentsOf: location)
            self.ShowActivityController(pdfData)
            
        }catch let err{
            print(err.localizedDescription)
        }
        
    }
    
}


