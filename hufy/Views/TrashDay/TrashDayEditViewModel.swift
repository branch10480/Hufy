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
    
    private var trashDayToSend: TrashDay
    
    init(
        trashDay: TrashDay,
        switchDidChange: Observable<Bool>,
        accountManager: AccountManagerProtocol
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
        
        super.init()
        
        switchDidChange.bind { [weak self] new in
            self?.trashDayToSend.isOn = new
            self?.isTrashDay.accept(new)
        }
        .disposed(by: disposeBag)
    }
}
