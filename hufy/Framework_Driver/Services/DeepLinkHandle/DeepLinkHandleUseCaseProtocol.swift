//
//  DeepLinkHandleUseCaseProtocol.swift
//  hufy
//
//  Created by branch10480 on 2020/09/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import FirebaseDynamicLinks
import RxRelay

protocol DeepLinkHandleUseCaseProtocol {
    var isLoading: BehaviorRelay<Bool> { get }
    var errorMessage: PublishRelay<String> { get }
    var succeededToJoin: PublishRelay<Void> { get }
    func handle(deepLink: URL?)
}
