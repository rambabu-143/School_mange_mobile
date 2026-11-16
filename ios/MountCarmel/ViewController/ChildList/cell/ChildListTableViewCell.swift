//
//  ChildListTableViewCell.swift
//  MountCarmel
//
//  Created by Sandip on 06/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class ChildListTableViewCell: UITableViewCell {
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var imgProfile: RoundedImage!
    @IBOutlet var btnClass: RoundedButton!
    @IBOutlet var lblID: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblName.font = UIFont.setBoldFont(ofSize: 15)
        self.lblID.font = UIFont.setRegularFont(ofSize: 13)
        self.btnClass.titleLabel?.font = UIFont.setRegularFont(ofSize: 14)
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
