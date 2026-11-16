//
//  WiseView.swift
//  MountCarmel
//
//  Created by Niraj on 12/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import Foundation
import UIKit
import ScalingCarousel

protocol WiseViewDelegate: class {
    func onTapClose()
    
}

class WiseView: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet weak var carousel: ScalingCarouselView!
    @IBOutlet var container: RoundedView!
    
    weak var delegate: WiseViewDelegate?
    var arrCardTypeData = [AllCardTypeData]()
    var cardType = ""
    var selectedColor = UIColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initilize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initilize()
    }
    
    func initilize() {

        // Load the Nib
        Bundle.main.loadNibNamed(String(describing: WiseView.self), owner: self, options: nil)
        
        // Make container fill the view frame
        self.container.frame = self.bounds
        self.container.frame.size.width = UIScreen.main.bounds.size.width
        self.container.clipsToBounds = true
        self.addSubview(self.container)

        self.clipsToBounds = true
        self.configureCollectionView()
        
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(btnCloseTap(_:)))
        mytapGestureRecognizer.numberOfTapsRequired = 1
    self.carousel.addGestureRecognizer(mytapGestureRecognizer)
        
        if DeviceType.IS_IPHONE_X_PLUS{
            self.carousel.inset = 100
        }else{
            self.carousel.inset = 85
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCollectionView() {
        // Register Cell
        WiseView.awakeFromNib()
        let cellNib = UINib(nibName: String(describing: WiseViewCell.self), bundle: nil)
        self.carousel.register(cellNib, forCellWithReuseIdentifier: WiseViewCell.cellId)
        
        self.carousel.reloadData()
        print(arrCardTypeData.count)
        if arrCardTypeData.count != 0{
            self.carousel.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
        }
        
    }
    
    @IBAction func btnCloseTap(_ sender: UIButton) {
        delegate?.onTapClose()
    }
}

typealias CarouselDatasource = WiseView
extension CarouselDatasource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCardTypeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Dequeue cell
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WiseViewCell.cellId, for: indexPath)
    
        if let viewCell = cell as? WiseViewCell{
            viewCell.lblRemark.text = arrCardTypeData[indexPath.row].reason ?? ""
            viewCell.lblName.text = arrCardTypeData[indexPath.row].staff_id?.name ?? ""
            viewCell.viewcircleView.backgroundColor = selectedColor
            viewCell.lblCardType.text = cardType
            viewCell.lblDate.text = CommonFunctions.getDateString(date: arrCardTypeData[indexPath.row].wise_date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.ddMMMyyyy)
            
            if(viewCell.lblCardType.text?.uppercased() == "STATURE"){
                viewCell.titleType.text = "S"
                
            }else if(viewCell.lblCardType.text?.uppercased() == "WORTHY"){
                 viewCell.titleType.text = "W"
                
            }else if(viewCell.lblCardType.text?.uppercased() == "INTELLECT"){
                 viewCell.titleType.text = "I"
            }else if(viewCell.lblCardType.text?.uppercased() == "EMOTION"){
                 viewCell.titleType.text = "E"
            }
            
        }
        
        /*if let scalingCell = cell as? ScalingCarouselCell {
            scalingCell.mainView.backgroundColor = .red
        }*/

        DispatchQueue.main.async {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        
        return cell
    }
}

typealias CarouselDelegate = WiseView
extension WiseView: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //carousel.didScroll()
        
        guard let currentCenterIndex = carousel.currentCenterCellIndex?.row else { return }
    }
}

private typealias ScalingCarouselFlowDelegate = WiseView
extension ScalingCarouselFlowDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    

    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: 250, height: collectionView.frame.size.height)
    }*/
    
}
