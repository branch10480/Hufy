//
//  DeepLinkType.swift
//  hufy
//
//  Created by branch10480 on 2021/03/25.
//  Copyright © 2021 Toshiharu Imaeda. All rights reserved.
//

import Foundation

enum DeepLinkType {
    case join(userId: String, todoGroupId: String)
    
    init?(url: URL) {
        let components = url.pathComponents
        let host = url.host
        if components.count > 2, host == "invitation" {
            self = .join(userId: components[1], todoGroupId: components[2])
        } else {
            return nil
        }
    }
}
