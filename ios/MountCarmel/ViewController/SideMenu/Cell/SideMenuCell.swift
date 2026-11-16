//
//  SideMenuCell.swift
//  MountCarmel
//
//  Created by Apple on 01/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var selectedView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        titleLabel.font = UIFont.setRegularFont(ofSize: 11.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectedView.backgroundColor = selected ? UIColor.yellow : UIColor.clear
        titleLabel.textColor = selected ? UIColor.yellow : UIColor.white
    }
}

