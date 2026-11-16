//
//	LoginAPIStudent.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginAPIStudent : WSResponseData {
    
    var admissionNo : String?
    var studentId : LoginAPIStudentId?
    var yearSession : String?
    
    
    enum CodingKeys: String, CodingKey {
        case admissionNo = "admission_no"
        case studentId = "student_id"
        case yearSession = "year_session"
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        admissionNo = try values.decodeIfPresent(String.self, forKey: .admissionNo)
        studentId = try values.decodeIfPresent(LoginAPIStudentId.self, forKey: .studentId)
        yearSession = try values.decodeIfPresent(String.self, forKey: .yearSession)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(admissionNo, forKey: .admissionNo)
        try container.encode(studentId, forKey: .studentId)
        try container.encode(yearSession, forKey: .yearSession)
    }
}
