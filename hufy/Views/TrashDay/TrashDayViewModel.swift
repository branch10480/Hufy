//
//  TrashDayViewModel.swift
//  hufy
//
//  Created by branch10480 on 2020/10/11.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class TrashDayViewModel: BaseViewModel {

    let days: BehaviorRelay<[TrashDaySectionModel]> = .init(value: [
        .init(model: .normal, items: [])
    ])
    private let accountManager: AccountManagerProtocol
    private let trashDayManager: TrashDayManagerProtocol
    
    init(
        accountManager: AccountManagerProtocol,
        trashDayManager: TrashDayManagerProtocol
    ) {
        self.accountManager = accountManager
        self.trashDayManager = trashDayManager
        super.init()
        self.subscribe()

        accountManager.getTodoGroupId().subscribe(onNext: { [weak self] groupId in
                self?.trashDayManager.set(groupId: groupId)
                self?.trashDayManager.removeTrashDayListener()
                self?.trashDayManager.setTrashDayListener()
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribe() {
        trashDayManager.days.subscribe(onNext: { [weak self] days in
            self?.setupSectionModels(days: days)
        })
        .disposed(by: disposeBag)
    }
    
    private func setupSectionModels(days: [TrashDay]) {
        let items = days.map { TrashDaySectionItem.day($0) }
        self.days.accept([
            .init(model: .normal, items: items)
        ])
    }
}
