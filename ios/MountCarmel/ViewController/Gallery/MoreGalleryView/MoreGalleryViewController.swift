//
//  MoreGalleryViewController.swift
//  MountCarmel
//
//  Created by Sandip on 27/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class MoreGalleryViewController: UIViewController {
    
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var navigationView: NavigationBarView!
    var objData : GalleryAPIData?
    var arrImages = [Photos]()
    var urlPath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = objData?.gallery_name ?? ""
        navigationView.delegate = self
        
        lblDate.font = UIFont.setBoldFont(ofSize: 15.0)
        lblDate.text = CommonFunctions.getDateString(date: objData?.created_at ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.ddMMMyyyy)
        
        let cellNib = UINib(nibName: String(describing: ImageCollectionCell.self), bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: ImageCollectionCell.cellId)
        
        self.arrImages = objData?.photos ?? [Photos]()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        
        // Do any additional setup after loading the view.
    }
}

extension MoreGalleryViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        
        let imageURL = urlPath + (arrImages[indexPath.row].filename ?? "")
        cell.imgView.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size.width
        return CGSize(width: (collectionViewSize)/3, height: (collectionViewSize)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let imageURL = urlPath + (arrImages[indexPath.row].filename ?? "")
//        if let viewController: ImagePreviewViewController = ImagePreviewViewController.storyboardInstance.initialize() {
//            viewController.strImgURL = imageURL
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }
        
        var images = [SKPhoto]()
        
        for image in arrImages{
            let imageURL = urlPath + (image.filename ?? "")
            let photo = SKPhoto.photoWithImageURL(imageURL)
            photo.shouldCachePhotoURLImage = true // you can use image cache by true(NSCache)
            images.append(photo)
        }
        // 1. create URL Array
        
        
        // 2. create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(indexPath.row)
        SKPhotoBrowserOptions.displayAction = false
        present(browser, animated: true, completion: {})
        //viewController?.previewImageView()
    }
    
}

extension MoreGalleryViewController: NavigationBarViewDelegate {
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
