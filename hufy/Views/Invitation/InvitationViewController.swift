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
    
    lazy var viewModel: InvitationViewModel = .init(
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
    }

}
