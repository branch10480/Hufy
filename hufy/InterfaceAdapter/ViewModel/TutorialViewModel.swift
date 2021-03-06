//
//  TutorialViewModel.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class TutorialViewModel: BaseViewModel {
    
    let loginSuccess: BehaviorRelay<User?> = .init(value: nil)
    
    private let accountUseCase: AccountUseCaseProtocol
    
    init(tapObservable: Observable<Void>, accountUseCase: AccountUseCaseProtocol) {
        self.accountUseCase = accountUseCase
        super.init()
        tapObservable
            .do(onNext: { [weak self] in
                self?.isLoading.accept(true)
            })
            .flatMapLatest({ _ in
                return self.accountUseCase.firebaseAuthAnonymousLogin()
            })
            .subscribe(onNext: { [weak self] in
                    self?.isLoading.accept(false)
                    self?.createUserToFirestore()
                }, onError: { [weak self] error in
                    Logger.default.debug("++ Firebase Auth Error ++")
                    Logger.default.debug(error.localizedDescription)
                    self?.isLoading.accept(false)
            }).disposed(by: disposeBag)
    }
    
    private func createUserToFirestore() {
        isLoading.accept(true)
        accountUseCase.createUser().subscribe(onNext: { [weak self] in
            self?.isLoading.accept(false)
            self?.fetchUserSelf()
        }, onError: { [weak self] error in
            Logger.default.debug(error.localizedDescription)
            self?.isLoading.accept(false)
        }).disposed(by: disposeBag)
    }
    
    private func fetchUserSelf() {
        isLoading.accept(true)
        accountUseCase.fetchUserSelf().subscribe(onNext: { [weak self] user in
            self?.loginSuccess.accept(user)
            self?.isLoading.accept(false)
        }, onError: { [weak self] error in
            Logger.default.debug(error.localizedDescription)
            self?.isLoading.accept(false)
        }).disposed(by: disposeBag)
    }
    
}
