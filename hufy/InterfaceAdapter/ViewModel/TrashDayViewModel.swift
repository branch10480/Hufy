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
    private let accountUseCase: AccountUseCaseProtocol
    private let trashDayUseCase: TrashDayUseCaseProtocol
    
    init(
        accountUseCase: AccountUseCaseProtocol,
        trashDayUseCase: TrashDayUseCaseProtocol
    ) {
        self.accountUseCase = accountUseCase
        self.trashDayUseCase = trashDayUseCase
        super.init()
        self.subscribe()

        accountUseCase.getTodoGroupId().subscribe(onNext: { [weak self] groupId in
                self?.trashDayUseCase.set(groupId: groupId)
                self?.trashDayUseCase.removeTrashDayListener()
                self?.trashDayUseCase.setTrashDayListener()
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribe() {
        trashDayUseCase.days.subscribe(onNext: { [weak self] days in
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
