//
//  Tutorial3ViewController.swift
//  hufy
//
//  Created by branch10480 on 2020/08/16.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class Tutorial3ViewController: BaseViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!

    lazy var viewModel: Tutorial3ViewModel = Tutorial3ViewModel(
        manager: AccountManager()
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func setup() {
        super.setup()
        title = "Tutorial3VC.title".localized
    }
    
    private func bind() {
        viewModel.profileImageURL
        .subscribe(onNext: { [weak self] url in
            self?.profileImageView.kf.setImage(with: url)
        }).disposed(by: disposeBag)
    }

}
