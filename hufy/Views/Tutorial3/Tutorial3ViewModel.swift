//
//  Tutorial3ViewModel.swift
//  hufy
//
//  Created by branch10480 on 2020/08/16.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class Tutorial3ViewModel: BaseViewModel {
    let profileImageURL: BehaviorRelay<URL?> = .init(value: nil)
    private let manager: AccountManagerProtocol
    
    init(manager: AccountManagerProtocol) {
        self.manager = manager
        super.init()

        manager.getProfileImageURL().subscribe(onNext: { [weak self] url in
            self?.profileImageURL.accept(url)
        }).disposed(by: self.disposeBag)
    }
}
