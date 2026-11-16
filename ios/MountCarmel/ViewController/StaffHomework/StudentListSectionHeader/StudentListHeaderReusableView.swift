//
//  StudentListHeaderReusableView.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 14/08/24.
//  Copyright © 2024 Mount Carmel School. All rights reserved.
//

import UIKit

class StudentListHeaderReusableView: UICollectionReusableView {
    static let identifier = "StudentListHeaderReusableView"
    
    private let containerView = UIView()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .darkText
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        return label
    }()
    
    public func configure(headerLabel: String) {
        label.text = headerLabel
        
        containerView.addSubview(label)
        
        addSubview(containerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        containerView.frame = bounds
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
}
