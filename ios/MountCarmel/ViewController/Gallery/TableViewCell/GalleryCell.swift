//
//  GalleryCell.swift
//  MountCarmel
//
//  Created by Sandip on 10/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class GalleryCell: UITableViewCell {

    @IBOutlet var btnNext: UIButton!
    var viewController : GalleryViewController?
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTitle: UILabel!
    var arrImages = [Photos]()
    var urlPath = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Register Cell
        let cellNib = UINib(nibName: String(describing: ImageCollectionCell.self), bundle: nil)
        self.collView.register(cellNib, forCellWithReuseIdentifier: ImageCollectionCell.cellId)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUpCell(objData : GalleryAPIData , strImagePath : String){
        self.urlPath = strImagePath
        self.arrImages = objData.photos ?? [Photos]()
        if(self.arrImages.count > 3){
            btnNext.isUserInteractionEnabled = true
        }else{
            btnNext.isUserInteractionEnabled = false
        }
        collView.delegate = self
        collView.dataSource = self
        collView.reloadData()
        lblDate.font = UIFont.setRegularFont(ofSize: 11.0)
        lblTitle.font = UIFont.setBoldFont(ofSize: 13.0)
        lblTitle.text = objData.gallery_name ?? ""
        lblDate.text = CommonFunctions.getDateString(date: objData.event_date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
    }
    
    @IBAction func actionNextClick(_ sender: UIButton) {
        viewController?.viewMoreImage(index: sender.tag)
    }
}
extension GalleryCell : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.arrImages.count > 3 ? 3 : self.arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
    
        let imageURL = urlPath + (arrImages[indexPath.row].filename ?? "")
        cell.imgView.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size.width
        return CGSize(width: (collectionViewSize)/3, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//         let imageURL = urlPath + (arrImages[indexPath.row].filename ?? "")
//        viewController?.previewImageView(imgPath: imageURL)
        
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
        viewController?.present(browser, animated: true, completion: {})
        
    }
    
}
