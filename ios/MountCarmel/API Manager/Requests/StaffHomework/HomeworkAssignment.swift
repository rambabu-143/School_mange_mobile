//
//  HomeworkAssignment.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 03/08/24.
//  Copyright © 2024 Mount Carmel School. All rights reserved.
//

import Foundation

struct HomeworkAssignment: Codable {
    var text: String
    var subjectId: String
    var date: String // dd-mm-yyyy
    var attachment: String?
    
    // either
    var standardSection: String? // (class + section) Id
    // OR
    var students: [String]? // Array if student Ids
    var selectedSection: String? // Note: This seems like a section Id but it is actually a (class + section) Id, same as `standardSection` key
}

extension HomeworkAssignment {
    func toDict() -> [String: Any] {
        var data: [String: Any] = [
            "text": self.text,
            "subject_id": self.subjectId,
            "date": self.date,
        ]
        if let attachment = self.attachment {
            data["attachment"] = attachment
        }
        if let standardSection = self.standardSection {
            data["standard_section"] = standardSection
        } else {
            data["students"] = self.students
            data["selected_section"] = self.selectedSection
        }
        return data
    }
}
