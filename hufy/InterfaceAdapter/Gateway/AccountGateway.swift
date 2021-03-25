//
//  AccountGateway.swift
//  hufy
//
//  Created by branch10480 on 2021/03/25.
//  Copyright © 2021 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

protocol AccountGatewayProtocol {
    var myProfileImage: BehaviorRelay<URL?> { get }
    var partnerProfileImage: BehaviorRelay<URL?> { get }
    var userSelf: BehaviorRelay<User?> { get }
    var partner: BehaviorRelay<User?> { get }
    var partnerAdded: PublishRelay<Void> { get }
    var partnerRemoved: PublishRelay<Void> { get }

    func isLoggedIn() -> Bool
    func firebaseAuthAnonymousLogin() -> Observable<Void>
    func createUser() -> Observable<Void>
    func updateUser(user: User) -> Observable<Void>
    func fetchUserSelf() -> Observable<User>
    func registerProfileImage(image: UIImage) -> Observable<(Int64, Int64)>
    func getProfileImageURL(userId: String) -> Driver<URL?>
    func getTodoGroupId() -> Observable<String>
    func join(partnerId: String, partnerTodoGroupId: String) -> Single<Void>
    func startToListenMySelf()
    func stopListeningMySelf()
}

final class AccountGateway: AccountGatewayProtocol {

    var dataStore: AccountDataStoreProtocol!
    
    var myProfileImage: BehaviorRelay<URL?> {
        dataStore.myProfileImage
    }
    
    var partnerProfileImage: BehaviorRelay<URL?> {
        dataStore.partnerProfileImage
    }
    
    var userSelf: BehaviorRelay<User?> {
        dataStore.userSelf
    }
    
    var partner: BehaviorRelay<User?> {
        dataStore.partner
    }
    
    var partnerAdded: PublishRelay<Void> {
        dataStore.partnerAdded
    }
    
    var partnerRemoved: PublishRelay<Void> {
        dataStore.partnerRemoved
    }
    
    func isLoggedIn() -> Bool {
        dataStore.isLoggedIn()
    }
    
    func firebaseAuthAnonymousLogin() -> Observable<Void> {
        return dataStore.firebaseAuthAnonymousLogin()
    }
    
    func createUser() -> Observable<Void> {
        return dataStore.createUser()
    }
    
    func updateUser(user: User) -> Observable<Void> {
        return dataStore.updateUser(user: user)
    }
    
    func fetchUserSelf() -> Observable<User> {
        return dataStore.fetchUserSelf()
    }
    
    func registerProfileImage(image: UIImage) -> Observable<(Int64, Int64)> {
        return dataStore.registerProfileImage(image: image)
    }
    
    func getProfileImageURL(userId: String) -> Driver<URL?> {
        return dataStore.getProfileImageURL(userId: userId)
    }
    
    func getTodoGroupId() -> Observable<String> {
        return dataStore.getTodoGroupId()
    }
    
    func join(partnerId: String, partnerTodoGroupId: String) -> Single<Void> {
        return dataStore.join(partnerId: partnerId, partnerTodoGroupId: partnerTodoGroupId)
    }
    
    func startToListenMySelf() {
        return dataStore.startToListenMySelf()
    }
    
    func stopListeningMySelf() {
        return dataStore.stopListeningMySelf()
    }
    
}
