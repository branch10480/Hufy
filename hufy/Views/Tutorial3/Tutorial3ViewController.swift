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
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nextButton: BaseButton!
    
    var profileImageURL: URL?
    let nameText: BehaviorRelay<String> = .init(value: "")

    lazy var viewModel: Tutorial3ViewModel = Tutorial3ViewModel(
        manager: AccountManager.shared,
        profileImageUrl: self.profileImageURL,
        nameTextObservable: nameText.asObservable(),
        nextButtonTap: nextButton.rx.tap.asObservable()
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func setup() {
        super.setup()
        title = "Tutorial3VC.title".localized
        nextButton.type = .defaultDesign
        nextButton.setTitle("Tutorial3VC.nextButton.title".localized, for: .normal)
        nameLabel.text = "Tutorial3VC.nameLabel.text".localized
        setProfileImageDesign(view: mainImageView)
        
        // About TextField
        nameTextField.superview?.design.textField()
        nameTextField.setup(placeholder: "Tutorial3VC.nameTextField.placeholder".localized)
        nameTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self, !self.nameTextField.isEditing else { return }
            let trimmedText = String(text.prefix(20))
            self.nameTextField.text = trimmedText
            self.nameText.accept(trimmedText)
        }).disposed(by: disposeBag)
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
        
        viewModel.profileImageURL
            .subscribe(onNext: { [weak self] url in
                self?.mainImageView.kf.setImage(with: url)
            }).disposed(by: disposeBag)
        
        viewModel.nextButtonIsEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.userUpdateSuccess.subscribe(onNext: { [weak self] result in
            guard result else { return }
            let vc = TabBarViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .flipHorizontal
            self?.present(vc, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    
    private func setProfileImageDesign(view: UIView) {
        let screenSize = UIScreen.main.bounds
        view.layer.cornerRadius = screenSize.width / 3 / 2
        view.layer.borderWidth = 3
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.other2.cgColor
    }

}
