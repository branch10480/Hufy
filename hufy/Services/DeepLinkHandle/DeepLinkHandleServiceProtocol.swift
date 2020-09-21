//
//  DeepLinkHandleServiceProtocol.swift
//  hufy
//
//  Created by branch10480 on 2020/09/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import FirebaseDynamicLinks
import RxRelay

protocol DeepLinkHandleServiceProtocol {
    var isLoading: BehaviorRelay<Bool> { get }
    var errorMessage: PublishRelay<String> { get }
    var succeededToJoin: PublishRelay<Void> { get }
    func handle(deepLink: URL?)
}

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
