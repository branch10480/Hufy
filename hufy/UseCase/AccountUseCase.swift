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
    var myProfileImage: Observable<URL?> { get }
    var partnerProfileImage: Observable<URL?> { get }
    var userSelf: User? { get }
    var userSelfObservable: Observable<User?> { get }
    var partner: User? { get }
    var partnerObservable: Observable<User?> { get }
    var partnerAdded: Observable<Void> { get }
    var partnerRemoved: Observable<Void> { get }

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
    
    var myProfileImage: Observable<URL?> {
        gateway.myProfileImage.asObservable()
    }
    
    var partnerProfileImage: Observable<URL?> {
        gateway.partnerProfileImage.asObservable()
    }
    
    var userSelf: User? {
        gateway.userSelf.value
    }
    
    var userSelfObservable: Observable<User?> {
        gateway.userSelf.asObservable()
    }
    
    var partner: User? {
        gateway.partner.value
    }
    
    var partnerObservable: Observable<User?> {
        gateway.partner.asObservable()
    }
    
    var partnerAdded: Observable<Void> {
        gateway.partnerAdded.asObservable()
    }
    
    var partnerRemoved: Observable<Void> {
        gateway.partnerRemoved.asObservable()
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
