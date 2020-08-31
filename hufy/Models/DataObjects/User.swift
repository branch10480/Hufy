//
//  User.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import ObjectMapper

struct User: Mappable {
    var id: String = UUID().uuidString
    var name: String?
    var iconURL: String?
    var partnerID: String?
    var tutorial1Done: Bool = true
    var tutorial2Done: Bool = false
    var tutorial3Done: Bool = false
    var belongingGroupId: String = ""
    var createdAt: Timestamp?
    var updatedAt: Timestamp?
    
    init() {
    }
    
    public init?(map: Map) {
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        iconURL <- map["iconURL"]
        tutorial1Done <- map["tutorial1Done"]
        tutorial2Done <- map["tutorial2Done"]
        tutorial3Done <- map["tutorial3Done"]
        belongingGroupId <- map["belongingGroupId"]
        partnerID <- map["partnerID"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
    }
    
    var dictionary: [String: Any] {
        var dic: [String: Any] = ["id": id]
        if let name         = name { dic["name"] = name }
        if let iconURL      = iconURL { dic["iconURL"] = iconURL }
        if let partnerID    = partnerID { dic["partnerID"] = partnerID }
        dic["tutorial1Done"] = tutorial1Done
        dic["tutorial2Done"] = tutorial2Done
        dic["tutorial3Done"] = tutorial3Done
        if let createdAt = createdAt {
            dic["createdAt"] = createdAt
        } else {
            dic["createdAt"] = FirebaseFirestore.FieldValue.serverTimestamp()
        }
        dic["updatedAt"] = FirebaseFirestore.FieldValue.serverTimestamp()
        return dic
    }
}
