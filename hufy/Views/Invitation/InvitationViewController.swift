//
//  InvitationViewController.swift
//  hufy
//
//  Created by branch10480 on 2020/09/19.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InvitationViewController: BaseViewController {
    
    @IBOutlet weak var invitationMenuButton: UIButton!
    @IBOutlet weak var joinMenuButton: UIButton!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var invitationDescriptionLabel: UILabel!
    @IBOutlet weak var invitationByLineButton: BaseButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var orCenterLineView: UIView!
    
    lazy var viewModel: InvitationViewModel = .init(
        lineButtonTap: self.invitationByLineButton.rx.tap.asObservable(),
        linkGenerator: DynamicLinkGenerator(),
        accountManager: AccountManager()
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func setup() {
        super.setup()
        title = "InvitationViewController.title".localized
        invitationMenuButton.setTitle("InvitationViewController.invitationMenuButton.title".localized, for: .normal)
        joinMenuButton.setTitle("InvitationViewController.joinMenuButton.title".localized, for: .normal)
        invitationDescriptionLabel.text = "InvitationViewController.invitationDescriptionLabel.text".localized
        invitationByLineButton.setTitle("InvitationViewController.invitationByLineButton.title".localized, for: .normal)
        
        invitationByLineButton.type = .LINEDesign
        orCenterLineView.backgroundColor = .buttonCancelBackground
        orLabel.text = "OR".localized
    }
    
    private func bind() {
        viewModel.isLoading.bind { [weak self] loading in
            guard let self = self else {
                return
            }
            if loading {
                self.progressViewService.show(view: self.view)
            } else {
                self.progressViewService.dismiss(view: self.view)
            }
        }
        .disposed(by: disposeBag)
        
        viewModel.invitationQRCodeImage
            .bind(to: qrCodeImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.linkOfLineToOpen
            .observeOn(MainScheduler.instance)
            .bind { url in
                let invitationLink = url.absoluteString
                /// details: https://developers.line.biz/ja/docs/line-login/using-line-url-scheme
                guard let converted = invitationLink.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
                      let url = URL(string: "https://line.me/R/msg/text/\(converted)") else
                {
                    return
                }
                Logger.debug(url)
                UIApplication.shared.open(url, completionHandler: nil)
            }
            .disposed(by: disposeBag)
    }

}
