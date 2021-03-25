//
//  DynamicLinkGenerator.swift
//  hufy
//
//  Created by branch10480 on 2020/09/19.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import FirebaseDynamicLinks
import RxSwift

final class DynamicLinkGenerator: DynamicLinkGeneratorProtocol {
    func getInvitationLink(userId: String, todoGroupId: String) -> Single<URL?> {
        
        return Single<URL?>.create { observer -> Disposable in
            guard let link = URL(string: "https://invitation/\(userId)/\(todoGroupId)") else {
                observer(.success(nil))
                return Disposables.create()
            }
            let prefix = "https://hufy.page.link"
            let builder = DynamicLinkComponents(link: link, domainURIPrefix: prefix)
            builder?.iOSParameters = .init(bundleID: Bundle.main.bundleIdentifier ?? "")
            builder?.shorten(completion: { (url, warnings, error) in
                if let error = error {
                    observer(.failure(error))
                    return
                }
                observer(.success(url))
            })
            return Disposables.create()
        }
    }
}
