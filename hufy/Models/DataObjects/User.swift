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
        partnerID <- map["partnerID"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
    }
    
    var dictionary: [String: Any] {
        var dic: [String: Any] = ["id": id]
        if let name         = name { dic["name"] = name }
        if let iconURL      = iconURL { dic["iconURL"] = iconURL }
        if let partnerID    = partnerID { dic["partnerID"] = partnerID }
        if let createdAt = createdAt {
            dic["createdAt"] = createdAt
        } else {
            dic["createdAt"] = FirebaseFirestore.FieldValue.serverTimestamp()
        }
        dic["updatedAt"] = FirebaseFirestore.FieldValue.serverTimestamp()
        return dic
    }
}
