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
    
    let accountState: BehaviorRelay<AccountState> = .init(value: .notCreated)
    private let accountManager: AccountManagerProtocol
    
    enum AccountState {
        case notCreated
        case tutorial1Done
        case tutorial2Done
        case tutorial3Done
    }
    
    init(accountManager: AccountManagerProtocol) {
        self.accountManager = accountManager
        super.init()
        guard let _ = Auth.auth().currentUser else {
            accountState.accept(.notCreated)
            return
        }
        
        accountManager.fetchUserSelf().subscribe(onNext: { [weak self] user in
            if user.tutorial3Done {
                self?.accountState.accept(.tutorial3Done)
            } else if user.tutorial2Done {
                self?.accountState.accept(.tutorial2Done)
            } else {
                self?.accountState.accept(.tutorial1Done)
            }
        }).disposed(by: disposeBag)
    }
}
