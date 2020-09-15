//
//  DeepLinkHandleService.swift
//  hufy
//
//  Created by branch10480 on 2020/09/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import FirebaseDynamicLinks
import RxSwift
import RxRelay

final class DeepLinkHandleService: DeepLinkHandleServiceProtocol {
    
    private let accountManager: AccountManagerProtocol
    
    private let disposeBag = DisposeBag()
    let isLoading: BehaviorRelay<Bool> = .init(value: false)
    let errorMessage: PublishRelay<String> = .init()
    let succeededToJoin: PublishRelay<Void> = .init()
    
    init(
        manager: AccountManagerProtocol
    ) {
        self.accountManager = manager
    }

    func handle(deepLink: URL?) {
        guard let url = deepLink, let type = DeepLinkType(url: url) else {
            return
        }
        switch type {
        case .join(let userId, let todoGroupId):
            isLoading.accept(true)
            accountManager
                .join(partnerId: userId, partnerTodoGroupId: todoGroupId)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] in
                    self?.isLoading.accept(false)
                    self?.succeededToJoin.accept(())
                }, onError: { [weak self] error in
                    self?.isLoading.accept(false)
                    self?.errorMessage.accept(error.localizedDescription)
                })
                .disposed(by: disposeBag)
        }
    }
}
