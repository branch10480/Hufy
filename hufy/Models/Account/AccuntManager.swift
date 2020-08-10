//
//  AccuntManager.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import RxSwift

final class AccountManager: AccountManagerProtocol {
    
    static private var userSelf: User?
    private let userDB = Firestore.firestore().collection("users")

    func isLiggedIn() -> Bool {
        if let _ = Auth.auth().currentUser {
            return true
        } else {
            return false
        }
    }
    
    func firebaseAuthAnonymousLogin() -> Observable<Void> {
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
    
    func createUser() -> Observable<Void> {
        return Observable.create { [weak self] observer -> Disposable in
            
            guard let self = self,
                  let authUser = Auth.auth().currentUser else
            {
                observer.onError(AccountManagerError.failToGetFirebaseAuthUser)
                return Disposables.create()
            }
            var user = User()
            user.id = authUser.uid
            print(user.dictionary)
            
            let userRef = self.userDB.document(authUser.uid)
            userRef.setData(user.dictionary, merge: true) { error in
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
    
    func fetchUserSelf() -> Observable<User> {
        return Observable<User>.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let authUser = Auth.auth().currentUser else
            {
                return Disposables.create()
            }
            
            self.userDB.document(authUser.uid).getDocument { (snapshot, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                if let data = snapshot?.data(), let user = User(JSON: data) {
                    AccountManager.userSelf = user
                    observer.onNext(user)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
