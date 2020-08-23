//
//  AccountManagerMock.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift

final class AccountManagerMock: AccountManagerProtocol {

    static private var userSelf: User?

    func isLiggedIn() -> Bool {
        return false
    }
    
    func firebaseAuthAnonymousLogin() -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if true {
                    observer.onNext(())
                    observer.onCompleted()
                } else {
                    observer.onError(AccountManagerError.unknown)
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
                    observer.onError(AccountManagerError.unknown)
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
                    observer.onError(AccountManagerError.unknown)
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
                    observer.onError(AccountManagerError.unknown)
                }
            }
            return Disposables.create()
        }
    }
    
    func getProfileImageURL() -> Observable<URL?> {
        return Observable<URL?>.create { observer -> Disposable in
            observer.onNext(URL(string: ""))
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
