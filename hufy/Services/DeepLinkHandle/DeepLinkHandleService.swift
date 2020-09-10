//
//  DeepLinkHandleService.swift
//  hufy
//
//  Created by branch10480 on 2020/09/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import FirebaseDynamicLinks

final class DeepLinkHandleService: DeepLinkHandleServiceProtocol {
    
    private let appFlowService: AppFlowServiceProtocol
    
    init(service: AppFlowServiceProtocol) {
        self.appFlowService = service
    }

    func handle(deepLink: URL?) {
        guard let url = deepLink, let type = DeepLinkType(url: url) else {
            return
        }
        switch type {
        case .invitation(let userID):
            appFlowService.showInvitationFlow(userID: userID)
        }
    }
}
