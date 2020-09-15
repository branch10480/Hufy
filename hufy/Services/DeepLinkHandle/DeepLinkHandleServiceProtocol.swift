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
        if components.count > 5, components[1] == "join" {
            self = .join(userId: components[3], todoGroupId: components[5])
        } else {
            return nil
        }
    }
}
