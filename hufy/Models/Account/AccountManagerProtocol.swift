//
//  AccountManagerProtocol.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import RxSwift

enum AccountManagerError: Error {
    case unknown
}

protocol AccountManagerProtocol {
    func isLiggedIn() -> Bool
    func login() -> Observable<Void>
}
