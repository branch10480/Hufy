//
//  TabBarViewModel.swift
//  hufy
//
//  Created by branch10480 on 2021/01/12.
//  Copyright © 2021 Toshiharu Imaeda. All rights reserved.
//

import UIKit

final class TabBarViewModel: BaseViewModel {

    private let accountUseCase: AccountUseCaseProtocol

    init(accountUseCase: AccountUseCaseProtocol) {
        self.accountUseCase = accountUseCase
        self.accountUseCase.startToListenMySelf()
    }

    deinit {
        self.accountUseCase.stopListeningMySelf()
    }
}
