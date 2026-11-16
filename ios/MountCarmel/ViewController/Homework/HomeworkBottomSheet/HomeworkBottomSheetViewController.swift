//
//  HomeworkBottomSheetViewController.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 17/07/24.
//  Copyright © 2024 Mount Carmel School. All rights reserved.
//

import UIKit

class HomeworkBottomSheetViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let textLabel = UILabel()
    private let closeButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setHomeworkText(_ text: String) {
        textLabel.text = text
    }

    private func setupViews() {
        view.backgroundColor = UIColor(red: 232, green: 232, blue: 232, alpha: 1)
        
        textLabel.numberOfLines = 0
        scrollView.addSubview(textLabel)
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(scrollView)
        view.addSubview(closeButton)
    }

    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            scrollView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            textLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            textLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
