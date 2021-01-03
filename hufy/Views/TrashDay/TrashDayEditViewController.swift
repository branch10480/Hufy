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
    
    private let accountManager: AccountManagerProtocol = AccountManager.shared
    private lazy var viewModel = TrashDayEditViewModel(
        trashDay: self.trashDay,
        switchDidChange: self.switchOfEdition.rx.controlEvent(.valueChanged).withLatestFrom(self.switchOfEdition.rx.value).asObservable(),
        accountManager: AccountManager.shared,
        registrationButtonTap: registrationButton.rx.tap.asObservable()
)

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
            view.layer.borderWidth = 2
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

        accountManager.myProfileImage
            .bind { [weak self] url in
                self?.inChargeOfMeImageView.kf.setImage(with: url)
            }
            .disposed(by: disposeBag)

        accountManager.partnerProfileImage
            .bind { [weak self] url in
                self?.inChargeOfPartnerImageView.kf.setImage(with: url)
            }
            .disposed(by: disposeBag)
    }
    
    private func applyInChargeOfView(day: TrashDay) {
        guard let userSelf = accountManager.userSelf.value else {
            return
        }
        let partner = accountManager.partner.value
        viewOfMyPartner.isHidden = true
        viewOfInvitation.isHidden = true
        let myIconURL: String = userSelf.iconURL ?? ""
        let partnerIconURL: String = partner?.iconURL ?? ""
        inChargeOfMeImageView.kf.setImage(with: URL(string: myIconURL))
        inChargeOfPartnerImageView.kf.setImage(with: URL(string: partnerIconURL))
        if userSelf.hasPartner {
            viewOfMyPartner.isHidden = false
        } else {
            viewOfInvitation.isHidden = false
        }
        viewOfMe.isHidden = false
    }
    
    private func setSelected(_ selected: Bool, meOrPartnerView: UIView) {
        
    }
}
