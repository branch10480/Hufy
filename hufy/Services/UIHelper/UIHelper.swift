//
//  UIHelper.swift
//  hufy
//
//  Created by branch10480 on 2020/09/13.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import RxSwift

final class UIHelper {
    
    static func showAlert(message: String) {
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            Logger.default.debug("UIApplication.shared.keyWindow?.rootViewController 取得失敗")
            return
        }
        let ac = UIAlertController(title: "", message: message, preferredStyle: .alert)
        ac.addAction(.init(title: "OK".localized, style: .default, handler: nil))
        vc.present(ac, animated: true, completion: nil)
    }
    
    static func showAlertObservable(message: String) -> Observable<Void> {
        return Observable.create { observer in
            if let vc = UIApplication.shared.keyWindow?.rootViewController {
                let ac = UIAlertController(title: "", message: message, preferredStyle: .alert)
                ac.addAction(.init(title: "OK".localized, style: .default, handler: { _ in
                    observer.onNext(())
                }))
                vc.present(ac, animated: true)
            }
            return Disposables.create()
        }
    }
}
