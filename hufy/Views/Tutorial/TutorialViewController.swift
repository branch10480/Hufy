//
//  TutorialViewController.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TutorialViewController: BaseViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    private lazy var viewModel: TutorialViewModel = TutorialViewModel(
        tapObservable: self.startButton.rx.tap.asObservable(),
        manager: AccountManager()
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func setup() {
        super.setup()
        
        startButton.setDefaultDesign(radius: .buttonHeight / 2)
        startButton.setTitle("TutorialVC.button.title".localized, for: .normal)
        
        titleLabel.text = "AppName".localized
        titleLabel.font = UIFont(name: Constant.FontName.pacifico, size: 40)
        titleLabel.textColor = .headerText
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: .textSize)
        descriptionLabel.text = "TutorialVC.description".localized
        
        imageView.image = UIImage(named: "tutorial")
    }
    
    private func bind() {
        
        viewModel.isLoading.asDriver().drive(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.progressViewService.show(view: self.view)
            } else {
                self.progressViewService.dismiss(view: self.view)
            }
        }).disposed(by: disposeBag)
        
        viewModel.loginSuccess.asDriver().drive(onNext: { [weak self] user in
            guard let user = user else {
                return
            }
            dump(user)
            self?.goToTutorial2()
        }).disposed(by: disposeBag)
    }
    
    private func goToTutorial2() {
        let vc = Tutorial2ViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}
