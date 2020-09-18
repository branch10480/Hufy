//
//  InvitationViewModel.swift
//  hufy
//
//  Created by branch10480 on 2020/09/19.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class InvitationViewModel: BaseViewModel {
    
    let invitationQRCodeImage: BehaviorRelay<UIImage?> = .init(value: nil)
    
    private let linkGenerator: DynamicLinkGeneratorProtocol
    private let accountManager: AccountManagerProtocol
    
    init(
        linkGenerator: DynamicLinkGeneratorProtocol,
        accountManager: AccountManagerProtocol
    ) {
        self.linkGenerator = linkGenerator
        self.accountManager = accountManager
    }
}
