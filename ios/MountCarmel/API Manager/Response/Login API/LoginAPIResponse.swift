//
//	LoginAPIResponse.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginAPIResponse : WSResponseData {
    
    var menu : LoginAPIMenu?
    var metaData : LoginAPIMetaData?
    var status : Bool?
    var path : String?
    var parent_path : String?
    var user : LoginAPIUser?
    var message : String?
    
    enum CodingKeys: String, CodingKey {
        case menu
        case metaData = "meta_data"
        case status = "status"
        case user = "user"
        case path = "path"
        case parent_path = "parent_path"
        case message = "message"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        menu = try values.decodeIfPresent(LoginAPIMenu.self, forKey: .menu)
        metaData = try values.decodeIfPresent(LoginAPIMetaData.self, forKey: .metaData)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        user = try values.decodeIfPresent(LoginAPIUser.self, forKey: .user)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        parent_path = try values.decodeIfPresent(String.self, forKey: .parent_path)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(menu, forKey: .menu)
        try container.encode(metaData, forKey: .metaData)
        try container.encode(status, forKey: .status)
        try container.encode(user, forKey: .user)
        try container.encode(path, forKey: .path)
        try container.encode(parent_path, forKey: .parent_path)
    }
}

class fcmModel:WSResponseData{
    var message:String?
    var status:Bool?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
    }
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
        try container.encode(status, forKey: .status)
    }
}

class SelfAwernessData : WSResponseData {
    
    var data : SelfAwerness?
    var golive_data : SelfAwernessGolive_data?
    
    enum CodingKeys: String, CodingKey {
        case data
        case golive_data
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(SelfAwerness.self, forKey: .data)
        golive_data = try values.decodeIfPresent(SelfAwernessGolive_data.self, forKey: .golive_data)
    }
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
        try container.encode(golive_data, forKey: .golive_data)
    }
}

class SelfAwerness : WSResponseData {
    
    var updated_at : String?
    var my_goal : String?
    var my_interest_hobbies : String?
    var my_strength : String?
    var responsibilities : String?
    var is_submit : Bool?
    
    enum CodingKeys: String, CodingKey {
        case updated_at
        case my_goal
        case my_interest_hobbies
        case my_strength
        case responsibilities
        case is_submit
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        my_goal = try values.decodeIfPresent(String.self, forKey: .my_goal)
        my_interest_hobbies = try values.decodeIfPresent(String.self, forKey: .my_interest_hobbies)
        my_strength = try values.decodeIfPresent(String.self, forKey: .my_strength)
        responsibilities = try values.decodeIfPresent(String.self, forKey: .responsibilities)
        is_submit = try values.decodeIfPresent(Bool.self, forKey: .is_submit)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(updated_at, forKey: .updated_at)
        try container.encode(my_goal, forKey: .my_goal)
        try container.encode(my_interest_hobbies, forKey: .my_interest_hobbies)
        try container.encode(my_strength, forKey: .my_strength)
        try container.encode(responsibilities, forKey: .responsibilities)
        try container.encode(is_submit, forKey: .is_submit)
    }
}

class SelfAwernessGolive_data:WSResponseData{
    
    var end_date: String?
    var end_time: String?
    
    enum CodingKeys: String, CodingKey {
        case end_date
        case end_time
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
        end_time = try values.decodeIfPresent(String.self, forKey: .end_time)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(end_date, forKey: .end_date)
        try container.encode(end_time, forKey: .end_time)
    }
}

class SelfAwernessPost : WSResponseData {
    
    var message : String?
    var status : Bool?
    
    enum CodingKeys: String, CodingKey {
        case message
        case status
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
    }
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
        try container.encode(status, forKey: .status)
    }
}

class SelfAwernessMenu : WSResponseData {
    var self_awareness : selfAwarenessModel?
    var stream : streamModel?
    var transport_renewal_form : transport_renewal_form_Model?
    var transport_request : transport_request_Model?
    var session_details : session_detailsModel?
    var chronicles : chroniclesModel?
    var newsletter : newsletterModel?
    var id_card : idCardModel?
    var nomination : NominationModel?
    
    enum CodingKeys: String, CodingKey {
        case self_awareness
        case stream
        case transport_renewal_form
        case chronicles
        case newsletter
        case id_card
        case session_details
        case nomination
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self_awareness = try values.decodeIfPresent(selfAwarenessModel.self, forKey: .self_awareness)
        stream = try values.decodeIfPresent(streamModel.self, forKey: .stream)
        transport_renewal_form = try values.decodeIfPresent(transport_renewal_form_Model.self, forKey: .transport_renewal_form)
        
        session_details = try values.decodeIfPresent(session_detailsModel.self, forKey: .session_details)
        
        chronicles = try values.decodeIfPresent(chroniclesModel.self, forKey: .chronicles)
        newsletter = try values.decodeIfPresent(newsletterModel.self, forKey: .newsletter)
        id_card = try values.decodeIfPresent(idCardModel.self, forKey: .id_card)
        nomination = try values.decodeIfPresent(NominationModel.self, forKey: .nomination)
    }
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self_awareness, forKey: .self_awareness)
        try container.encode(stream, forKey: .stream)
        try container.encode(transport_renewal_form, forKey: .transport_renewal_form)
        try container.encode(chronicles, forKey: .chronicles)
        try container.encode(newsletter, forKey: .newsletter)
        try container.encode(id_card, forKey: .id_card)
        try container.encode(session_details, forKey: .session_details)
        try container.encode(nomination, forKey: .nomination)
    }
}

class NominationModel : WSResponseData {
    var setting : NominationSettingModel?

    enum CodingKeys: String, CodingKey {
        case setting
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        setting = try values.decodeIfPresent(NominationSettingModel.self, forKey: .setting)
    }
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(setting, forKey: .setting)
    }
}

class NominationSettingModel : WSResponseData {
    var _id : String?
    var standard_section_id : StandardSection?
    enum CodingKeys: String, CodingKey {
        case _id
        case standard_section_id
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        standard_section_id = try values.decodeIfPresent(StandardSection.self, forKey: .standard_section_id)
    }
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(standard_section_id, forKey: .standard_section_id)
    }
}

class idCardModel : WSResponseData {
  
        var is_show : Bool?
        enum CodingKeys: String, CodingKey {
            case is_show
        }
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            is_show = try values.decodeIfPresent(Bool.self, forKey: .is_show)
        }
        public override func encode(to encoder: Encoder) throws {
            try! super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(is_show, forKey: .is_show)
        }
}

class selfAwarenessModel : WSResponseData {
    var setting : SelfAwernessSetting?

    enum CodingKeys: String, CodingKey {
        case setting
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        setting = try values.decodeIfPresent(SelfAwernessSetting.self, forKey: .setting)
    }
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(setting, forKey: .setting)
    }
}

class SelfAwernessSetting : WSResponseData {
    var branch_code : Int?
    var end_date : String?
    var end_time : String?
    var start_date : String?
    var start_time : String?
    
    enum CodingKeys: String, CodingKey {
        case branch_code
        case end_date
        case end_time
        case start_date
        case start_time
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        branch_code = try values.decodeIfPresent(Int.self, forKey: .branch_code)
        end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
        end_time = try values.decodeIfPresent(String.self, forKey: .end_time)
        start_date = try values.decodeIfPresent(String.self, forKey: .start_date)
        start_time = try values.decodeIfPresent(String.self, forKey: .start_time)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(branch_code, forKey: .branch_code)
        try container.encode(end_date, forKey: .end_date)
        try container.encode(end_time, forKey: .end_time)
        try container.encode(start_date, forKey: .start_date)
        try container.encode(start_time, forKey: .start_time)
    }
}


class streamModel : WSResponseData {
    var setting : StreamSetting?
    var data : StreamData?

    enum CodingKeys: String, CodingKey {
        case setting
        case data
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        setting = try values.decodeIfPresent(StreamSetting.self, forKey: .setting)
        data = try values.decodeIfPresent(StreamData.self, forKey: .data)
    }
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(setting, forKey: .setting)
        try container.encode(data, forKey: .data)
    }
}

class StreamSetting : WSResponseData {
    var branch_code : Int?
    var remark : String?
    var end_date : String?
    var end_time : String?
    var start_date : String?
    var start_time : String?
    
    enum CodingKeys: String, CodingKey {
        case branch_code
        case end_date
        case end_time
        case start_date
        case start_time
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        branch_code = try values.decodeIfPresent(Int.self, forKey: .branch_code)
        end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
        end_time = try values.decodeIfPresent(String.self, forKey: .end_time)
        start_date = try values.decodeIfPresent(String.self, forKey: .start_date)
        start_time = try values.decodeIfPresent(String.self, forKey: .start_time)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(branch_code, forKey: .branch_code)
        try container.encode(end_date, forKey: .end_date)
        try container.encode(end_time, forKey: .end_time)
        try container.encode(start_date, forKey: .start_date)
        try container.encode(start_time, forKey: .start_time)
    }
}

class StreamData : WSResponseData {
    var combination_id: combination_Model?
    var is_additional_subject : Bool?
    var remark : String?
    var subject1 : String?
    var subject2 : String?
    var subject3 : String?
    var subject4 : String?
    var subject5 : String?
    var subject6 : String?
    var updated_at : String?
    
    enum CodingKeys: String, CodingKey {
        case combination_id
        case is_additional_subject
        case remark
        case subject1
        case subject2
        case subject3
        case subject4
        case subject5
        case subject6
        case updated_at
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        combination_id = try values.decodeIfPresent(combination_Model.self, forKey: .combination_id)
        is_additional_subject = try values.decodeIfPresent(Bool.self, forKey: .is_additional_subject)
        remark = try values.decodeIfPresent(String.self, forKey: .remark)
        subject1 = try values.decodeIfPresent(String.self, forKey: .subject1)
        subject2 = try values.decodeIfPresent(String.self, forKey: .subject2)
        subject3 = try values.decodeIfPresent(String.self, forKey: .subject3)
        subject4 = try values.decodeIfPresent(String.self, forKey: .subject4)
        subject5 = try values.decodeIfPresent(String.self, forKey: .subject5)
        subject6 = try values.decodeIfPresent(String.self, forKey: .subject6)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(combination_id, forKey: .combination_id)
        try container.encode(is_additional_subject, forKey: .is_additional_subject)
        try container.encode(remark, forKey: .remark)
        try container.encode(subject1, forKey: .subject1)
        try container.encode(subject2, forKey: .subject2)
        try container.encode(subject3, forKey: .subject3)
        try container.encode(subject4, forKey: .subject4)
        try container.encode(subject5, forKey: .subject5)
        try container.encode(subject6, forKey: .subject6)
        try container.encode(updated_at, forKey: .updated_at)
    }
}

class combination_Model : WSResponseData {
    var _id : String?
    
    enum CodingKeys: String, CodingKey {
        case _id
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
    }
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
    }
}

class transport_request_Model : WSResponseData {
    var is_show : Bool?
    var message : String?
    
    enum CodingKeys: String, CodingKey {
        case is_show
        case message
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        is_show = try values.decodeIfPresent(Bool.self, forKey: .is_show)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(is_show, forKey: .is_show)
        try container.encode(message, forKey: .message)
    }
}

class transport_renewal_form_Model : WSResponseData {
    var is_show : Bool?
    
    enum CodingKeys: String, CodingKey {
        case is_show
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        is_show = try values.decodeIfPresent(Bool.self, forKey: .is_show)
    }
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(is_show, forKey: .is_show)
    }
}

class session_detailsModel : WSResponseData {
    var year_session : String?
    
    enum CodingKeys: String, CodingKey {
        case year_session
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        year_session = try values.decodeIfPresent(String.self, forKey: .year_session)
    }
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(year_session, forKey: .year_session)
    }
}

class chroniclesModel : WSResponseData {
    var data : chroniclesData?
    var path : String?

    enum CodingKeys: String, CodingKey {
        case data
        case path
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(chroniclesData.self, forKey: .data)
        path = try values.decodeIfPresent(String.self, forKey: .path)
    }
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
        try container.encode(path, forKey: .path)
    }
}

class chroniclesData : WSResponseData {
    var _id : String?
    var end_date : String?
    var file_name : String?
    var name : String?
    var start_date : String?
    
    enum CodingKeys: String, CodingKey {
        case _id
        case end_date
        case file_name
        case name
        case start_date
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
        file_name = try values.decodeIfPresent(String.self, forKey: .file_name)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        start_date = try values.decodeIfPresent(String.self, forKey: .start_date)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(end_date, forKey: .end_date)
        try container.encode(file_name, forKey: .file_name)
        try container.encode(name, forKey: .name)
        try container.encode(start_date, forKey: .start_date)
    }
}

class newsletterModel : WSResponseData {
    var data : newsletterData?
    var path : String?

    enum CodingKeys: String, CodingKey {
        case data
        case path
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(newsletterData.self, forKey: .data)
        path = try values.decodeIfPresent(String.self, forKey: .path)
    }
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
        try container.encode(path, forKey: .path)
    }
}

class newsletterData : WSResponseData {
    var _id : String?
    var end_date : String?
    var file_name : String?
    var name : String?
    var start_date : String?
    
    enum CodingKeys: String, CodingKey {
        case _id
        case end_date
        case file_name
        case name
        case start_date
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
        file_name = try values.decodeIfPresent(String.self, forKey: .file_name)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        start_date = try values.decodeIfPresent(String.self, forKey: .start_date)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(end_date, forKey: .end_date)
        try container.encode(file_name, forKey: .file_name)
        try container.encode(name, forKey: .name)
        try container.encode(start_date, forKey: .start_date)
    }
}


//chronicles =     {
//    data =         {
//        "_id" = 64f0aba23686381cc3d6b37b;
//        "end_date" = "2024-03-31T18:29:00.000Z";
//        "file_name" = "dwsr-udaan-magazine-1693494173836.pdf";
//        name = "UDAAN-JANUARY TO MARCH 2023";
//        "start_date" = "2023-08-30T18:30:00.000Z";
//    };
//    path = "https://mountcarmelschool.com:4201/uploads/newsletter/2023-24/11/";
//};
//
//newsletter =     {
//    data =         {
//        "_id" = 64f0ab733686381cc3d6b37a;
//        "end_date" = "2024-03-31T18:29:00.000Z";
//        "file_name" = "spotlight-apr-july-2023-1693494105334.pdf";
//        name = "ANSR-NEWSLETTER-APRIL TO JULY 2023";
//        "start_date" = "2023-08-30T18:30:00.000Z";
//    };
//    path = "https://mountcarmelschool.com:4201/uploads/newsletter/2023-24/11/";
//};
