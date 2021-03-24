//
//  TabBarViewModel.swift
//  hufy
//
//  Created by branch10480 on 2021/01/12.
//  Copyright © 2021 Toshiharu Imaeda. All rights reserved.
//

import UIKit

final class TabBarViewModel: BaseViewModel {

    private let accountManager: AccountManagerProtocol

    init(accountManager: AccountManagerProtocol) {
        self.accountManager = accountManager
        self.accountManager.startToListenMySelf()
    }

    deinit {
        self.accountManager.stopListeningMySelf()
    }
}
