//
//  QRCodeReader.swift
//  hufy
//
//  Created by branch10480 on 2020/10/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MercariQRScanner

protocol QRCodeReaderProtocol {
    func getReaderObservable(showFrom: UIViewController) -> Single<String>
}

final class QRCodeReader: QRCodeReaderProtocol {
    let disposeBag = DisposeBag()
    
    func getReaderObservable(showFrom: UIViewController) -> Single<String> {
        return Single<String>.create { observer -> Disposable in
            let readerVC = QRCodeReaderViewController()
            readerVC.didSuccess = { [weak readerVC] code in
                readerVC?.dismiss(animated: true) {
                    observer(.success(code))
                }
            }
            readerVC.didFailure = { error in
                UIHelper.showAlert(message: error.localizedDescription)
            }
            let nc = MyNavigationController(rootViewController: readerVC)
            showFrom.present(nc, animated: true, completion: nil)
            return Disposables.create()
        }
    }
}
