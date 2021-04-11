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
    
    /// 各レイヤー（ドメイン）の組み立てを行う
    private func buildLayer() {
        // -- Use Case --
        let accountUseCase = AccountUseCase()
        let deepLinkHandleUseCase = DeepLinkHandleUseCase()
        
        // -- Interface Adapter --
        let accountGateway = AccountGateway()
        
        // Use Case と Interface Adapter とのバインド
        accountUseCase.gateway = accountGateway
        deepLinkHandleUseCase.accountGateway = accountGateway
        
        // -- Framework Driver --
        let accountDataStore = AccountDataStore.shared
        
        // Interface Driver と Framework Driver とのバインド
        accountGateway.dataStore = accountDataStore
        
        self.accountUseCase = accountUseCase
        self.deepLinkHandleUseCase = deepLinkHandleUseCase
    }
    
    func relaunch() {
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        let vc = EntryViewController()
        keyWindow.rootViewController = vc
    }
}
