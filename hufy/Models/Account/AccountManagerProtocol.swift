//
//  AccountManagerProtocol.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

enum AccountManagerError: Error {
    case unknown
    case failToGetFirebaseAuthUser
    case failToGetConvertedData
}

protocol AccountManagerProtocol {
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
    func getProfileImageURL() -> Observable<URL?>
    func getTodoGroupId() -> Observable<String>
    func join(partnerId: String, partnerTodoGroupId: String) -> Single<Void>
}
