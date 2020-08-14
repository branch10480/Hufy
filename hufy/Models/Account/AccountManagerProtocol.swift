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
}

protocol AccountManagerProtocol {
    func isLiggedIn() -> Bool
    func firebaseAuthAnonymousLogin() -> Observable<Void>
    func createUser() -> Observable<Void>
    func fetchUserSelf() -> Observable<User>
    func registerProfileImage(image: UIImage) -> Observable<Void>
}
