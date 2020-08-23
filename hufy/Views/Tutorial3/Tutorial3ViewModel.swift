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
    let nextButtonIsEnabled: Observable<Bool>
    let userUpdateSuccess: BehaviorRelay<Bool> = .init(value: false)
    private let manager: AccountManagerProtocol
    
    init(
        manager: AccountManagerProtocol,
        profileImageUrl: URL?,
        nameTextObservable: Observable<String>,
        nextButtonTap: Observable<Void>
    ) {
        self.manager = manager
        self.profileImageURL.accept(profileImageUrl)
        
        self.nextButtonIsEnabled = nameTextObservable.map({ text in
            return 0 < text.count && text.count < 20
        })
        
        super.init()
        
        // この画面から始まった場合用に
        // プロフィール写真URLをフェッチ
        if profileImageURL.value == nil {
            manager.getProfileImageURL()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] url in
                    guard let self = self else { return }
                    self.profileImageURL.accept(url)
                }).disposed(by: self.disposeBag)
        }
        
        let fetchUser: Observable<User> = nextButtonTap.flatMapLatest { _ in
            return manager.fetchUserSelf()
        }
        fetchUser
            .withLatestFrom(nameTextObservable, resultSelector: { ($0, $1) })
            .do(onNext: { [weak self] _, _ in
                self?.isLoading.accept(true)
            }).flatMapLatest { (user, text) -> Observable<Void> in
                var user = user
                user.name = text
                user.tutorial3Done = true
                return manager.updateUser(user: user)
            }.subscribe(onNext: { [weak self] _ in
                // 成功！
                self?.isLoading.accept(false)
                self?.userUpdateSuccess.accept(true)
            }, onError: { [weak self] error in
                print(error.localizedDescription)
                self?.isLoading.accept(false)
            }).disposed(by: disposeBag)
    }
    
    private func setTutorial3Done() {
        manager.fetchUserSelf().flatMapLatest { [weak self] user -> Observable<Void> in
            guard let self = self else {
                return Observable<Void>.create { observer -> Disposable in
                    observer.onError(AccountManagerError.unknown)
                    return Disposables.create()
                }
            }
            var user = user
            user.tutorial3Done = true
            return self.manager.updateUser(user: user)
        }.subscribe().disposed(by: disposeBag)
    }
}
