//
//  TrashDayViewModel.swift
//  hufy
//
//  Created by branch10480 on 2020/10/11.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation

class TrashDayViewModel: BaseViewModel {
    
    private let accountManager: AccountManagerProtocol
    
    init(
        accountManager: AccountManagerProtocol
    ) {
        self.accountManager = accountManager
    }
}
