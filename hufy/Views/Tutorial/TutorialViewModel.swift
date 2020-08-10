//
//  TutorialViewModel.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class TutorialViewModel: BaseViewModel {
    
    let loginSuccess: BehaviorRelay<Bool> = .init(value: false)
    
    private let manager: AccountManagerProtocol
    
    init(tapObservable: Observable<Void>, manager: AccountManagerProtocol) {
        self.manager = manager
        super.init()
        tapObservable.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.isLoading.accept(true)
            // 始めるボタンを押したとき
            self.manager.login().subscribe(onNext: { [weak self] in
                self?.loginSuccess.accept(true)
            }, onError: { error in
                print("++ Firebase Auth Error ++")
                print(error.localizedDescription)
            }, onCompleted: { [weak self] in
                self?.isLoading.accept(false)
            }).disposed(by: self.disposeBag)
            
        }).disposed(by: disposeBag)
    }
    
    
}
