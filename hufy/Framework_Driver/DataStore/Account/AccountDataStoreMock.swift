//
//  AccountDataStoreMock.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxRelay
import RxCocoa

final class AccountDataStoreMock: AccountDataStoreProtocol {

    let myProfileImage: BehaviorRelay<URL?> = .init(value: nil)
    let partnerProfileImage: BehaviorRelay<URL?> = .init(value: nil)
    let userSelf: BehaviorRelay<User?> = .init(value: nil)
    let partner: BehaviorRelay<User?> = .init(value: nil)
    let partnerAdded: PublishRelay<Void> = .init()
    let partnerRemoved: PublishRelay<Void> = .init()

    func isLoggedIn() -> Bool {
        return false
    }
    
    var cachedUserSelf: User? {
        return nil
    }
    
    func firebaseAuthAnonymousLogin() -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if true {
                    observer.onNext(())
                    observer.onCompleted()
                } else {
                    observer.onError(AccountDataStoreError.unknown)
                }
            }
            return Disposables.create()
        }
    }
    
    func createUser() -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if true {
                    observer.onNext(())
                    observer.onCompleted()
                } else {
                    observer.onError(AccountDataStoreError.unknown)
                }
            }
            return Disposables.create()
        }
    }
    
    func updateUser(user: User) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if true {
                    observer.onNext(())
                    observer.onCompleted()
                } else {
                    observer.onError(AccountDataStoreError.unknown)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchUserSelf() -> Observable<User> {
        return Observable<User>.create { observer -> Disposable in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                observer.onNext(User())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func registerProfileImage(image: UIImage) -> Observable<(Int64, Int64)> {
        return Observable<(Int64, Int64)>.create { observer in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if true {
                    observer.onNext((0, 1))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        observer.onNext((1, 1))
                        observer.onCompleted()
                    }
                } else {
                    observer.onError(AccountDataStoreError.unknown)
                }
            }
            return Disposables.create()
        }
    }
    
    func getProfileImageURL(userId: String) -> Driver<URL?> {
        return Driver<URL?>.just(nil)
    }
    
    func getTodoGroupId() -> Observable<String> {
        return Observable<String>.create { observer -> Disposable in
            observer.onNext("")
            observer.onCompleted()
            return Disposables.create()
        }
    }

    func join(partnerId: String, partnerTodoGroupId: String) -> Single<Void> {
        return Single.create { observer -> Disposable in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                observer(.success(()))
            }
            return Disposables.create()
        }
    }

    func startToListenMySelf() {
    }

    func stopListeningMySelf() {
    }
}
