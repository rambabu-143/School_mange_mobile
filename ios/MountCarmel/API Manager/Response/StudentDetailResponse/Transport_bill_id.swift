

import UIKit

class Transport_bill_id : WSResponseData {
	var id : String?
	var order : Int?
	var strclass : String?
	var section : String?
	var pendingTransport : Int?
	var admission_no : String?
	var name : String?
	var transport_entryId : String?
	var status : String?
	var t_carry_forward_show : Bool?
	var session : String?
	var year_session : String?
	var date : String?
	var time : String?
	var school_code : String?
	var installmentNO : String?
	var transportAry : [TransportAry]?
	var transport_total_amt : Int?
	var busSecurity : String?
	//var busSecurityAmt : Int?
	var payable : Int?
	var installment : [InstallmentData]?
	var allInstFine : Int?
	var filepath : String?
	var standard_id : String?
	var section_id : String?
    var full_payment_received : Bool?

	enum CodingKeys: String, CodingKey {

		case _id = "_id"
		case order = "order"
		case strclass = "class"
		case section = "section"
		case pendingTransport = "pendingTransport"
		case admission_no = "admission_no"
		case name = "name"
		case transport_entryId = "transport_entryId"
		case status = "status"
		case t_carry_forward_show = "t_carry_forward_show"
		case session = "session"
		case year_session = "year_session"
		case date = "date"
		case time = "time"
		case school_code = "school_code"
		case installmentNO = "installmentNO"
		case transportAry = "transportAry"
		case transport_total_amt = "transport_total_amt"
		case busSecurity = "busSecurity"
		//case busSecurityAmt = "busSecurityAmt"
		case payable = "payable"
		case installment = "installment"
		case allInstFine = "allInstFine"
		case filepath = "filepath"
		case standard_id = "standard_id"
		case section_id = "section_id"
        case full_payment_received = "full_payment_received"
	}

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
        
		id = try values.decodeIfPresent(String.self, forKey: ._id)
		order = try values.decodeIfPresent(Int.self, forKey: .order)
		strclass = try values.decodeIfPresent(String.self, forKey: .strclass)
		section = try values.decodeIfPresent(String.self, forKey: .section)
		pendingTransport = try values.decodeIfPresent(Int.self, forKey: .pendingTransport)
		admission_no = try values.decodeIfPresent(String.self, forKey: .admission_no)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		transport_entryId = try values.decodeIfPresent(String.self, forKey: .transport_entryId)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		t_carry_forward_show = try values.decodeIfPresent(Bool.self, forKey: .t_carry_forward_show)
		session = try values.decodeIfPresent(String.self, forKey: .session)
		year_session = try values.decodeIfPresent(String.self, forKey: .year_session)
		date = try values.decodeIfPresent(String.self, forKey: .date)
		time = try values.decodeIfPresent(String.self, forKey: .time)
		school_code = try values.decodeIfPresent(String.self, forKey: .school_code)
		installmentNO = try values.decodeIfPresent(String.self, forKey: .installmentNO)
		transportAry = try values.decodeIfPresent([TransportAry].self, forKey: .transportAry)
		transport_total_amt = try values.decodeIfPresent(Int.self, forKey: .transport_total_amt)
		busSecurity = try values.decodeIfPresent(String.self, forKey: .busSecurity)
        //busSecurityAmt = try values.decodeIfPresent(Int.self, forKey: .busSecurityAmt)
		payable = try values.decodeIfPresent(Int.self, forKey: .payable)
		installment = try values.decodeIfPresent([InstallmentData].self, forKey: .installment)
		allInstFine = try values.decodeIfPresent(Int.self, forKey: .allInstFine)
		filepath = try values.decodeIfPresent(String.self, forKey: .filepath)
		standard_id = try values.decodeIfPresent(String.self, forKey: .standard_id)
		section_id = try values.decodeIfPresent(String.self, forKey: .section_id)
        full_payment_received = try values.decodeIfPresent(Bool.self, forKey: .full_payment_received)
	}

}


class StaffYearsModal : WSResponseData {
    var branch_code : Int?
    var employee_code : String?
    var is_teacher : Bool?
    var staff_type : String?
    var year_session : String?
    var schools : [StaffSchoolsModal]?
    
    enum CodingKeys: String, CodingKey {
        case branch_code = "branch_code"
        case employee_code = "employee_code"
        case is_teacher = "is_teacher"
        case staff_type = "staff_type"
        case year_session = "year_session"
        case  schools = "schools"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        branch_code = try values.decodeIfPresent(Int.self, forKey: .branch_code)
        employee_code = try values.decodeIfPresent(String.self, forKey: .employee_code)
        is_teacher = try values.decodeIfPresent(Bool.self, forKey: .is_teacher)
        staff_type = try values.decodeIfPresent(String.self, forKey: .staff_type)
        year_session = try values.decodeIfPresent(String.self, forKey: .year_session)
        schools = try values.decodeIfPresent([StaffSchoolsModal].self, forKey: .schools)

    }
}

class StaffSchoolsModal : WSResponseData {
    var branch_code : Int?
    var group : String?
    var is_access : Bool?
    var school_code : String?
    
    enum CodingKeys: String, CodingKey {
        case branch_code = "branch_code"
        case group = "group"
        case is_access = "is_access"
        case school_code = "school_code"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        branch_code = try values.decodeIfPresent(Int.self, forKey: .branch_code)
        group = try values.decodeIfPresent(String.self, forKey: .group)
        is_access = try values.decodeIfPresent(Bool.self, forKey: .is_access)
        school_code = try values.decodeIfPresent(String.self, forKey: .school_code)

    }

}
