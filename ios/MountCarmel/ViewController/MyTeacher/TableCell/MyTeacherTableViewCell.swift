//
//  MyTeacherTableViewCell.swift
//  MountCarmel
//
//  Created by Sandip on 08/11/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class MyTeacherTableViewCell: UITableViewCell {
    
    @IBOutlet var lblPost: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var backView: UIView!
    @IBOutlet weak var surveyCTA: UIView!
    
    var onPress: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.font = UIFont.setRegularFont(ofSize: 12.0)
        lblPost.font = UIFont.setRegularFont(ofSize: 11.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func handleTeacherViewPress(_ sender: UIButton) {
        onPress?()
    }
}
