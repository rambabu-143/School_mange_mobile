//
//  WiseViewCell.swift
//  MountCarmel
//
//  Created by Niraj on 12/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import ScalingCarousel

class WiseViewCell: ScalingCarouselCell {

    @IBOutlet var viewcircleView: RoundedView!
    @IBOutlet var lblCradTypeTopCons: NSLayoutConstraint!
    @IBOutlet var lblCardType: UILabel!
    @IBOutlet var titleType: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblRemark: UILabel!
    @IBOutlet var circleView: RoundedView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleType.font = UIFont.setBoldFont(ofSize: 90)
        self.lblCardType.font = UIFont.setBoldFont(ofSize: 13)
        self.lblRemark.font = UIFont.setRegularFont(ofSize: 13)
         self.lblName.font = UIFont.setBoldFont(ofSize: 12)
         self.lblDate.font = UIFont.setRegularFont(ofSize: 11)
        
        if DeviceType.IS_IPHONE_X_PLUS || DeviceType.IS_IPHONE_6_PLUS{
            lblCradTypeTopCons.constant = 160
        }else{
            lblCradTypeTopCons.constant = 100
        }
       // circleView.cornerRadius = circleView.frame.size.height/2
        // Initialization code
    }

}
