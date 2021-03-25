//
//  DynamicLinkGeneratorProtocol.swift
//  hufy
//
//  Created by branch10480 on 2020/09/19.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import RxSwift

protocol DynamicLinkGeneratorProtocol {
    func getInvitationLink(userId: String, todoGroupId: String) -> Single<URL?>
}
