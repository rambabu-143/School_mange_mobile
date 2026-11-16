//
//  AssignmentsCell.swift
//  MountCarmel
//
//  Created by Niraj on 14/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class AssignmentsCell: UICollectionViewCell {

    @IBOutlet weak var lblSyllabusName: UILabel!
    @IBOutlet weak var lblData: UILabel!
    @IBOutlet weak var imageSyllabus: RoundedImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblSyllabusName.font = UIFont.setRegularFont(ofSize: 12.0)
        self.lblData.font = UIFont.setRegularFont(ofSize: 10.0)
        // Initialization code
    }
}
