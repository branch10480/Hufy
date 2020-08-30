//
//  Todo.swift
//  hufy
//
//  Created by branch10480 on 2020/08/29.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import ObjectMapper

struct Todo: Mappable {
    var id: String = UUID().uuidString
    var title: String = ""
    var isDone: Bool = false
    var createdAt: Timestamp?
    var updatedAt: Timestamp?
    
    init() {
    }
    
    public init?(map: Map) {
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        isDone <- map["isDone"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
    }
    
    var dictionary: [String: Any] {
        var dic: [String: Any] = ["id": id]
        dic["title"] = title
        dic["isDone"] = isDone
        if let createdAt = createdAt {
            dic["createdAt"] = createdAt
        } else {
            dic["createdAt"] = FirebaseFirestore.FieldValue.serverTimestamp()
        }
        dic["updatedAt"] = FirebaseFirestore.FieldValue.serverTimestamp()
        return dic
    }
}
