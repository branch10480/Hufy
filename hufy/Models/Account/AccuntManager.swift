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
import RxRelay
import FirebaseStorage

final class AccountManager: AccountManagerProtocol {
    
    var userSelf: BehaviorRelay<User?> = .init(value: nil)
    private lazy var db = Firestore.firestore()
    private lazy var userDB = self.db.userRef

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
            Logger.default.debug(user.dictionary)
            
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
    
    func updateUser(user: User) -> Observable<Void> {
        return Observable<Void>.create { observer in
            
            // Request Firestore update
            let userRef = self.userDB.document(user.id)
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
                observer.onError(AccountManagerError.failToGetFirebaseAuthUser)
                return Disposables.create()
            }
            
            self.userDB.document(authUser.uid).getDocument { [weak self] (snapshot, error) in
                guard let self = self else { return }
                if let error = error {
                    observer.onError(error)
                    return
                }
                if let data = snapshot?.data(), let user = User(JSON: data) {
                    self.userSelf.accept(user)
                    observer.onNext(user)
                    observer.onCompleted()
                } else {
                    observer.onError(AccountManagerError.failToGetFirebaseAuthUser)
                }
            }
            return Disposables.create()
        }
    }

    // (Int64, Int64): (completedUnitCount, totalUnitCount)
    func registerProfileImage(image: UIImage) -> Observable<(Int64, Int64)> {
        return Observable<(Int64, Int64)>.create { observer in
            guard let currentUser = Auth.auth().currentUser else {
                observer.onError(AccountManagerError.failToGetFirebaseAuthUser)
                return Disposables.create()
            }
            guard let data = image.jpegData(compressionQuality: 0.8) else {
                observer.onError(AccountManagerError.failToGetConvertedData)
                return Disposables.create()
            }
            let profileImageRef = Storage.storage().reference().child(currentUser.uid + "/myProfileImage.jpg")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = profileImageRef.putData(data, metadata: metadata) { metadata, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
            }
//            uploadTask.observe(.progress) { snapshot in
//                guard let progress = snapshot.progress else {
//                    observer.onError(AccountManagerError.unknown)
//                    return
//                }
//                let completedUnitCount = progress.completedUnitCount
//                let totalUnitCount = progress.totalUnitCount
//                observer.onNext((completedUnitCount, totalUnitCount))
//                if totalUnitCount == completedUnitCount {
//                    observer.onCompleted()
//                }
//            }
            uploadTask.observe(.success) { snapshot in
                guard let progress = snapshot.progress else {
                    observer.onError(AccountManagerError.unknown)
                    return
                }
                let completedUnitCount = progress.completedUnitCount
                let totalUnitCount = progress.totalUnitCount
                observer.onNext((completedUnitCount, totalUnitCount))
                if totalUnitCount == completedUnitCount {
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func getProfileImageURL() -> Observable<URL?> {
        return Observable<URL?>.create { observer in
            guard let currentUser = Auth.auth().currentUser else {
                observer.onError(AccountManagerError.failToGetFirebaseAuthUser)
                return Disposables.create()
            }
            let profileImageRef = Storage.storage().reference().child(currentUser.uid + "/myProfileImage.jpg")
            profileImageRef.downloadURL(completion: { url, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                observer.onNext(url)
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    func getTodoGroupId() -> Observable<String> {
        return Observable<String>.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let authUser = Auth.auth().currentUser else
            {
                observer.onError(AccountManagerError.failToGetFirebaseAuthUser)
                return Disposables.create()
            }
            
            self.userDB.document(authUser.uid).getDocument { [weak self] (snapshot, error) in
                guard let self = self else { return }
                if let error = error {
                    observer.onError(error)
                    return
                }
                if let data = snapshot?.data(), let user = User(JSON: data) {
                    self.userSelf.accept(user)
                    observer.onNext(user.belongingGroupId)
                    observer.onCompleted()
                } else {
                    observer.onError(AccountManagerError.failToGetFirebaseAuthUser)
                }
            }
            return Disposables.create()
        }
    }

    func join(partnerId: String, partnerTodoGroupId: String) -> Single<Void> {
        return Single<Void>.create { [weak self] observer -> Disposable in
            
            guard let self = self,
                  let myId = self.userSelf.value?.id else
            {
                observer(.error(AccountManagerError.unknown))
                return Disposables.create()
            }
            
            let batch = self.db.batch()
            
            // 自分にパートナーのID、新しいTODOグループIDを登録
            let myRef = self.db.document(myId)
            batch.updateData([
                "partnerId": partnerId,
                "belongingGroupId": partnerTodoGroupId
            ], forDocument: myRef)
            
            // パートナーに自分のユーザーIDをパートナーIDとして登録する
            let partnerRef = self.db.document(partnerId)
            batch.updateData([
                "partnerId": myId
            ], forDocument: partnerRef)
            
            // バッチ書き込み
            batch.commit { error in
                if let error = error {
                    observer(.error(error))
                    return
                }
                observer(.success(()))
            }

            return Disposables.create()
        }
    }
}

fileprivate extension Firestore {
    var userRef: CollectionReference {
        return self.collection("users")
    }
}
