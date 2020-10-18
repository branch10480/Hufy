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
    
    var trashDay: TrashDay!
    
    private let accountManager: AccountManagerProtocol = AccountManager()
    private lazy var viewModel = TrashDayEditViewModel(
        trashDay: self.trashDay,
        switchDidChange: self.switchOfEdition.rx.controlEvent(.valueChanged).withLatestFrom(self.switchOfEdition.rx.value).asObservable()
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
        
        inChargeOfStackView.arrangedSubviews.forEach { view in
            view.isHidden = true
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
        
        viewModel.trashDay.bind { [weak self] day in
            guard let self = self else { return }
            self.whatTrashDayTextField.text = day.title
            self.applyInChargeOfView(day: day, userSelf: self.accountManager.userSelf.value)
            self.remarkTextView.text = day.remark
        }
        .disposed(by: disposeBag)
    }
    
    private func applyInChargeOfView(day: TrashDay, userSelf: User?) {
        guard let userSelf = userSelf else { return }
        viewOfMyPartner.isHidden = true
        viewOfInvitation.isHidden = true
        if userSelf.hasPartner {
            viewOfMyPartner.isHidden = false
        } else {
            viewOfInvitation.isHidden = false
        }
    }
    
    private func setSelected(_ selected: Bool, meOrPartnerView: UIView) {
        
    }
}
