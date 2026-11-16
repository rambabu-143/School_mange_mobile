//
//  StudentListCell.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 13/08/24.
//  Copyright © 2024 Mount Carmel School. All rights reserved.
//

import Foundation
import UIKit

class HomeworkStudentListCell: UICollectionViewCell {
    var onSelect: ((_ selected: Bool) -> Void)? = nil
    
    /// MARK: -  States
    var checked: Bool = false {
        didSet {
            // Properly update the image of the button using setImage(_:for:)
            let imageName = checked ? "checkbox_active" : "checkbox"
            checkboxButton.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    /// MARK: - UI Subviews
    @IBOutlet var studentNameLabel: UILabel!
    @IBOutlet var studentImageView: UIImageView!
    @IBOutlet var checkboxButton: UIButton!
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.studentImageView.layer.cornerRadius = 20.0
    }
    
    func configure(
        studentImageURL: URL?,
        studentName: String?,
        checked: Bool = false
    ) {
        if let imageURL = studentImageURL {
            self.studentImageView.sd_setImage(
                with: imageURL,
                placeholderImage: #imageLiteral(resourceName: "default_p"),
                options: [],
                context: nil
            )
        } else {
            self.studentImageView.image = UIImage(named: "profile-placeholder")
        }
        self.checked = checked
        self.studentNameLabel.text = studentName
    }
    
    func updateCheckbox() {
        // Properly update the image of the button using setImage(_:for:)
        let imageName = checked ? "checkbox_active" : "checkbox"
        checkboxButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @IBAction func onCheckboxPress(_ sender: UIButton) {
        checked.toggle()
        
        // Notify the selection change
        onSelect?(checked)
        
        // Haptic feedback
        feedbackGenerator.impactOccurred()
        
        layoutIfNeeded() // Layout the view to reflect changes
    }
}
