//
//  EntryViewController.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/08.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import RxSwift

class EntryViewController: BaseViewController {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private lazy var viewModel: EntryViewModel = EntryViewModel(accountManager: AccountManagerMock())

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { [weak self] in
            self?.bind()
        }
    }
    
    private func bind() {
        
        viewModel.loginState.asObservable().subscribe(onNext: { [weak self] status in
            switch status {
            case .loggedIn:
                self?.goToTop()
            case .notLoggedIn:
                self?.goToStart()
            }
            }).disposed(by: disposeBag)
    }
    
    private func goToTop() {
        let vc = TabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    private func goToStart() {
        let vc = TutorialViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
}
