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

    func isLiggedIn() -> Bool {
        return false
    }
    
    func login() -> Observable<Void> {
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
}
