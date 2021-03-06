//
//  AccountDataStore.swift
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
import RxCocoa
import FirebaseStorage

final class AccountDataStore: AccountDataStoreProtocol {

    static let shared: AccountDataStoreProtocol = AccountDataStore()
    private var userSelfListener: ListenerRegistration?

    private init() {

        userSelf.asObservable()
            .flatMap { [weak self] user -> Observable<URL?> in
                guard let self = self, let userId = user?.id else {
                    return Observable.just(nil)
                }
                return self.getProfileImageURL(userId: userId).asObservable()
            }
            .bind { [weak self] url in
                self?.myProfileImage.accept(url)
            }
            .disposed(by: disposeBag)

        partner.asObservable()
            .flatMap { [weak self] user -> Observable<URL?> in
                guard let self = self, let userId = user?.id else {
                    return Observable.just(nil)
                }
                return self.getProfileImageURL(userId: userId).asObservable()
            }
            .bind { [weak self] url in
                self?.partnerProfileImage.accept(url)
            }
            .disposed(by: disposeBag)
    }

    let disposeBag = DisposeBag()
    let myProfileImage: BehaviorRelay<URL?> = .init(value: nil)
    let partnerProfileImage: BehaviorRelay<URL?> = .init(value: nil)
    let userSelf: BehaviorRelay<User?> = .init(value: nil)
    let partner: BehaviorRelay<User?> = .init(value: nil)
    let partnerAdded: PublishRelay<Void> = .init()
    let partnerRemoved: PublishRelay<Void> = .init()

    private lazy var db = Firestore.firestore()
    private lazy var userDB = self.db.userRef

    func isLoggedIn() -> Bool {
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
                observer.onError(AccountDataStoreError.failToGetFirebaseAuthUser)
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
                observer.onError(AccountDataStoreError.failToGetFirebaseAuthUser)
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
                    observer.onError(AccountDataStoreError.failToGetFirebaseAuthUser)
                }
            }
            return Disposables.create()
        }
    }

    // (Int64, Int64): (completedUnitCount, totalUnitCount)
    func registerProfileImage(image: UIImage) -> Observable<(Int64, Int64)> {
        return Observable<(Int64, Int64)>.create { observer in
            guard let currentUser = Auth.auth().currentUser else {
                observer.onError(AccountDataStoreError.failToGetFirebaseAuthUser)
                return Disposables.create()
            }
            guard let data = image.jpegData(compressionQuality: 0.8) else {
                observer.onError(AccountDataStoreError.failToGetConvertedData)
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
                    observer.onError(AccountDataStoreError.unknown)
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
    
    func getProfileImageURL(userId: String) -> Driver<URL?> {
        return Observable<URL?>.create { observer in
            let profileImageRef = Storage.storage().reference().child(userId + "/myProfileImage.jpg")
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
        .asDriver(onErrorJustReturn: nil)
    }
    
    func getTodoGroupId() -> Observable<String> {
        return Observable<String>.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let authUser = Auth.auth().currentUser else
            {
                observer.onError(AccountDataStoreError.failToGetFirebaseAuthUser)
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
                    observer.onError(AccountDataStoreError.failToGetFirebaseAuthUser)
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
                observer(.failure(AccountDataStoreError.unknown))
                return Disposables.create()
            }
            
            let batch = self.db.batch()
            
            // 自分にパートナーのID、新しいTODOグループIDを登録
            let myRef = self.userDB.document(myId)
            batch.updateData([
                "partnerId": partnerId,
                "belongingGroupId": partnerTodoGroupId
            ], forDocument: myRef)
            
            // パートナーに自分のユーザーIDをパートナーIDとして登録する
            let partnerRef = self.userDB.document(partnerId)
            batch.updateData([
                "partnerId": myId
            ], forDocument: partnerRef)
            
            // バッチ書き込み
            batch.commit { error in
                if let error = error {
                    observer(.failure(error))
                    return
                }
                observer(.success(()))
            }

            return Disposables.create()
        }
    }

    func startToListenMySelf() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let userRef = self.userDB.document(uid)
        self.userSelfListener = userRef.addSnapshotListener { (v: DocumentSnapshot?, error: Error?) in
            guard let snapShot = v else {
                Logger.debug(error?.localizedDescription ?? "")
                return
            }
            guard let userDic = snapShot.data(), let user = User(JSON: userDic) else {
                Logger.debug("Document is empty.")
                return
            }
            Logger.debug("Partner ID is \(user.partnerId ?? "")")











        }
    }

    func stopListeningMySelf() {
        userSelfListener?.remove()
    }
}

fileprivate extension Firestore {
    var userRef: CollectionReference {
        return self.collection("users")
    }
}
