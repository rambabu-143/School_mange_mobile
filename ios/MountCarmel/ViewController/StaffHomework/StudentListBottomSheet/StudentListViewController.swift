//
//  StudentListViewController.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 12/08/24.
//  Copyright © 2024 Mount Carmel School. All rights reserved.
//

import Foundation
import UIKit

class StudentListViewController: UIViewController {
    var classLabel: String?
    var studentListData: [ClassStudentListData] = [] {
        didSet {
            groupedStudentListData = group(studentList: studentListData)
        }
    }
    var filteredGroupedStudentListData: [[ClassStudentListData]] = []
    var groupedStudentListData: [[ClassStudentListData]] = [] {
        didSet {
            filteredGroupedStudentListData = groupedStudentListData
        }
    }
    var selectedStudentIds: Set<String> = Set()
    
    var onSelectionDone: ((_ selectedStudentIds: [String]) -> Void)? = nil // Closure to pass data back

    @IBOutlet var headerTitleLabel: UILabel!
    @IBOutlet var selectedStudentsNumberLabel: UILabel!
    @IBOutlet var studentListCollectionView: UICollectionView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    @IBAction func actionCloseSheet(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func actionSubmit(_ sender: UIButton) {
        // Pass data back to ViewController B
        onSelectionDone?(Array(selectedStudentIds))
                
        // Dismiss the sheet
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        
        updateHeaderTitle()
        
        handleStudentSelect()
        
        configureSearchBar()
        
        addKeyboardObservers()
        
        configureCollectionView()
    }
    
    deinit {
        // Remove observers
        removeKeyboardObservers()
    }
    
    func addKeyboardObservers() {
        // Add observers for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObservers() {
        // Remove observers for keyboard notifications
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func configureCollectionView() {
        studentListCollectionView.collectionViewLayout = listLayout()
        
        // Register Cell
        let cellNib = UINib(nibName: String(describing: HomeworkStudentListCell.self), bundle: nil)
        self.studentListCollectionView.register(cellNib, forCellWithReuseIdentifier: HomeworkStudentListCell.cellId)
        
        // Register Section Header
        self.studentListCollectionView.register(StudentListHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StudentListHeaderReusableView.identifier)
        
        self.studentListCollectionView.dataSource = self
        self.studentListCollectionView.reloadData()
    }
    
    func handleStudentSelect() {
        updateSelectedStudentsNumLabel(selected: selectedStudentIds.count, total: studentListData.count)
        
        submitButton.isEnabled = selectedStudentIds.count > 0
    }

    func updateSelectedStudentsNumLabel(selected: Int, total: Int) {
        selectedStudentsNumberLabel.text = "\(selected)/\(total) Selected"
    }
    
    func setupData(classLabel: String, studentList: [ClassStudentListData], selectedStudentIds: [String]) {
        self.classLabel = classLabel
        
        self.studentListData = studentList
        
        self.selectedStudentIds = Set(selectedStudentIds)
    }
    
    func updateHeaderTitle() {
        if let classLabel = self.classLabel {
            headerTitleLabel.text = "Students of Class \(classLabel)"
        }
    }
    
    func configureSearchBar() {
        self.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search by name",
            attributes: [.foregroundColor: UIColor.gray]
        )
    }
    
    func group(studentList: [ClassStudentListData]) -> [[ClassStudentListData]] {
        return Dictionary(grouping: studentList) { ($0.name ?? "_").prefix(1) }
            .sorted { $0.key < $1.key }
            .map { $0.value }
    }
    
    private func listLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()

        // Set the item size, assuming full-width items in a list
        flowLayout.itemSize = CGSize(width: studentListCollectionView.bounds.width - 24, height: 50)

        // Set section insets to give a grouped appearance
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)

        // Set minimum spacing between items and lines
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        flowLayout.headerReferenceSize = CGSize(width: studentListCollectionView.bounds.width - 24, height: 30)
        flowLayout.sectionHeadersPinToVisibleBounds = true

        // Set the scroll direction to vertical
        flowLayout.scrollDirection = .vertical

        return flowLayout
    }
}

extension StudentListViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        // Adjust the content inset and scroll indicator insets
        let keyboardHeight = keyboardFrame.height
        studentListCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        studentListCollectionView.scrollIndicatorInsets = studentListCollectionView.contentInset
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // Reset the content inset and scroll indicator insets
        studentListCollectionView.contentInset = .zero
        studentListCollectionView.scrollIndicatorInsets = .zero
    }
}

extension StudentListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.filteredGroupedStudentListData.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredGroupedStudentListData[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StudentListHeaderReusableView.identifier, for: indexPath) as! StudentListHeaderReusableView
        
        if let headerLabel = self.filteredGroupedStudentListData.get(index: indexPath.section)?.get(index: 0)?.name?.first?.description {
            header.configure(headerLabel: headerLabel)
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeworkStudentListCell.cellId, for: indexPath) as! HomeworkStudentListCell
        
        // Applying corner radius
        if collectionView.numberOfItems(inSection: indexPath.section) == 1 {
            cell.layer.cornerRadius = 12
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.layer.masksToBounds = true
        } else if indexPath.item == 0 {
            cell.layer.cornerRadius = 12
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.layer.masksToBounds = true
        } else if indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            cell.layer.cornerRadius = 12
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.layer.masksToBounds = true
        } else {
            cell.layer.cornerRadius = 0
            cell.layer.maskedCorners = []
            cell.layer.masksToBounds = false
        }

        // Remove previous separator if any (to avoid adding multiple separators during reuse)
        cell.contentView.subviews.forEach { subview in
            if subview.tag == 1001 { // Use a unique tag to identify the separator view
                subview.removeFromSuperview()
            }
        }
        
        // Add separator line at the bottom of the cell if it's not the last item
        if indexPath.item < collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            let separatorHeight: CGFloat = 1.0
            let separator = UIView(
                frame: CGRect(
                    x: 60,
                    y: cell.contentView.frame.height - separatorHeight,
                    width: collectionView.frame.width - 60,
                    height: separatorHeight
                )
            )
            separator.backgroundColor = UIColor(red: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0)
            separator.tag = 1001 // Assign a tag to the separator view
            cell.contentView.addSubview(separator)
        }
        
        let cellData = self.filteredGroupedStudentListData[indexPath.section][indexPath.item]
        
        let studentImageURL: URL? = if let fullImageUri = cellData.studentImg {
            URL(string: fullImageUri)
        } else if let partImageUri = cellData.profile_pic {
            URL(string: "https://mountcarmelschool.com/uploads/profile-pic/student/\(partImageUri)")
        } else {
            nil
        }
        
        cell.onSelect = { [weak self] selected in
            guard let self = self, let studentId = cellData._id else {return}
            if selected {
                self.selectedStudentIds.insert(studentId)
            } else {
                self.selectedStudentIds.remove(studentId)
            }
            handleStudentSelect()
        }
        
        let isSelected = if let studentId = cellData._id { selectedStudentIds.contains(studentId) } else { false }
    
        cell.configure(studentImageURL: studentImageURL, studentName: cellData.name, checked: isSelected)
        
        cell.layoutIfNeeded()
        return cell
    }
}

extension StudentListViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        filterStudentsList(query: textField.text ?? "")
    }
    
    func filterStudentsList(query: String) {
        if query.isEmpty {
            self.filteredGroupedStudentListData = self.groupedStudentListData
        } else {
            let filteredList = self.studentListData.filter { studentData in
                guard let studentName = studentData.name else {
                    return false
                }
                return studentName.range(of: query, options: .caseInsensitive) != nil
            }
            self.filteredGroupedStudentListData = group(studentList: filteredList)
        }

        self.studentListCollectionView.reloadData()
    }
}
