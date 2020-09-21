//
//  AppDelegate.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/08.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import IQKeyboardManagerSwift
import FirebaseDynamicLinks
import XCGLogger
import RxSwift

typealias Logger = XCGLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var deepLinkHandleService: DeepLinkHandleServiceProtocol = DeepLinkHandleService(manager: AccountManagerMock())
    var progressViewService: ProgressViewServiceProtocol = ProgressViewService()
    var appFlowService: AppFlowServiceProtocol = AppFlowService()
    private let disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        
        RxImagePickerDelegateProxy.register { parent -> RxImagePickerDelegateProxy in
            return RxImagePickerDelegateProxy(imagePicker: parent)
            
        }
        
        IQKeyboardManager.shared.enable = true
        
        // Logger
        Logger.default.setup(
            level: .verbose,                // 出力するログレベル
            showThreadName: false,          // スレッド名表示フラグ
            showLevel: false,               // レベル表示フラグ
            showFileNames: false,           // ファイル名表示フラグ
            showLineNumbers: true,          // 行番号表示フラグ
            showDate: false                 // 日付表示フラグ
//            writeToFile: "path/to/file",    // ログファイルパス
//            fileLevel: .debug               // ファイル出力のログレベル
        )
        
        bind()
        
        return true
    }
    
    private func bind() {
        // Deep Link Handle Service
        deepLinkHandleService.isLoading.bind { [weak self] loading in
            guard let vc = UIApplication.topViewController else {
                return
            }
            if loading {
                self?.progressViewService.show(view: vc.view)
            } else {
                self?.progressViewService.dismiss(view: vc.view)
            }
        }
        .disposed(by: disposeBag)
        
        deepLinkHandleService.errorMessage
            .observeOn(MainScheduler.instance)
            .bind { message in
                UIHelper.showAlert(message: message)
            }
            .disposed(by: disposeBag)
        
        deepLinkHandleService.succeededToJoin
            .observeOn(MainScheduler.instance)
            .flatMap {
                return UIHelper.showAlertObservable(message: "SuccessMessage.Join".localized)
            }
            .bind { [weak self] in
                self?.appFlowService.relaunch()
            }
            .disposed(by: disposeBag)
    }

    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { [weak self] (dynamiclink, error) in
            if let error = error {
                Logger.default.debug(error)
                return
            }
            self?.deepLinkHandleService.handle(deepLink: dynamiclink?.url)
        }

        return handled
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            deepLinkHandleService.handle(deepLink: dynamicLink.url)
            return true
        }
        return false
    }


}

