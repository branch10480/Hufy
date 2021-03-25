//
//  DeepLinkHandleUseCase.swift
//  hufy
//
//  Created by branch10480 on 2020/09/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import FirebaseDynamicLinks
import RxSwift
import RxRelay

final class DeepLinkHandleUseCase: DeepLinkHandleUseCaseProtocol {
    
    private let accountGateway: AccountGatewayProtocol
    
    private let disposeBag = DisposeBag()
    let isLoading: BehaviorRelay<Bool> = .init(value: false)
    let errorMessage: PublishRelay<String> = .init()
    let succeededToJoin: PublishRelay<Void> = .init()
    
    init(
        gateway: AccountGatewayProtocol
    ) {
        self.accountGateway = gateway
    }

    func handle(deepLink: URL?) {
        guard let url = deepLink,
              let type = DeepLinkType(url: url) else
        {
            return
        }
        switch type {
        case .join(let userId, let todoGroupId):
            isLoading.accept(true)
            accountGateway
                .join(partnerId: userId, partnerTodoGroupId: todoGroupId)
                .observe(on: MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] in
                    self?.isLoading.accept(false)
                    self?.succeededToJoin.accept(())
                }, onFailure: { [weak self] error in
                    self?.isLoading.accept(false)
                    self?.errorMessage.accept(error.localizedDescription)
                })
                .disposed(by: disposeBag)
        }
    }
}
