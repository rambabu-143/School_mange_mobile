//
//  AssignedHomeworksCell.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 19/08/24.
//  Copyright © 2024 Mount Carmel School. All rights reserved.
//

import Foundation
import UIKit

class AssignedHomeworksCell: UICollectionViewCell {
    var onButtonPress: (() -> Void)? = nil
    var onDelete: (() -> Void)? = nil
    var onHomeworkTextPress: (() -> Void)? = nil
    
    @IBOutlet weak var lblSubjectName: UILabel!
    @IBOutlet weak var lblClassName: UILabel!
    @IBOutlet weak var lblHomeworkText: UILabel!
    @IBOutlet weak var lblAssignedOn: UILabel!
    @IBOutlet weak var lblAssignedBy: UILabel!
    @IBOutlet weak var btnAttachmentLink: UIButton!
    @IBOutlet weak var btnAttachmentLinkWrapper: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblHomeworkText.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        lblHomeworkText.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func onDeletePress(_ sender: UIButton) {
        onDelete?()
    }
    
    @IBAction func onAttachmentPress(_ sender: Any) {
        onButtonPress?()
    }
    
    @objc private func labelTapped(_ gesture: UITapGestureRecognizer) {
        UIView.animate(
        withDuration: 0.1,
        animations: {
            self.lblHomeworkText.alpha = 0.7
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.lblHomeworkText.alpha = 1.0
            }, completion: { _ in
                self.onHomeworkTextPress?()
            })
        }
    }
}
