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
    let linkOfLineToOpen: Observable<URL>
    
    private let linkGenerator: DynamicLinkGeneratorProtocol
    private let accountUseCase: AccountUseCaseProtocol
    private let invitationLink: BehaviorRelay<URL?> = .init(value: nil)
    
    init(
        lineButtonTap: Observable<Void>,
        linkGenerator: DynamicLinkGeneratorProtocol,
        accountUseCase: AccountUseCaseProtocol
    ) {
        self.linkGenerator = linkGenerator
        self.accountUseCase = accountUseCase
        
        linkOfLineToOpen = lineButtonTap.withLatestFrom(invitationLink.asObservable())
            .filter { $0 != nil }
            .map { link -> URL in
                return link!
            }
        
        super.init()
        
        let userObservable: Observable<User> = accountUseCase.userSelfObservable
            .asObservable()
            .filter { $0 != nil }
            .map { $0! }
        
        userObservable.flatMap({ [weak self] user -> Single<URL?> in
            self?.isLoading.accept(true)
            return linkGenerator.getInvitationLink(userId: user.id, todoGroupId: user.belongingGroupId)
        })
        .map { [weak self] url -> UIImage? in
            guard let url = url else {
                return nil
            }
            self?.invitationLink.accept(url)
            return UIImage.generateQRCode(from: url.absoluteString)
        }
        .subscribe(onNext: { [weak self] image in
            self?.invitationQRCodeImage.accept(image)
            self?.isLoading.accept(false)
        }, onError: { [weak self] _ in
            self?.isLoading.accept(false)
        })
        .disposed(by: disposeBag)
        
        // ユーザー情報が存在しない場合、フェッチ
        if accountUseCase.userSelf == nil {
            self.isLoading.accept(true)
            accountUseCase.fetchUserSelf().subscribe(onNext: { [weak self] user in
                self?.isLoading.accept(false)
            }, onError: { [weak self] _ in
                self?.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
        }
    }
}
