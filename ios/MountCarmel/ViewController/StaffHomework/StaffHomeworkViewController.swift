//
//  StaffHomeworkViewController.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 02/08/24.
//  Copyright © 2024 Mount Carmel School. All rights reserved.
//

import Foundation
import UIKit
import QuickLook
import DropDown
import MobileCoreServices

class StaffHomeworkViewController: UIViewController {
    // data
    var attachmentUploadAPIResp: AttachmentUploadAPIResponse? = nil
    var assigneeTypes = ["Whole Class", "Selected Students"]
    var classList: [StandardSectionHomeworkData] = []
    var subjectList: [SubjectListData] = []
    var studentList: [ClassStudentListData] = []
    var serverDate: String? = nil // yyyy-MM-dd
    
    var homeworkContentPlaceholderText = "Enter homework here..."

    // States
    var selectedStandardId: String? = nil
    var selectedStandardSectionId: String? = nil
    var selectedSubjectId: String? = nil
    var assigningToWholeClass: Bool? = nil {
        didSet {
            selectStudentsContainer.isHidden = assigningToWholeClass ?? true
            if assigningToWholeClass == true {
                selectedStudentsIds = []
            }
        }
    }
    var selectedStudentsIds: [String] = [] {
        didSet {
            if selectedStudentsIds.isEmpty {
                selectStudentsButton.setTitle("Select Students", for: .normal)
            } else {
                selectStudentsButton.setTitle("\(selectedStudentsIds.count) \(selectedStudentsIds.count == 1 ? "Student" : "Students")", for: .normal)
            }
        }
    }
    var homeworkDate: String? = nil // Format: dd-MM-yyyy | Note: Not the one which is displayed to user, It is sent to server on submit
    
    // UI elements
    @IBOutlet var homeworkDateLabel: UILabel!
    
    @IBOutlet var selectSubjectTextField: RoundTextField!
    @IBOutlet var selectSubjectErrorLabel: UILabel!
    
    @IBOutlet var selectClassTextField: RoundTextField!
    @IBOutlet var selectClassErrorLabel: UILabel!
    
    @IBOutlet var selectAssigneeTypeTextField: RoundTextField!
    @IBOutlet var selectAssigneeTypeErrorLabel: UILabel!
    
    @IBOutlet var selectStudentsContainer: UIStackView!
    @IBOutlet var selectStudentsButton: UIButton!
    @IBOutlet var selectStudentsErrorLabel: UILabel!
    
    @IBOutlet var homeworkContentTextView: UITextView!
    @IBOutlet var homeworkContentCharCounter: UILabel!
    @IBOutlet var homeworkContentErrorLabel: UILabel!
    
    // Mark: Upload Attachment UI Views
    @IBOutlet var uploadFileView: UIView!
    
    @IBOutlet var uploadingFileView: UIView!
    @IBOutlet var uploadingFileLabel: UILabel!
    @IBOutlet var uploadingFileProgressView: UIProgressView!
    
    @IBOutlet var uploadedFileView: UIView!
    @IBOutlet var uploadedFileLabel: UILabel!

    @IBOutlet var attachmentErrorLabel: UILabel!
    
    // Mark: Navigation UI View
    @IBOutlet weak var navigationView: NavigationBarView!
    
    var subjectDropDown = DropDown()
    var classDropDown = DropDown()
    var assigneeTypeDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeworkContentTextView.delegate = self
        navigationView.delegate = self
        navigationView.lblTitle.text = "Assign Homework"
        
        addTextViewPlaceholder()
        
        // Hide Select Students Container
        selectStudentsContainer.isHidden = true
        self.hideErrors()
        
        self.configureAttachment()
        self.configureHomeworkDate()
        self.configureClassDropdown()
        self.configureSubjectDropdown()
        self.configureAssigneeTypeDropdown()
    }
    
    func removeTextViewPlaceholder() {
        homeworkContentTextView.text = ""
        homeworkContentTextView.textColor = .black  // Set the text color to your desired color when editing
    }
    
    func addTextViewPlaceholder() {
        homeworkContentTextView.text = homeworkContentPlaceholderText
        homeworkContentTextView.textColor = .lightGray  // Set the text color back to light gray for the placeholder
    }
    
    func configureSubjectDropdown() {
        subjectDropDown.anchorView = selectSubjectTextField
        subjectDropDown.direction = .bottom
        subjectDropDown.textFont = UIFont.setRegularFont(ofSize: 13.0)
        subjectDropDown.width = selectSubjectTextField.frame.size.width
        subjectDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        
        subjectDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedSubjectId = self.subjectList.get(index: index)?._id
            self.selectSubjectTextField.text = item
            
            self.selectSubjectErrorLabel.isHidden = true
            self.selectSubjectErrorLabel.text = "Please select subject"
            self.selectClassErrorLabel.isHidden = true
            self.selectClassErrorLabel.text = "Please select class"
            
            self.subjectDropDown.hide()
        }
    }
    
    func configureAssigneeTypeDropdown() {
        assigneeTypeDropDown.anchorView = selectAssigneeTypeTextField
        assigneeTypeDropDown.direction = .bottom
        assigneeTypeDropDown.textFont = UIFont.setRegularFont(ofSize: 13.0)
        assigneeTypeDropDown.width = selectAssigneeTypeTextField.frame.size.width
        assigneeTypeDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        
        assigneeTypeDropDown.dataSource = self.assigneeTypes
        
        assigneeTypeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.assigningToWholeClass = self.assigneeTypes[index] == self.assigneeTypes[0]
            self.selectAssigneeTypeTextField.text = item
            self.selectAssigneeTypeErrorLabel.isHidden = true
            self.selectStudentsErrorLabel.isHidden = true
            self.assigneeTypeDropDown.hide()
        }
    }
    
    func configureAttachment() {
        uploadFileView.isHidden = false
        uploadingFileView.isHidden = true
        uploadedFileView.isHidden = true
    }
    
    func handleAttachmentFileSelection(fileURL: URL) {
        // Show Uploading View, hide others
        uploadFileView.isHidden = true
        uploadingFileView.isHidden = false
        uploadedFileView.isHidden = true
        
        attachmentErrorLabel.isHidden = true
        
        uploadingFileLabel.text = "Uploading \(fileURL.lastPathComponent)"
        uploadingFileProgressView.progress = 0.0
        
        callAPIAttachmentUpload(
            fileURL: fileURL,
            uploadProgressHandler: { [weak self] progress in
                if let self = self  {
                    self.uploadingFileProgressView.progress = Float(progress.fractionCompleted)
                }
            }
        ) { [weak self] success, responseData, error in
            guard let self = self else {return}
            if (success) {
                self.attachmentUploadAPIResp = responseData

                // Show Uploaded View, hide others
                self.uploadFileView.isHidden = true
                self.uploadingFileView.isHidden = true
                self.uploadedFileView.isHidden = false
                
                self.uploadedFileLabel.text = responseData?.originalname ?? responseData?.file_name ?? ""
            } else {
                // Show Upload View, hide all others
                self.uploadFileView.isHidden = false
                self.uploadingFileView.isHidden = true
                self.uploadedFileView.isHidden = true
                
                if let error = error {
                    self.attachmentErrorLabel.isHidden = false
                    self.attachmentErrorLabel.text = error.localizedDescription
                }
            }
        }
    }

    func configureClassDropdown() {
        classDropDown.anchorView = selectClassTextField
        classDropDown.direction = .bottom
        classDropDown.textFont = UIFont.setRegularFont(ofSize: 13.0)
        classDropDown.width = selectClassTextField.frame.size.width
        classDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        
        classDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.classDropDown.hide()
            
            // Reset selected subject, selected students, subjectList and studentList
            self.selectClassErrorLabel.isHidden = true // Hide class selection error if visible
            self.selectSubjectErrorLabel.isHidden = true // Hide subject selection error if visible
            self.selectedSubjectId = nil
            self.selectSubjectTextField.text = ""
            self.selectedStudentsIds = []
            self.subjectList = [SubjectListData]()
            self.studentList = [ClassStudentListData]()

            // Set Standard Id and StandardSection Id
            self.selectClassTextField.text = item
            
            if let standardSectionData = self.classList.get(index: index) {
                self.selectedStandardId = standardSectionData.standard_id?._id
                self.selectedStandardSectionId = standardSectionData._id
                
                // Fetch new subject list and students list
                self.fetchSubjectsList()
                self.fetchStudentsList()
            }
        }
        
        fetchStandardSectionList()
    }
    
    func configureHomeworkDate() {
        let currentDate = Date()
        
        let ddMmYyyyFormatter = DateFormatter()
        ddMmYyyyFormatter.dateFormat = "dd-MM-yyyy"
        
        let labelTextDateFormatter = DateFormatter()
        labelTextDateFormatter.dateFormat = "dd MMM, yyyy"
        
        // Convert the current date to a string with the desired format
        self.homeworkDate = ddMmYyyyFormatter.string(from: currentDate)
        self.homeworkDateLabel.text = labelTextDateFormatter.string(from: currentDate)

        self.callAPIServerTime() { [weak self] success, responseData in
            guard let self = self else {return}
            if (success) {
                
                if let homeworkDate = responseData?.today_date {
                    self.serverDate = homeworkDate

                    // Create a DateFormatter for the input string
                    let inputDateFormatter = DateFormatter()
                    inputDateFormatter.dateFormat = DateFormat.DateFormat_yyyyMMdd

                    // Convert the input string to a Date object
                    if let date = inputDateFormatter.date(from: homeworkDate) {

                        // Convert the current date to a string with the desired format
                        self.homeworkDate = ddMmYyyyFormatter.string(from: date)
                        self.homeworkDateLabel.text = labelTextDateFormatter.string(from: date)
                    } else {
                        print("Received Invalid date format for `today_date` field!")
                    }
                }
            }
        }
    }
    
    func hideErrors() {
        self.selectClassErrorLabel.isHidden = true
        self.selectSubjectErrorLabel.isHidden = true
        self.selectStudentsErrorLabel.isHidden = true
        self.homeworkContentErrorLabel.isHidden = true
        self.selectAssigneeTypeErrorLabel.isHidden = true
        self.attachmentErrorLabel.isHidden = true
    }
    
    func resetForm() {
        // Reset attachment view
        self.resetAttachmentUI()
        
        // Reset homework content
        addTextViewPlaceholder()
        
        // Reset class
        self.selectClassTextField.text = ""
        self.selectedStandardId = nil
        self.selectedStandardSectionId = nil
        self.classDropDown.clearSelection()
        
        // Reset subject
        self.selectSubjectTextField.text = ""
        self.selectedSubjectId = nil
        self.subjectList = [SubjectListData]()
        
        // Reset assigning type
        self.selectAssigneeTypeTextField.text = ""
        self.assigningToWholeClass = nil
        self.selectedStudentsIds = [String]()
        self.assigneeTypeDropDown.clearSelection()
        
        // Reset student list
        self.studentList = [ClassStudentListData]()
    }
    
    func presentBottomSheet(viewController: UIViewController, onCompletion: (() -> Void)? = nil) {
        viewController.modalPresentationStyle = .pageSheet
        present(viewController, animated: true, completion: onCompletion)
    }
    
    func fetchStandardSectionList() {
        self.callAPIStandardSectionList { [weak self] success, responseData in
            if (success) {
                guard let self = self else {return}
                let classList = responseData?.data ?? [StandardSectionHomeworkData]()
                let classListNames = classList.map{ standard in
                    return "\(standard.standard ?? "") \(standard.section ?? "")"
                }
                self.classList = classList
                self.classDropDown.dataSource = classListNames
                if classList.isEmpty {
                    self.toast("No Standard or Class is assigned to you. Please contact admin!")
                }
            }
        }
    }
    
    func fetchSubjectsList() {
        self.callAPISubjectList { [weak self] success, responseData in
            if (success) {
                guard let self = self else {return}
                let subjects = responseData?.data ?? [SubjectListData]()
                let subjectsNames = subjects.map{ subject in
                    return subject.subject_name ?? ""
                }
                self.subjectList = subjects
                self.subjectDropDown.dataSource = subjectsNames
                if subjects.isEmpty {
                    self.toast("No Subjects found!")
                }
            }
        }
    }
    
    func fetchStudentsList() {
        self.callAPIStudentList { [weak self] success, responseData in
            if (success) {
                guard let self = self else {
                    return
                }
                let students = responseData?.data ?? [ClassStudentListData]()
                let sortedStudents = students.sorted { ($0.name ?? "") < ($1.name ?? "") }
                self.studentList = sortedStudents
            }
        }
    }
    
    func showClassError() {
        selectClassErrorLabel.isHidden = false
        selectClassErrorLabel.text = "Please select class"
        
        selectSubjectErrorLabel.isHidden = false
        selectSubjectErrorLabel.text = ""
    }
    
    func showSubjectError() {
        selectClassErrorLabel.isHidden = false
        selectClassErrorLabel.text = ""
        
        selectSubjectErrorLabel.isHidden = false
        selectSubjectErrorLabel.text = "Please select subject"
    }

    @IBAction func actionSelectClass(_ sender: Any) {
        classDropDown.show()
    }
    
    @IBAction func actionSelectSubject(_ sender: Any) {
        if self.selectedStandardId == nil || self.selectedStandardSectionId == nil {
            showClassError()
        } else {
            subjectDropDown.show()
        }
    }
    
    @IBAction func actionSelectFileToUpload(_ sender: UIButton) {
        presentDocumentPicker()
    }

    @IBAction func actionSelectPhotoToUpload(_ sender: UIButton) {
        presentImagePicker()
    }
    
    @IBAction func actionSelectAssigneeType(_ sender: UIButton) {
        if self.selectedStandardId == nil || self.selectedStandardSectionId == nil {
            showClassError()
        } else {
            assigneeTypeDropDown.show()
        }
    }
    
    func resetAttachmentUI() {
        // Show Upload View, hide all others
        self.uploadFileView.isHidden = false
        self.uploadingFileView.isHidden = true
        self.uploadedFileView.isHidden = true
        
        self.attachmentErrorLabel.isHidden = true
        
        self.attachmentUploadAPIResp = nil
    }

    @IBAction func actionRemoveUploadedFile(_ sender: UIButton) {
        resetAttachmentUI()
    }
    
    @IBAction func actionSelectStudents(_ sender: UIButton) {
        guard let studentListViewController: StudentListViewController = StudentListViewController.storyboardInstance.initialize() else {
            return
        }
        selectStudentsErrorLabel.isHidden = true
        if let selectedClassLabel = selectClassTextField.text {
            studentListViewController.setupData(
                classLabel: selectedClassLabel,
                studentList: self.studentList,
                selectedStudentIds: self.selectedStudentsIds
            )
            
            // Define the closure to receive the selected data
            studentListViewController.onSelectionDone = { [weak self] selectedStudentsIds in
                self?.selectedStudentsIds = selectedStudentsIds
            }
        }
        presentBottomSheet(viewController: studentListViewController)
    }
    
    @IBAction func actionAssignHomework(_ sender: UIButton) {
        guard let homeworkDate = self.homeworkDate else {
            toast("Homework Date is not available. Please contact admin about this error!")
            return
        }
        guard let standardSectionId = self.selectedStandardSectionId else {
            showClassError()
            return
        }
        guard let subjectId = self.selectedSubjectId else {
            showSubjectError()
            return
        }
        guard let assigningToWholeClass = self.assigningToWholeClass else {
            selectAssigneeTypeErrorLabel.isHidden = false
            return
        }
        if !assigningToWholeClass && selectedStudentsIds.isEmpty {
            selectStudentsErrorLabel.isHidden = false
            return
        }
        guard let homeworkContent = self.homeworkContentTextView.text, !homeworkContent.isEmpty, homeworkContent != homeworkContentPlaceholderText else {
            homeworkContentErrorLabel.text = "Please enter contents of homework"
            homeworkContentErrorLabel.isHidden = false
            return
        }
        
        let attachmentName = self.attachmentUploadAPIResp?.file_name
        
        let alert = UIAlertController(
            title: "Are you sure you want to continue?",
            message: attachmentName != nil ? nil : "You also haven't attached any file with homework",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [weak self] action in
            guard let self = self else {
                print("`self` is nil!")
                return
            }
            let homework = if assigningToWholeClass {
                HomeworkAssignment(
                    text: homeworkContent,
                    subjectId: subjectId,
                    date: homeworkDate,
                    attachment: attachmentName, // name on server
                    standardSection: standardSectionId
                )
            } else {
                HomeworkAssignment(
                    text: homeworkContent,
                    subjectId: subjectId,
                    date: homeworkDate,
                    attachment: attachmentName, // name on server
                    students: self.selectedStudentsIds,
                    selectedSection: standardSectionId
                )
            }
            self.callAPIAssignHomework(homeworkAssignment: homework) { [weak self] success, response, errorStr in
                if success {
                    self?.toastwithColor(
                        "Homework assigned successfully",
                        UIColor(red: 212.0/255.0, green: 248.0/255.0, blue: 212.0/255.0, alpha: 1.0),
                        3.0
                    )
                    self?.resetForm()
                } else {
                    self?.toastwithColor(
                        errorStr ?? "Something went wrong!",
                        UIColor(red: 1.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0),
                        4.0
                    )
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}

// Adding API functions
extension StaffHomeworkViewController {
    // API CALL FOR GETTING CLASS LIST
    func callAPIStandardSectionList(finished: @escaping(_ success: Bool, _ response: StandardSectionAPIResponse?) -> Void) {
        Loader.show()
        StaffManageMentAPI.getClassListForAssigningHomework { response, error in
            Loader.hide()
            guard let response = response else {
                finished(false, nil)
                return
            }
            guard response.status == true else {
                self.toast(response.message ?? "")
                finished(false, nil)
                return
            }
            guard let _ = response.message else {
                finished(false, nil)
                return
            }
            finished(true, response)
        }
    }
    
    // API CALL FOR GETTING SUBJECT LIST
    func callAPISubjectList(finished: @escaping(_ success: Bool, _ response: SubjectListAPIResponse?) -> Void) {
        guard let standardId = self.selectedStandardId else {
            self.toast("Please select standard")
            return
        }
        guard let standardSectionId = self.selectedStandardSectionId else {
            self.toast("Please select standard section")
            return
        }
        Loader.show()
        StaffManageMentAPI.getSubjectListForAssigningHomework(
            standardId: standardId,
            standardSectionId: standardSectionId
        ) { response, error in
//            Loader.hide() // Loader will be hidden when students list api is resolved
            guard let response = response else {
                finished(false, nil)
                return
            }
            guard response.status == true else {
                self.toast(response.message ?? "")
                finished(false, nil)
                return
            }
            guard let _ = response.message else {
                finished(false, nil)
                return
            }
            finished(true, response)
        }
    }
    
    // API CALL FOR GETTING STUDENT LIST
    func callAPIStudentList(finished: @escaping(_ success: Bool, _ response: ClassStudentListAPIResponse?) -> Void) {
        guard let standardSectionId = self.selectedStandardSectionId else {
            self.toast("Please select standard section")
            return
        }
        Loader.show()
        StaffManageMentAPI.getStudentListForAssigningHomework(
            standardSectionId: standardSectionId
        ) { response, error in
            Loader.hide()
            guard let response = response else {
                finished(false, nil)
                return
            }
            guard response.status == true else {
                self.toast(response.message ?? "")
                finished(false, nil)
                return
            }
            guard let _ = response.message else {
                finished(false, nil)
                return
            }
            finished(true, response)
        }
    }
    
    // API CALL FOR UPLOADING ASSIGNMENT FILE
    func callAPIAttachmentUpload(
        fileURL: URL,
        uploadProgressHandler: @escaping (_ progress: Progress) -> Void,
        finished: @escaping(_ success: Bool, _ response: AttachmentUploadAPIResponse?, _ error: Error?) -> Void
    ) {
        Loader.show()
        StaffManageMentAPI.uploadAssignmentFile(
            assignmentFileURL: fileURL,
            uploadProgressHandler: uploadProgressHandler
        ) { response, error in
            Loader.hide()
            guard let response = response else {
                print("uploadAssignmentFile error: \(String(describing: error))")
                finished(false, nil, error)
                return
            }
            guard response.status == true else {
                self.toast(response.message ?? "")
                finished(false, nil, error)
                return
            }
            guard let _ = response.message else {
                finished(false, nil, error)
                return
            }
            finished(true, response, nil)
        }
    }
    
    // API CALL FOR SUBMITTING HOMEWORK
    func callAPIAssignHomework(
        homeworkAssignment: HomeworkAssignment,
        finished: @escaping(_ success: Bool, _ response: AssignHomeworkAPIResponse?, _ errorStr: String?) -> Void
    ) {
        Loader.show()
        StaffManageMentAPI.assignHomework(data: homeworkAssignment) { response, error in
            Loader.hide()
            guard let response = response else {
                finished(false, nil, error.debugDescription)
                return
            }
            guard response.status == true else {
                self.toast(response.message ?? "")
                finished(false, nil, response.message)
                return
            }
            guard let _ = response.message else {
                finished(false, nil, "Unable to assign homework. Please try again!")
                return
            }
            finished(true, response, nil)
        }
    }
    
    // API CALL FOR GETTING SERVER REAL TIME
    func callAPIServerTime(finished: @escaping(_ success: Bool, _ response: RealTimeAPIResponse?) -> Void) {
        Loader.show()
        StaffManageMentAPI.getRealTime() { response, error in
            Loader.hide()
            guard let response = response else {
                finished(false, nil)
                return
            }
            guard response.status == true else {
                self.toast(response.message ?? "")
                finished(false, nil)
                return
            }
            guard let _ = response.message else {
                finished(false, nil)
                return
            }
            finished(true, response)
        }
    }
}

// Managing Input Fields or Text Views
extension StaffHomeworkViewController: UITextViewDelegate {
    static var HOMEWORK_CONTENT_CHAR_LIMIT = 300
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == homeworkContentPlaceholderText {
            removeTextViewPlaceholder()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            addTextViewPlaceholder()
        }
    }

    // Limiting characters in Homework Content Text Field
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }

        let newLength = currentText.count + text.count - range.length
        if newLength > StaffHomeworkViewController.HOMEWORK_CONTENT_CHAR_LIMIT {
            // Calculate the number of characters that can be added
            let allowedLength = StaffHomeworkViewController.HOMEWORK_CONTENT_CHAR_LIMIT - currentText.count + range.length
            if allowedLength > 0 {

                // If there's a selection, calculate the length of the selected range
//                let selectedCharsCount = if !currentText.isEmpty, let str = textField.selectedTextRange {
//                    let selectedText = currentText[0..<str.start]
//                    let selectedLength = selectedText.count
//                    
//                    textField.offset(from: str.start, to: str.end)
//                } else {0}
                let selectedCharsCount = 0
                
                // Truncate the replacement string to the allowed length
                let limitedString = String(text.prefix(allowedLength))
                let updatedText = currentText.replacingCharacters(in: stringRange, with: limitedString)
                textView.text = updatedText
                
                // Move the caret to the end of the new text
                DispatchQueue.main.async {
                    if let str = textView.selectedTextRange {
                        if let newPosition = textView.position(
                            from: str.end,
                            offset: str.isEmpty ? limitedString.count : limitedString.count - selectedCharsCount
                        ) {
                            textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
                        }
                    }
                }
            }
            return false
        }
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if let content = textView.text {
            if !content.isEmpty && !homeworkContentErrorLabel.isHidden {
                homeworkContentErrorLabel.isHidden = true
            }
            if content == homeworkContentPlaceholderText {
                homeworkContentCharCounter.text = "\(0)/\(StaffHomeworkViewController.HOMEWORK_CONTENT_CHAR_LIMIT)"
            } else {
                homeworkContentCharCounter.text = "\(content.count)/\(StaffHomeworkViewController.HOMEWORK_CONTENT_CHAR_LIMIT)"
            }
        }
    }
}

// Managing Image Picker
extension StaffHomeworkViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        imagePickerController.mediaTypes = ["public.image"]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        let imageName = UUID().uuidString + ".jpg"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            do {
                try jpegData.write(to: tempURL)
                handleAttachmentFileSelection(fileURL: tempURL)
            } catch {
                attachmentErrorLabel.isHidden = false
                attachmentErrorLabel.text = error.localizedDescription
                print("Error saving image to temporary location: \(error)")
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// Managing Document Picker
extension StaffHomeworkViewController: UIDocumentPickerDelegate {
    static var MAX_FILE_SIZE_IN_MB: Double = 2.0 // Maximum file size allowed (2MB)

    func presentDocumentPicker() {
        let documentPickerController = if #available(iOS 14.0, *) {
             UIDocumentPickerViewController(
                forOpeningContentTypes: [
                    // Documents
                    .pdf,
                    .rtf,
                    .plainText,                                                           // .txt
                    .spreadsheet,                                                         // .spreadsheet
                    .presentation,                                                        // .presentation
                    UTType(importedAs: "public.comma-separated-values-text"),             // .csv
                    UTType(importedAs: "net.daringfireball.markdown"),                    // .md
                    UTType(importedAs: "org.openxmlformats.wordprocessingml.document"),   // .docx
                    UTType(importedAs: "com.microsoft.word.doc"),                         // .doc
                    UTType(importedAs: "org.openxmlformats.spreadsheetml.sheet"),         // .xlsx
                    UTType(importedAs: "com.microsoft.excel.xls"),                        // .xls
                    UTType(importedAs: "org.openxmlformats.presentationml.presentation"), // .pptx
                    UTType(importedAs: "com.microsoft.powerpoint.ppt"),                   // .ppt
                    // Images
                    .jpeg,
                    .png,
                ],
                asCopy: true
            )
        } else {
            UIDocumentPickerViewController(
                documentTypes: [
                    kUTTypePDF as String,                            // .pdf
                    kUTTypeRTF as String,                            // .rtf
                    kUTTypePlainText as String,                      // .txt
                    kUTTypeSpreadsheet as String,                    // .spreadsheet
                    kUTTypePresentation as String,                   // .presentation
                    "public.comma-separated-values-text",            // .csv
                    "net.daringfireball.markdown",                   // .md (custom UTI for Markdown)
                    "org.openxmlformats.wordprocessingml.document",  // .docx (custom UTI for modern Word documents)
                    "com.microsoft.word.doc",                        // .doc (custom UTI for legacy Word documents)
                    "org.openxmlformats.spreadsheetml.sheet",        // .xlsx (custom UTI for modern Excel documents)
                    "com.microsoft.excel.xls",                       // .xls (custom UTI for legacy Excel documents)
                    "org.openxmlformats.presentationml.presentation",// .pptx (custom UTI for modern PowerPoint presentations)
                    "com.microsoft.powerpoint.ppt",                  // .ppt (custom UTI for legacy PowerPoint presentations)
                    kUTTypeJPEG as String,                           // .jpeg
                    kUTTypePNG as String                             // .png
                ],
                in: .import
            )
        }
        documentPickerController.delegate = self
        documentPickerController.allowsMultipleSelection = false
        present(documentPickerController, animated: true, completion: nil)
    }

    // MARK: - UIDocumentPickerDelegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // Use the selected file URL
        guard let selectedFileURL = urls.first else { return }
        
        // Start accessing the security-scoped resource
        let didStartAccessing = selectedFileURL.startAccessingSecurityScopedResource()
        
        defer {
            if didStartAccessing {
                selectedFileURL.stopAccessingSecurityScopedResource()
            }
        }
        
        do {
            // Get file attributes to determine file size
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: selectedFileURL.path)
            
            if let fileSize = fileAttributes[.size] as? Int64 {
                let fileSizeInMB = Double(fileSize) / (1024.0 * 1024.0)
                
                // Check if file size exceeds the limit
                if fileSizeInMB > StaffHomeworkViewController.MAX_FILE_SIZE_IN_MB {
                    self.attachmentErrorLabel.isHidden = false
                    self.attachmentErrorLabel.text = "File is too large. Maximum file size is \(StaffHomeworkViewController.MAX_FILE_SIZE_IN_MB) MB."
                } else {
                    // Call the upload function with the selected file URL
                    handleAttachmentFileSelection(fileURL: selectedFileURL)
                }
            }
        } catch {
            print("Failed to get file attributes: \(error.localizedDescription)")
            self.attachmentErrorLabel.isHidden = false
            self.attachmentErrorLabel.text = "Failed to get size of file. Try again!"
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// Managing Navigation bar
extension StaffHomeworkViewController: NavigationBarViewDelegate {
    func onTapMenu() {}
    
    func onTapBack() {
        guard let navigationController = self.navigationController else {return}

        if navigationController.viewControllers.count == 1 {
            self.setHomeScreen()
        } else {
            navigationController.popViewController(animated: true)
        }
    }
    
    func onTapNotification() {
        if let viewController: NotificationViewController = NotificationViewController.storyboardInstance.initialize() {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func onTapBadgeCounts() {
        if let viewController: NotificationViewController = NotificationViewController.storyboardInstance.initialize() {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func onTapAppLogo() {
        let viewcontrollers = self.navigationController?.viewControllers
        var flag = true
        viewcontrollers?.forEach({ (vc) in
            if  let viewController = vc as? HomeViewController {
                flag = false
                self.navigationController!.popToViewController(viewController, animated: true)
            }
        })
        
        if flag {
            self.setHomeScreen()
        }
    }
    
    func onTapDropDown() {}
    
    func onTapStory() {}

    func setHomeScreen() {
        if let viewController: HomeViewController = HomeViewController.storyboardInstance.initialize() {
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
        }
    }
}
