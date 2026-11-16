//
//  StudentDetailData.swift
//  MountCarmel
//
//  Created by Sandip on 25/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class StudentDetailData: WSResponseData {
    var medical : MedicalData?
    var achievement : AchivementData?
   // var special_needs : Special_needs?
    var fee_type : Int?
    var temp_installment : String?
    var fee_type_parent_selected : Int?
    var fee_bill_me : Bool?
    var account_entry : String?
    var arrear_fee : Int?
    var arrear_transport : Int?
    var arrear_hostel : Int?
    var is_hostel : Bool?
    var is_transport : Bool?
    var transport_type : String?
    var is_concession : Bool?
    var is_detain : Bool?
    var transport_renewal : Bool?
    var stream_selection : Bool?
    var receipt_auto_gen : Bool?
    var transport_auto_gen : Bool?
    var hostel_auto_gen : Bool?
    var is_deleted : Bool?
    var _id : String?
    var addmission : String?
    var adharcard : String?
    var admission_no : String?
    var br_code : String?
    var branchCode : String?
    var category : String?
    var strclass : String?
    var combo : [ComboData]?
    var country : String?
    var dateofadmissions : String?
    var dateofjoinings : String?
    var dateofleaving : String?
    var details : String?
    var email_personal : String?
    //var fees : FeesTypeData?
    var gaurdianName : String?
    var gaurdianphone : String?
    var hostel_yes : String?
    var house : String?
    var migration : Bool?
    var mothertongue : String?
    var old_admission_no : String?
   // var prefect : String?
    var prev_admission_no : String?
    var relation : [Relation]?
    var remarks : String?
    var residentialaddress : String?
    var sch_code : String?
    var school_transport : String?
    var section : String?
    var section_id : LoginAPIDepartmentId?
    var serial_no : Int?
    var sex : String?
    var st_dob : String?
    var state : String?
    var student_city : String?
    var student_email : String?
    var student_mobile : String?
    var student_pinno : String?
    var student_telephone : String?
    var studentImg : String?
    var studentname : String?
    var studentstatus : String?
    var sub_br_code : String?
    var transport : Transport?
    var upgraded : Bool?
    //var variableFees : [String]?
    var yearsession : String?
    var carry_forward_show : Bool?
    var t_bill_forward : Bool?
    var t_carry_forward_show : Bool?
    var temp : Bool?
    var parentRelation : String?
    var accountEntry : String?
    var currentClass : String?
    var currentSection : String?
    var currentCombo : String?
    var studentCombo : String?
    var detained : String?
    var reg_board : String?
    var securityAmount : String?
    var transWithdrawalDate : String?
    var prev_section : String?
    var refundedSecurity : String?
    var concession : [Concession]?
    var othercountrynew : String?
    var othercountry : String?
    var nationality : String?
    var othernationalitynew : String?
    var othernationality : String?
    var feebillurl : String?
    var feegeneratedon : String?
    var aadhar_card : String?
    var acount_entry : String?
    var address : [Address]?
    var admission_standard : LoginAPIDepartmentId??
    var branch_code : Int?
    var category_id : Category_id?
    var cbse_reg_no : String?
    var date_of_admission : String?
    var date_of_birth : String?
    var date_of_joining : String?
    var date_of_withdrawal : String?
    var email : String?
    var gender : String?
    var house_id : LoginAPIHouseTeacherID?
    var mother_tongue_id : LoginAPIDepartmentId?
    var name : String?
    var profile_pic : String?
    var recordUpdateNew : Bool?
    var school_code : String?
    var siblings : [Siblings]?
    var sms_mobile : String?
    var social_media_consent : SocialMediaConsent?
    var standard_id : LoginAPIDepartmentId?
    var standard_section_id : String?
    var student_type : String?
    var year_session : String?
    var old_record : Bool?
    var studentType_update : Bool?
    var full_payment_received : Bool?
    var fee_bill_id : Fee_bill_id?
    var hostel_bill_id : Fee_bill_id?
    var hostel_bill_url : String?
    var account_created : Bool?
    var update_stan_section : Bool?
    var standard_teacher_id : String?
    var combo_id : Combo_id?
    var fee_receipt : String?
    
    var fee_receipt_generatedon : String?
    var recordUpdateNewNew : Bool?
    var final_update : Bool?
    var school_type : String?
    var final_update_new : Bool?
    var final_updated : Bool?
    var final_updatedd : Bool?
    var year_branch : Int?
    var admission_date_update : Bool?
    var refundable_updated : String?
    var __v : Int?
    var combo_history : [String]?
    var created_at : String?
    var fee : [String]?
    var updated_at : String?
    var fee_type_history : [String]?
    var ticker : [String]?
    var is_bill_type_updated : Bool?
    var transport_bill_id: Transport_BillData?
    var assessment_record : String?
    var assessment_accssible : Bool?
   
    
    enum CodingKeys: String, CodingKey {
        
        case medical = "medical"
        case achievement = "achievement"
        //case special_needs = "special_needs"
        case fee_type = "fee_type"
        case temp_installment = "temp_installment"
        case fee_type_parent_selected = "fee_type_parent_selected"
        case fee_bill_me = "fee_bill_me"
        case account_entry = "account_entry"
        case arrear_fee = "arrear_fee"
        case arrear_transport = "arrear_transport"
        case arrear_hostel = "arrear_hostel"
        case is_hostel = "is_hostel"
        case is_transport = "is_transport"
        case transport_type = "transport_type"
        case is_concession = "is_concession"
        case is_detain = "is_detain"
        case transport_renewal = "transport_renewal"
        case stream_selection = "stream_selection"
        case receipt_auto_gen = "receipt_auto_gen"
        case transport_auto_gen = "transport_auto_gen"
        case hostel_auto_gen = "hostel_auto_gen"
        case is_deleted = "is_deleted"
        case _id = "_id"
        case addmission = "addmission"
        case adharcard = "adharcard"
        case admission_no = "admission_no"
        case br_code = "br_code"
        case branchCode = "branchCode"
        case category = "Category"
        case strclass = "class"
        case combo = "combo"
        case country = "country"
        case dateofadmissions = "dateofadmissions"
        case dateofjoinings = "dateofjoinings"
        case dateofleaving = "dateofleaving"
        case details = "details"
        case email_personal = "email_personal"
        //case fees = "fees"
        case gaurdianName = "gaurdianName"
        case gaurdianphone = "gaurdianphone"
        case hostel_yes = "hostel_yes"
        case house = "house"
        case migration = "migration"
        case mothertongue = "mothertongue"
        case old_admission_no = "old_admission_no"
       // case prefect = "prefect"
        case prev_admission_no = "prev_admission_no"
        case relation = "relation"
        case remarks = "remarks"
        case residentialaddress = "residentialaddress"
        case sch_code = "sch_code"
        case school_transport = "school_transport"
        case section = "section"
        case section_id = "section_id"
        case serial_no = "serial_no"
        case sex = "Sex"
        case st_dob = "st_dob"
        case state = "state"
        case student_city = "student_city"
        case student_email = "student_email"
        case student_mobile = "student_mobile"
        case student_pinno = "student_pinno"
        case student_telephone = "student_telephone"
        case studentImg = "studentImg"
        case studentname = "studentname"
        case studentstatus = "studentstatus"
        case sub_br_code = "sub_br_code"
        case transport = "transport"
        case upgraded = "upgraded"
       // case variableFees = "variableFees"
        case yearsession = "yearsession"
        case carry_forward_show = "carry_forward_show"
        case t_bill_forward = "t_bill_forward"
        case t_carry_forward_show = "t_carry_forward_show"
        case temp = "temp"
        case parentRelation = "parentRelation"
        case accountEntry = "accountEntry"
        case currentClass = "currentClass"
        case currentSection = "currentSection"
        case currentCombo = "currentCombo"
        case studentCombo = "studentCombo"
        case detained = "detained"
        case reg_board = "reg_board"
        case securityAmount = "securityAmount"
        case transWithdrawalDate = "transWithdrawalDate"
        case prev_section = "prev_section"
        case refundedSecurity = "refundedSecurity"
        case concession = "concession"
        case othercountrynew = "othercountry-new"
        case othercountry = "othercountry"
        case nationality = "nationality"
        case othernationalitynew = "othernationality-new"
        case othernationality = "othernationality"
        case feebillurl = "feebillurl"
        case feegeneratedon = "feegeneratedon"
        case aadhar_card = "aadhar_card"
        case acount_entry = "acount_entry"
        case address = "address"
        case admission_standard = "admission_standard"
        case branch_code = "branch_code"
        case category_id = "category_id"
        case cbse_reg_no = "cbse_reg_no"
        case date_of_admission = "date_of_admission"
        case date_of_birth = "date_of_birth"
        case date_of_joining = "date_of_joining"
        case date_of_withdrawal = "date_of_withdrawal"
        case email = "email"
        case gender = "gender"
        case house_id = "house_id"
        case mother_tongue_id = "mother_tongue_id"
        case name = "name"
        case profile_pic = "profile_pic"
        case recordUpdateNew = "recordUpdateNew"
        case school_code = "school_code"
        case siblings = "siblings"
        case sms_mobile = "sms_mobile"
        case standard_id = "standard_id"
        case standard_section_id = "standard_section_id"
        case student_type = "student_type"
        case year_session = "year_session"
        case old_record = "old_record"
        case full_payment_received = "full_payment_received"
        case studentType_update = "studentType_update"
        case fee_bill_id = "fee_bill_id"
        case hostel_bill_id = "hostel_bill_id"
        case hostel_bill_url = "hostel_bill_url"
        case account_created = "account_created"
        case update_stan_section = "update_stan_section"
        case standard_teacher_id = "standard_teacher_id"
        case combo_id = "combo_id"
        case fee_receipt = "fee_receipt"
        case fee_receipt_generatedon = "fee_receipt_generatedon"
        case recordUpdateNewNew = "recordUpdateNewNew"
        case final_update = "final_update"
        case school_type = "school_type"
        case final_update_new = "final_update_new"
        case final_updated = "final_updated"
        case final_updatedd = "final_updatedd"
        case year_branch = "year_branch"
        case admission_date_update = "admission_date_update"
        case refundable_updated = "refundable_updated"
        case __v = "__v"
        case combo_history = "combo_history"
        case created_at = "created_at"
        case fee = "fee"
        case updated_at = "updated_at"
        case fee_type_history = "fee_type_history"
        case ticker = "ticker"
        case is_bill_type_updated = "is_bill_type_updated"
        case transport_bill_id = "transport_bill_id"
        case assessment_record = "assessment_record"
        case assessment_accssible = "assessment_accssible"
        case social_media_consent = "social_media_consent"
       
    }
    
    required init(from decoder: Decoder) throws {
         try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        medical = try values.decodeIfPresent(MedicalData.self, forKey: .medical)
        
        achievement = try values.decodeIfPresent(AchivementData.self, forKey: .achievement)
      //  special_needs = try values.decodeIfPresent(Special_needs.self, forKey: .special_needs)
        fee_type = try values.decodeIfPresent(Int.self, forKey: .fee_type)
        temp_installment = try values.decodeIfPresent(String.self, forKey: .temp_installment)
        fee_type_parent_selected = try values.decodeIfPresent(Int.self, forKey: .fee_type_parent_selected)
        fee_bill_me = try values.decodeIfPresent(Bool.self, forKey: .fee_bill_me)
        account_entry = try values.decodeIfPresent(String.self, forKey: .account_entry)
        arrear_fee = try values.decodeIfPresent(Int.self, forKey: .arrear_fee)
        arrear_transport = try values.decodeIfPresent(Int.self, forKey: .arrear_transport)
        arrear_hostel = try values.decodeIfPresent(Int.self, forKey: .arrear_hostel)
        is_hostel = try values.decodeIfPresent(Bool.self, forKey: .is_hostel)
        is_transport = try values.decodeIfPresent(Bool.self, forKey: .is_transport)
        transport_type = try values.decodeIfPresent(String.self, forKey: .transport_type)
        is_concession = try values.decodeIfPresent(Bool.self, forKey: .is_concession)
        is_detain = try values.decodeIfPresent(Bool.self, forKey: .is_detain)
        transport_renewal = try values.decodeIfPresent(Bool.self, forKey: .transport_renewal)
        stream_selection = try values.decodeIfPresent(Bool.self, forKey: .stream_selection)
        receipt_auto_gen = try values.decodeIfPresent(Bool.self, forKey: .receipt_auto_gen)
        transport_auto_gen = try values.decodeIfPresent(Bool.self, forKey: .transport_auto_gen)
        hostel_auto_gen = try values.decodeIfPresent(Bool.self, forKey: .hostel_auto_gen)
        is_deleted = try values.decodeIfPresent(Bool.self, forKey: .is_deleted)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        addmission = try values.decodeIfPresent(String.self, forKey: .addmission)
        adharcard = try values.decodeIfPresent(String.self, forKey: .adharcard)
        admission_no = try values.decodeIfPresent(String.self, forKey: .admission_no)
        br_code = try values.decodeIfPresent(String.self, forKey: .br_code)
        branchCode = try values.decodeIfPresent(String.self, forKey: .branchCode)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        strclass = try values.decodeIfPresent(String.self, forKey: .strclass)
        combo = try values.decodeIfPresent([ComboData].self, forKey: .combo)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        dateofadmissions = try values.decodeIfPresent(String.self, forKey: .dateofadmissions)
        dateofjoinings = try values.decodeIfPresent(String.self, forKey: .dateofjoinings)
        dateofleaving = try values.decodeIfPresent(String.self, forKey: .dateofleaving)
        details = try values.decodeIfPresent(String.self, forKey: .details)
        email_personal = try values.decodeIfPresent(String.self, forKey: .email_personal)
        //fees = try values.decodeIfPresent(FeesTypeData?.self, forKey: .fees) as? FeesTypeData
       
        gaurdianName = try values.decodeIfPresent(String.self, forKey: .gaurdianName)
        gaurdianphone = try values.decodeIfPresent(String.self, forKey: .gaurdianphone)
        hostel_yes = try values.decodeIfPresent(String.self, forKey: .hostel_yes)
        house = try values.decodeIfPresent(String.self, forKey: .house)
        migration = try values.decodeIfPresent(Bool.self, forKey: .migration)
        mothertongue = try values.decodeIfPresent(String.self, forKey: .mothertongue)
        old_admission_no = try values.decodeIfPresent(String.self, forKey: .old_admission_no)
       // prefect = try values.decodeIfPresent(String.self, forKey: .prefect)
        prev_admission_no = try values.decodeIfPresent(String.self, forKey: .prev_admission_no)
        relation = try values.decodeIfPresent([Relation].self, forKey: .relation)
        remarks = try values.decodeIfPresent(String.self, forKey: .remarks)
        residentialaddress = try values.decodeIfPresent(String.self, forKey: .residentialaddress)
        sch_code = try values.decodeIfPresent(String.self, forKey: .sch_code)
        school_transport = try values.decodeIfPresent(String.self, forKey: .school_transport)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        section_id = try values.decodeIfPresent(LoginAPIDepartmentId.self, forKey: .section_id)
        serial_no = try values.decodeIfPresent(Int.self, forKey: .serial_no)
        sex = try values.decodeIfPresent(String.self, forKey: .sex)
        st_dob = try values.decodeIfPresent(String.self, forKey: .st_dob)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        student_city = try values.decodeIfPresent(String.self, forKey: .student_city)
        student_email = try values.decodeIfPresent(String.self, forKey: .student_email)
        student_mobile = try values.decodeIfPresent(String.self, forKey: .student_mobile)
        student_pinno = try values.decodeIfPresent(String.self, forKey: .student_pinno)
        student_telephone = try values.decodeIfPresent(String.self, forKey: .student_telephone)
        studentImg = try values.decodeIfPresent(String.self, forKey: .studentImg)
        studentname = try values.decodeIfPresent(String.self, forKey: .studentname)
        studentstatus = try values.decodeIfPresent(String.self, forKey: .studentstatus)
        sub_br_code = try values.decodeIfPresent(String.self, forKey: .sub_br_code)
        transport = try values.decodeIfPresent(Transport.self, forKey: .transport)
        upgraded = try values.decodeIfPresent(Bool.self, forKey: .upgraded)
       // variableFees = try values.decodeIfPresent([String].self, forKey: .variableFees)
        yearsession = try values.decodeIfPresent(String.self, forKey: .yearsession)
        carry_forward_show = try values.decodeIfPresent(Bool.self, forKey: .carry_forward_show)
        t_bill_forward = try values.decodeIfPresent(Bool.self, forKey: .t_bill_forward)
        t_carry_forward_show = try values.decodeIfPresent(Bool.self, forKey: .t_carry_forward_show)
        temp = try values.decodeIfPresent(Bool.self, forKey: .temp)
        parentRelation = try values.decodeIfPresent(String.self, forKey: .parentRelation)
        accountEntry = try values.decodeIfPresent(String.self, forKey: .accountEntry)
        currentClass = try values.decodeIfPresent(String.self, forKey: .currentClass)
        currentSection = try values.decodeIfPresent(String.self, forKey: .currentSection)
        currentCombo = try values.decodeIfPresent(String.self, forKey: .currentCombo)
        studentCombo = try values.decodeIfPresent(String.self, forKey: .studentCombo)
        detained = try values.decodeIfPresent(String.self, forKey: .detained)
        reg_board = try values.decodeIfPresent(String.self, forKey: .reg_board)
        securityAmount = try values.decodeIfPresent(String.self, forKey: .securityAmount)
        transWithdrawalDate = try values.decodeIfPresent(String.self, forKey: .transWithdrawalDate)
        prev_section = try values.decodeIfPresent(String.self, forKey: .prev_section)
        refundedSecurity = try values.decodeIfPresent(String.self, forKey: .refundedSecurity)
      //  concession = try values.decodeIfPresent([Concession].self, forKey: .concession)
        othercountrynew = try values.decodeIfPresent(String.self, forKey: .othercountrynew)
        othercountry = try values.decodeIfPresent(String.self, forKey: .othercountry)
        nationality = try values.decodeIfPresent(String.self, forKey: .nationality)
        othernationalitynew = try values.decodeIfPresent(String.self, forKey: .othernationalitynew)
        othernationality = try values.decodeIfPresent(String.self, forKey: .othernationality)
        feebillurl = try values.decodeIfPresent(String.self, forKey: .feebillurl)
        feegeneratedon = try values.decodeIfPresent(String.self, forKey: .feegeneratedon)
        aadhar_card = try values.decodeIfPresent(String.self, forKey: .aadhar_card)
        acount_entry = try values.decodeIfPresent(String.self, forKey: .acount_entry)
        address = try values.decodeIfPresent([Address].self, forKey: .address)
        admission_standard = try values.decodeIfPresent(LoginAPIDepartmentId.self, forKey: .admission_standard)
        branch_code = try values.decodeIfPresent(Int.self, forKey: .branch_code)
        category_id = try values.decodeIfPresent(Category_id.self, forKey: .category_id)
        cbse_reg_no = try values.decodeIfPresent(String.self, forKey: .cbse_reg_no)
        date_of_admission = try values.decodeIfPresent(String.self, forKey: .date_of_admission)
        date_of_birth = try values.decodeIfPresent(String.self, forKey: .date_of_birth)
        date_of_joining = try values.decodeIfPresent(String.self, forKey: .date_of_joining)
        date_of_withdrawal = try values.decodeIfPresent(String.self, forKey: .date_of_withdrawal)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        house_id = try values.decodeIfPresent(LoginAPIHouseTeacherID.self, forKey: .house_id)
        mother_tongue_id = try values.decodeIfPresent(LoginAPIDepartmentId.self, forKey: .mother_tongue_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        profile_pic = try values.decodeIfPresent(String.self, forKey: .profile_pic)
        recordUpdateNew = try values.decodeIfPresent(Bool.self, forKey: .recordUpdateNew)
        school_code = try values.decodeIfPresent(String.self, forKey: .school_code)
        siblings = try values.decodeIfPresent([Siblings].self, forKey: .siblings)
        sms_mobile = try values.decodeIfPresent(String.self, forKey: .sms_mobile)
        standard_id = try values.decodeIfPresent(LoginAPIDepartmentId.self, forKey: .standard_id)
       // standard_section_id = try values.decodeIfPresent(String.self, forKey: .standard_section_id)
        student_type = try values.decodeIfPresent(String.self, forKey: .student_type)
        year_session = try values.decodeIfPresent(String.self, forKey: .year_session)
        old_record = try values.decodeIfPresent(Bool.self, forKey: .old_record)
        full_payment_received = try values.decodeIfPresent(Bool.self, forKey: .full_payment_received)
        studentType_update = try values.decodeIfPresent(Bool.self, forKey: .studentType_update)
        fee_bill_id = try values.decodeIfPresent(Fee_bill_id.self, forKey: .fee_bill_id)
        hostel_bill_id = try values.decodeIfPresent(Fee_bill_id.self, forKey: .hostel_bill_id)
        hostel_bill_url = try values.decodeIfPresent(String.self, forKey: .hostel_bill_url)
        account_created = try values.decodeIfPresent(Bool.self, forKey: .account_created)
        update_stan_section = try values.decodeIfPresent(Bool.self, forKey: .update_stan_section)
        standard_teacher_id = try values.decodeIfPresent(String.self, forKey: .standard_teacher_id)
        combo_id = try values.decodeIfPresent(Combo_id.self, forKey: .combo_id)
        fee_receipt = try values.decodeIfPresent(String.self, forKey: .fee_receipt)
        fee_receipt_generatedon = try values.decodeIfPresent(String.self, forKey: .fee_receipt_generatedon)
        recordUpdateNewNew = try values.decodeIfPresent(Bool.self, forKey: .recordUpdateNewNew)
        final_update = try values.decodeIfPresent(Bool.self, forKey: .final_update)
        school_type = try values.decodeIfPresent(String.self, forKey: .school_type)
        final_update_new = try values.decodeIfPresent(Bool.self, forKey: .final_update_new)
        final_updated = try values.decodeIfPresent(Bool.self, forKey: .final_updated)
        final_updatedd = try values.decodeIfPresent(Bool.self, forKey: .final_updatedd)
        year_branch = try values.decodeIfPresent(Int.self, forKey: .year_branch)
        admission_date_update = try values.decodeIfPresent(Bool.self, forKey: .admission_date_update)
        refundable_updated = try values.decodeIfPresent(String.self, forKey: .refundable_updated)
        __v = try values.decodeIfPresent(Int.self, forKey: .__v)
       // combo_history = try values.decodeIfPresent([Combo_history].self, forKey: .combo_history)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        fee = try values.decodeIfPresent([String].self, forKey: .fee)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        //fee_type_history = try values.decodeIfPresent([String].self, forKey: .fee_type_history)
        ticker = try values.decodeIfPresent([String].self, forKey: .ticker)
        is_bill_type_updated = try values.decodeIfPresent(Bool.self, forKey: .is_bill_type_updated)
        transport_bill_id = try values.decodeIfPresent(Transport_BillData.self, forKey: .transport_bill_id)
        assessment_record = try values.decodeIfPresent(String.self, forKey: .assessment_record)
        assessment_accssible = try values.decodeIfPresent(Bool.self, forKey: .assessment_accssible)
        social_media_consent = try values.decodeIfPresent(SocialMediaConsent.self, forKey: .social_media_consent)
        
    }
    
}

class SocialMediaConsent : WSResponseData {
    var is_visible : Bool?
    var path: String?

    enum CodingKeys: String, CodingKey {
        case is_visible = "is_visible"
        case path = "path"
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        is_visible = try values.decodeIfPresent(Bool.self, forKey: .is_visible)
        path = try values.decodeIfPresent(String.self, forKey: .path)
    }
}
