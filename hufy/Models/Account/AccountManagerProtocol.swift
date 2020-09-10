//
//  AccountManagerProtocol.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import RxSwift

enum AccountManagerError: Error {
    case unknown
    case failToGetFirebaseAuthUser
    case failToGetConvertedData
}

protocol AccountManagerProtocol {
    func isLiggedIn() -> Bool
    func firebaseAuthAnonymousLogin() -> Observable<Void>
    func createUser() -> Observable<Void>
    func updateUser(user: User) -> Observable<Void>
    func fetchUserSelf() -> Observable<User>
    func registerProfileImage(image: UIImage) -> Observable<(Int64, Int64)>
    func getProfileImageURL() -> Observable<URL?>
    func getTodoGroupId() -> Observable<String>
    func invite(partnerId: String) -> Observable<Void>
}
