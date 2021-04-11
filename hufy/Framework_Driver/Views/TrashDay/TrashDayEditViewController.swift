//
//  TrashDayEditViewController.swift
//  hufy
//
//  Created by branch10480 on 2020/10/11.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class TrashDayEditViewController: BaseViewController {
    
    @IBOutlet weak var switchDescriptionLabel: UILabel!
    @IBOutlet weak var switchOfEdition: UISwitch!
    @IBOutlet weak var whatTrashDayLabel: UILabel!
    @IBOutlet weak var whatTrashDayTextField: UITextField!
    @IBOutlet weak var inChargeOfLabel: UILabel!
    @IBOutlet weak var inChargeOfMeButton: UIButton!
    @IBOutlet weak var inChargeOfMeImageView: UIImageView!
    @IBOutlet weak var inChargeOfPartnerButton: UIButton!
    @IBOutlet weak var inChargeOfPartnerImageView: UIImageView!
    @IBOutlet weak var invitationButton: UIButton!
    @IBOutlet weak var remarkTitleLabel: UILabel!
    @IBOutlet weak var remarkTextView: UITextView!
    @IBOutlet weak var registrationButton: BaseButton!
    @IBOutlet weak var middleContentsStackView: UIStackView!
    @IBOutlet weak var inChargeOfStackView: UIStackView!
    @IBOutlet weak var viewOfMe: UIView!
    @IBOutlet weak var viewOfMyPartner: UIView!
    @IBOutlet weak var viewOfInvitation: UIView!
    @IBOutlet var plusViews: [UIView]!

    var trashDay: TrashDay!

    private let accountUseCase: AccountUseCaseProtocol = Application.shared.accountUseCase
    private lazy var viewModel = TrashDayEditViewModel(
        trashDay: self.trashDay,
        switchDidChange: self.switchOfEdition.rx.controlEvent(.valueChanged).withLatestFrom(self.switchOfEdition.rx.value).asObservable(),
        viewOfMeTap: inChargeOfMeButton.rx.tap.asObservable(),
        viewOfPartnerTap: inChargeOfPartnerButton.rx.tap.asObservable(),
        titleTextInput: whatTrashDayTextField.rx.text.asObservable(),
        remarkTextInput: remarkTextView.rx.text.asObservable(),
        accountUseCase: accountUseCase,
        registrationButtonTap: registrationButton.rx.tap.asObservable(),
        trashDayUseCase: TrashDayUseCase.shared
    )

    private enum Color {
        enum border {
            static let normal = UIColor.other2
            static let selected = UIColor.buttonBackground
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func setup() {
        super.setup()
        title = trashDay.dayType?.longTitle
        middleContentsStackView.isHidden = true
        switchDescriptionLabel.text = "TrashDayEditViewController.switchDescriptionLabel.text".localized
        whatTrashDayLabel.text = "TrashDayEditViewController.whatTrashDayLabel.text".localized
        inChargeOfLabel.text = "TrashDayEditViewController.inChargeOfLabel.text".localized
        remarkTitleLabel.text = "TrashDayEditViewController.remarkTitleLabel.text".localized
        registrationButton.setTitle("TrashDayEditViewController.registrationButton.title".localized, for: .normal)

        registrationButton.type = .defaultDesign
        whatTrashDayTextField.superview?.design.textField()
        whatTrashDayTextField.setup(placeholder: "TrashDayEditViewController.whatTrashDayTextField.placeholder".localized)
        remarkTextView.superview?.design.textField()

        plusViews.forEach { view in
            view.backgroundColor = .lightGray
        }

        inChargeOfStackView.arrangedSubviews.forEach { view in
            view.isHidden = true
            view.layer.cornerRadius = 40
            view.layer.borderWidth = 3
            view.layer.borderColor = UIColor.other2.cgColor
        }
    }

    private func bind() {

        viewModel.isTrashDay
            .bind(to: switchOfEdition.rx.isOn)
            .disposed(by: disposeBag)

        viewModel.isTrashDay.bind { [weak self] isTrashDay in
            UIView.animate(withDuration: 0.25) {
                self?.switchOfEdition.isOn = isTrashDay
                self?.middleContentsStackView.alpha = isTrashDay ? 1 : 0
                self?.middleContentsStackView.isHidden = !isTrashDay
            }
        }
        .disposed(by: disposeBag)

        viewModel.trashDay
            .asObservable()
            .withLatestFrom(
                viewModel.userInfo,
                resultSelector: { trashDay, userInfo in
                    return (trashDay, userInfo.userSelf, userInfo.partner)
                }
            ).bind { [weak self] trashDay, userSelf, partner in
                guard let self = self else { return }
                self.whatTrashDayTextField.text = trashDay.title
                self.remarkTextView.text = trashDay.remark
                self.applyInChargeOfView(day: trashDay)
            }
            .disposed(by: disposeBag)

        viewModel.trashDay.bind { [weak self] day in
            guard let self = self else { return }
            self.whatTrashDayTextField.text = day.title
            self.remarkTextView.text = day.remark
        }
        .disposed(by: disposeBag)

        accountUseCase.myProfileImage
            .bind { [weak self] url in
                self?.inChargeOfMeImageView.kf.setImage(with: url)
            }
            .disposed(by: disposeBag)

        accountUseCase.partnerProfileImage
            .bind { [weak self] url in
                self?.inChargeOfPartnerImageView.kf.setImage(with: url)
            }
            .disposed(by: disposeBag)

        invitationButton.rx.tap
            .bind { [weak self] in
                self?.showInvitationView()
            }
            .disposed(by: disposeBag)

        viewModel.finishSaving
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

    private func applyInChargeOfView(day: TrashDay) {
        guard let userSelf = accountUseCase.userSelf else {
            return
        }
        let partner = accountUseCase.partner
        viewOfMyPartner.isHidden = true
        viewOfInvitation.isHidden = true
        if userSelf.hasPartner {
            viewOfMyPartner.isHidden = false
        } else {
            viewOfInvitation.isHidden = false
        }
        viewOfMe.isHidden = false

        // who is in charge of
        viewOfMe.layer.borderColor = Color.border.normal.cgColor
        viewOfMyPartner.layer.borderColor = Color.border.normal.cgColor
        if let partnerId = partner?.id, !partnerId.isEmpty, day.inChargeOf == partnerId {
            viewOfMyPartner.layer.borderColor = Color.border.selected.cgColor
        } else if !userSelf.id.isEmpty, day.inChargeOf == userSelf.id {
            viewOfMe.layer.borderColor = Color.border.selected.cgColor
        }
    }

    private func showInvitationView() {
        let vc = InvitationViewController()
        let nc = MyNavigationController(rootViewController: vc)
        let closeButtonItem = UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: #selector(didTapClose(_:)))
        closeButtonItem.tintColor = .buttonText
        vc.navigationItem.leftBarButtonItem = closeButtonItem
        present(nc, animated: true)
    }

    @objc private func didTapClose(_ item: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
