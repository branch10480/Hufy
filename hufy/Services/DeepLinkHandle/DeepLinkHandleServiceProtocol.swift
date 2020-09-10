//
//  DeepLinkHandleServiceProtocol.swift
//  hufy
//
//  Created by branch10480 on 2020/09/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import FirebaseDynamicLinks

protocol DeepLinkHandleServiceProtocol {
    func handle(deepLink: URL?)
}

enum DeepLinkType {
    case invitation(userID: String)
    
    init?(url: URL) {
        let components = url.pathComponents
        if components.count > 3, components[1] == "invitation" {
            self = .invitation(userID: components[3])
        } else {
            return nil
        }
    }
}
