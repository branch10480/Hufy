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
    
    private lazy var viewModel: EntryViewModel = EntryViewModel(accountManager: AccountManager.shared)

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
        
        viewModel.accountState.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] status in
                switch status {
                case .notCreated:
                    self?.goToTutorial1()
                case .tutorial1Done:
                    self?.goToTutorial2()
                case .tutorial2Done:
                    self?.goToTutorial3()
                case .tutorial3Done:
                    self?.goToTop()
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func goToTop() {
        let vc = TabBarViewController()
        let nc = MyNavigationController(rootViewController: vc)
        nc.setNavigationBarHidden(true, animated: false)
        nc.modalPresentationStyle = .fullScreen
        nc.modalTransitionStyle = .crossDissolve
        present(nc, animated: true, completion: nil)
    }
    
    private func goToTutorial1() {
        let vc = TutorialViewController()
        let nc = MyNavigationController(rootViewController: vc)
        nc.setNavigationBarHidden(true, animated: false)
        nc.modalPresentationStyle = .fullScreen
        nc.modalTransitionStyle = .crossDissolve
        present(nc, animated: true, completion: nil)
    }
    
    private func goToTutorial2() {
        let vc = Tutorial2ViewController()
        let nc = MyNavigationController(rootViewController: vc)
        nc.setNavigationBarHidden(true, animated: false)
        nc.modalPresentationStyle = .fullScreen
        nc.modalTransitionStyle = .crossDissolve
        present(nc, animated: true, completion: nil)
    }
    
    private func goToTutorial3() {
        let vc = Tutorial3ViewController()
        let nc = MyNavigationController(rootViewController: vc)
        nc.setNavigationBarHidden(true, animated: false)
        nc.modalPresentationStyle = .fullScreen
        nc.modalTransitionStyle = .crossDissolve
        present(nc, animated: true, completion: nil)
    }
}
