//
//  QRCodeReaderViewController.swift
//  hufy
//
//  Created by branch10480 on 2020/10/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import MercariQRScanner
import SnapKit

final class QRCodeReaderViewController: BaseViewController {
    
    var didSuccess: ((String) -> Void)?
    var didFailure: ((Error) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setup() {
        super.setup()
        
        navigationItem.title = "QRCodeReaderViewController.title".localized
        if #available(iOS 13.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButton(sender:)))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapCloseButton(sender:)))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            let readerView = QRScannerView(frame: self.view.bounds)
            readerView.configure(delegate: self)
            readerView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(readerView)
            readerView.snp.makeConstraints { maker in
                maker.edges.equalToSuperview()
            }
            readerView.startRunning()
        }
    }
    
    @objc private func didTapCloseButton(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - QRScannerViewDelegate
extension QRCodeReaderViewController: QRScannerViewDelegate {

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        didSuccess?(code)
    }
    
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        didFailure?(error)
    }
}
