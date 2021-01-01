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
    var createdAt: Timestamp
    var updatedAt: Timestamp
    var isNew: Bool = true
    
    init() {
        self.createdAt = Timestamp(date: Date())
        self.updatedAt = self.createdAt
    }
    
    public init?(map: Map) {
        self.createdAt = Timestamp(date: Date())
        self.updatedAt = self.createdAt
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        isDone <- map["isDone"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
        isNew = false
    }
    
    var dictionary: [String: Any] {
        var dic: [String: Any] = ["id": id]
        dic["title"] = title
        dic["isDone"] = isDone
        dic["createdAt"] = createdAt
        dic["updatedAt"] = FirebaseFirestore.FieldValue.serverTimestamp()
        return dic
    }
}
