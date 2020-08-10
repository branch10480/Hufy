//
//  AccuntManager.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift

final class AccountManager: AccountManagerProtocol {

    func isLiggedIn() -> Bool {
        if let _ = Auth.auth().currentUser {
            return true
        } else {
            return false
        }
    }
    
    func login() -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            Auth.auth().signInAnonymously { (authResult, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(())
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
