//
//  TransportCell.swift
//  MountCarmel
//
//  Created by Sandip on 10/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class TransportCell: UITableViewCell {
    @IBOutlet var viewCount: RoundedView!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
