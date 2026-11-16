//
//  InstallmentCell.swift
//  MountCarmel
//
//  Created by Sandip on 29/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class InstallmentCell: UITableViewCell {

    @IBOutlet var lblPayable: UILabel!
    @IBOutlet var lblReceived: UILabel!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblInstallment: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(data : FeeDetailsInstallment){
        lblInstallment.text = data.inst_no
        lblAmount.text = "\(data.amount ?? 0)"
        lblReceived.text = data.recived
        lblPayable.text = "\(data.amount_payble ?? 0)"
    }
    
}
