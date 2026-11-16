//
//  HouseListCell.swift
//  MountCarmel
//
//  Created by Niraj on 05/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class HouseListCell: UITableViewCell {

    @IBOutlet var lblHouseName: UILabel!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblID: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.font = UIFont.setRegularFont(ofSize: 12.0)
        lblID.font = UIFont.setRegularFont(ofSize: 11.0)
        lblCount.font = UIFont.setRegularFont(ofSize: 12.0)
        lblHouseName.font = UIFont.setRegularFont(ofSize: 12.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(data : HouseReportData, path : String){
        lblName.text = data.name
        lblID.text = data.admission_no
        lblHouseName.text = data.house_id?.house_no
        let imageUrl = path+(data.profile_pic ?? "")
        //studentImageIssue
        self.imgProfile.sd_setImage(with: URL(string:imageUrl ), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
    }
    
}
