//
//  TrashDayEditViewModel.swift
//  hufy
//
//  Created by branch10480 on 2020/10/11.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class TrashDayEditViewModel: BaseViewModel {
    
    let trashDay: BehaviorRelay<TrashDay>
    let isTrashDay: BehaviorRelay<Bool>
    let userInfo: Observable<(userSelf: User?, partner: User?)>
    let isViewOfMeSelected: BehaviorRelay<Bool> = .init(value: false)
    let isViewOfPartnerSelected: BehaviorRelay<Bool> = .init(value: false)
    let finishSaving: PublishRelay<Void> = .init()

    private var trashDayToSend: TrashDay
    private let accountManager: AccountManagerProtocol
    private let trashDayManager: TrashDayManagerProtocol

    init(
        trashDay: TrashDay,
        switchDidChange: Observable<Bool>,
        viewOfMeTap: Observable<Void>,
        viewOfPartnerTap: Observable<Void>,
        titleTextInput: Observable<String?>,
        remarkTextInput: Observable<String?>,
        accountManager: AccountManagerProtocol,
        registrationButtonTap: Observable<Void>,
        trashDayManager: TrashDayManagerProtocol
    ) {
        self.trashDay = .init(value: trashDay)
        self.trashDayToSend = trashDay
        self.isTrashDay = .init(value: trashDay.isOn)

        let userSelfObservable = accountManager.userSelf.asObservable()
        let partnerObservable = accountManager.partner.asObservable()
        self.userInfo = Observable.combineLatest(
            userSelfObservable,
            partnerObservable,
            resultSelector: { (userSelf: $0, partner: $1) }
        )
        self.accountManager = accountManager
        self.trashDayManager = trashDayManager

        super.init()

        switchDidChange.bind { [weak self] new in
            self?.trashDayToSend.isOn = new
            self?.isTrashDay.accept(new)
        }
        .disposed(by: disposeBag)

        registrationButtonTap.bind {
            self.updateTrashDay()
        }
        .disposed(by: disposeBag)

        viewOfMeTap
            .bind { [weak self] in
                self?.makeMeInChargeOf()
            }
            .disposed(by: disposeBag)

        viewOfPartnerTap
            .bind { [weak self] in
                self?.makePartnerInChargeOf()
            }
            .disposed(by: disposeBag)

        titleTextInput
            .bind { [weak self] text in
                self?.trashDayToSend.title = text ?? ""
            }
            .disposed(by: disposeBag)

        remarkTextInput
            .bind { [weak self] text in
                self?.trashDayToSend.remark = text ?? ""
            }
            .disposed(by: disposeBag)
    }

    private func makeMeInChargeOf() {
        guard let userSelf = accountManager.userSelf.value else {
            return
        }
        var day = trashDay.value
        if !day.inChargeOf.isEmpty, userSelf.id == day.inChargeOf {
            day.inChargeOf = ""
        } else {
            day.inChargeOf = userSelf.id
        }
        trashDay.accept(day)
    }

    private func makePartnerInChargeOf() {
        guard let partner = accountManager.partner.value else {
            return
        }
        var day = trashDay.value
        if !day.inChargeOf.isEmpty, partner.id == day.inChargeOf {
            day.inChargeOf = ""
        } else {
            day.inChargeOf = partner.id
        }
        trashDay.accept(day)
    }

    private func updateTrashDay() {
        let trashDay = trashDayToSend
        trashDayManager.save(trashDay)
            .bind { [weak self] in self?.finishSaving.accept(()) }
            .disposed(by: disposeBag)
    }
}
