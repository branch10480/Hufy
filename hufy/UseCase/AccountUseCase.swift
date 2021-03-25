//
//  AccountUseCase.swift
//  hufy
//
//  Created by branch10480 on 2021/03/25.
//  Copyright © 2021 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

protocol AccountUseCaseProtocol {
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

final class AccountUseCase: AccountUseCaseProtocol {
    
    var gateway: AccountGatewayProtocol!
    
    var myProfileImage: BehaviorRelay<URL?> {
        gateway.myProfileImage
    }
    
    var partnerProfileImage: BehaviorRelay<URL?> {
        gateway.partnerProfileImage
    }
    
    var userSelf: BehaviorRelay<User?> {
        gateway.userSelf
    }
    
    var partner: BehaviorRelay<User?> {
        gateway.partner
    }
    
    var partnerAdded: PublishRelay<Void> {
        gateway.partnerAdded
    }
    
    var partnerRemoved: PublishRelay<Void> {
        gateway.partnerRemoved
    }
    
    func isLoggedIn() -> Bool {
        gateway.isLoggedIn()
    }
    
    func firebaseAuthAnonymousLogin() -> Observable<Void> {
        return gateway.firebaseAuthAnonymousLogin()
    }
    
    func createUser() -> Observable<Void> {
        return gateway.createUser()
    }
    
    func updateUser(user: User) -> Observable<Void> {
        return gateway.updateUser(user: user)
    }
    
    func fetchUserSelf() -> Observable<User> {
        return gateway.fetchUserSelf()
    }
    
    func registerProfileImage(image: UIImage) -> Observable<(Int64, Int64)> {
        return gateway.registerProfileImage(image: image)
    }
    
    func getProfileImageURL(userId: String) -> Driver<URL?> {
        return gateway.getProfileImageURL(userId: userId)
    }
    
    func getTodoGroupId() -> Observable<String> {
        return gateway.getTodoGroupId()
    }
    
    func join(partnerId: String, partnerTodoGroupId: String) -> Single<Void> {
        return gateway.join(partnerId: partnerId, partnerTodoGroupId: partnerTodoGroupId)
    }
    
    func startToListenMySelf() {
        return gateway.startToListenMySelf()
    }
    
    func stopListeningMySelf() {
        return gateway.stopListeningMySelf()
    }
}
