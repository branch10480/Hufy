//
//  EntryViewModel.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import FirebaseAuth

class EntryViewModel: BaseViewModel {
    
    let loginState: BehaviorRelay<LoginState> = .init(value: .notLoggedIn)
    private let accountManager: AccountManagerProtocol
    
    enum LoginState {
        case notLoggedIn
        case loggedIn
    }
    
    init(accountManager: AccountManagerProtocol) {
        self.accountManager = accountManager
        loginState.accept(accountManager.isLiggedIn() ? .loggedIn : .notLoggedIn)
    }
}
