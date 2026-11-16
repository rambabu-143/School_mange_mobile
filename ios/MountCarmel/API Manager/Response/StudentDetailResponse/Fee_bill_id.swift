//
//  FeesData.swift
//  MountCarmel
//
//  Created by Sandip on 25/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import Foundation
class Fee_bill_id : WSResponseData {
	//var variableFees : [String]?
	var _id : String?
	var strclass : String?
	var section : String?
	var admission_no : String?
	var name : String?
	var mobile_no : String?
	var status : String?
	var year_session : String?
	var carry_forward_show : Bool?
	var payment_date : String?
	var next_payment_date : String?
	var totalNextPayable : Int?
	var date : String?
	var mode : String?
	var installmentNO : String?
	var time : String?
	var installment : [InstallmentData]?
	var school_code : String?
	var fees : StudentFeesData?
	var concessionBoolean : Bool?
	var concession_type : String?
	var receivingObject : ReceivingObject?
	var totalPayable : Int?
	var student_type : String?
	var fee_type_parent_selected : Int?
	var filepath : String?
    var full_payment_received : Bool?

	enum CodingKeys: String, CodingKey {

		//case variableFees = "variableFees"
		case _id = "_id"
		case strclass = "class"
		case section = "section"
		case admission_no = "admission_no"
		case name = "name"
		case mobile_no = "mobile_no"
		case status = "status"
		case year_session = "year_session"
		case carry_forward_show = "carry_forward_show"
		case payment_date = "payment_date"
		case next_payment_date = "next_payment_date"
		case totalNextPayable = "totalNextPayable"
		case date = "date"
		case mode = "mode"
		case installmentNO = "installmentNO"
		case time = "time"
		case installment = "installment"
		case school_code = "school_code"
		case fees = "fees"
		case concessionBoolean = "concessionBoolean"
		case concession_type = "concession_type"
		case receivingObject = "receivingObject"
		case totalPayable = "totalPayable"
		case student_type = "student_type"
		case fee_type_parent_selected = "fee_type_parent_selected"
		case filepath = "filepath"
        case full_payment_received = "full_payment_received"
	}

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
		let values = try decoder.container(keyedBy: CodingKeys.self)
		//variableFees = try values.decodeIfPresent([String].self, forKey: .variableFees)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		strclass = try values.decodeIfPresent(String.self, forKey: .strclass)
		section = try values.decodeIfPresent(String.self, forKey: .section)
		admission_no = try values.decodeIfPresent(String.self, forKey: .admission_no)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		mobile_no = try values.decodeIfPresent(String.self, forKey: .mobile_no)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		year_session = try values.decodeIfPresent(String.self, forKey: .year_session)
		carry_forward_show = try values.decodeIfPresent(Bool.self, forKey: .carry_forward_show)
		payment_date = try values.decodeIfPresent(String.self, forKey: .payment_date)
		next_payment_date = try values.decodeIfPresent(String.self, forKey: .next_payment_date)
		totalNextPayable = try values.decodeIfPresent(Int.self, forKey: .totalNextPayable)
		date = try values.decodeIfPresent(String.self, forKey: .date)
		mode = try values.decodeIfPresent(String.self, forKey: .mode)
		installmentNO = try values.decodeIfPresent(String.self, forKey: .installmentNO)
		time = try values.decodeIfPresent(String.self, forKey: .time)
		installment = try values.decodeIfPresent([InstallmentData].self, forKey: .installment)
		school_code = try values.decodeIfPresent(String.self, forKey: .school_code)
        
//        if let val = try values.decodeIfPresent(StudentFeesData.self, forKey: .fees){
//            fees = val
//        }
        
        if let params = try? values.decodeIfPresent(StudentFeesData.self, forKey: .fees) {
            fees = params
        }
        
		//fees = try values.decodeIfPresent(StudentFeesData.self, forKey: .fees)
		concessionBoolean = try values.decodeIfPresent(Bool.self, forKey: .concessionBoolean)
		concession_type = try values.decodeIfPresent(String.self, forKey: .concession_type)
		//receivingObject = try values.decodeIfPresent(ReceivingObject.self, forKey: .receivingObject)
		totalPayable = try values.decodeIfPresent(Int.self, forKey: .totalPayable)
		student_type = try values.decodeIfPresent(String.self, forKey: .student_type)
		fee_type_parent_selected = try values.decodeIfPresent(Int.self, forKey: .fee_type_parent_selected)
		filepath = try values.decodeIfPresent(String.self, forKey: .filepath)
        full_payment_received = try values.decodeIfPresent(Bool.self, forKey: .full_payment_received)
	}

}
