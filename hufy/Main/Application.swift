//
//  Application.swift
//  hufy
//
//  Created by branch10480 on 2021/03/25.
//  Copyright © 2021 Toshiharu Imaeda. All rights reserved.
//

import UIKit

final class Application {
    
    static let shared = Application()
    private init() {}
    
    // AccountUseCase を公開プロパティとして保持
    private(set) var accountUseCase: AccountUseCaseProtocol!
    // DeepLinkHandleUseCase を公開プロパティとして保持
    private(set) var deepLinkHandleUseCase: DeepLinkHandleUseCaseProtocol!
    
    func configure(with window: UIWindow) {
        buildLayer()
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        window.rootViewController = sb.instantiateInitialViewController()
    }
    
    private func buildLayer() {
        
    }
    
    func relaunch() {
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        let vc = EntryViewController()
        keyWindow.rootViewController = vc
    }
}
