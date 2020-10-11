//
//  TrashDay.swift
//  hufy
//
//  Created by branch10480 on 2020/10/11.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import ObjectMapper

struct TrashDay: Mappable {
    
    var id: String = ""
    var day: String = ""
    var isOn: Bool = false
    var title: String = ""
    var inChargeOf: String = ""
    var remark: String = ""
    
    init() {}
    
    init?(map: Map) {
    }
    
    var dayType: DayType? {
        return DayType(rawValue: self.day)
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        day <- map["day"]
        isOn <- map["isOn"]
        title <- map["title"]
        inChargeOf <- map["inChargeOf"]
        remark <- map["remark"]
    }
    
    var dictionary: [String: Any] {
        var dic: [String: Any] = ["id": id]
        dic["id"] = id
        dic["day"] = day
        dic["isOn"] = isOn
        dic["title"] = title
        dic["inChargeOf"] = inChargeOf
        dic["remark"] = remark
        return dic
    }
}

enum DayType: String {
    case sun = "sun"
    case mon = "mon"
    case tue = "tue"
    case wed = "wed"
    case thu = "thu"
    case fri = "fri"
    case sat = "sat"
}

extension DayType {
    var title: String {
        switch self {
        case .sun: return "Sanday".localized
        case .mon: return "Monday".localized
        case .tue: return "Tuesday".localized
        case .wed: return "Wednesday".localized
        case .thu: return "Thursday".localized
        case .fri: return "Friday".localized
        case .sat: return "Saturday".localized
        }
    }
}
