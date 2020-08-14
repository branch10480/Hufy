//
//  Tutorial2ViewModel.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class Tutorial2ViewModel: BaseViewModel {
    var mainPhoto: BehaviorRelay<UIImage?> = .init(value: nil)
    var isNextButtonEnabled: BehaviorRelay<Bool> = .init(value: false)
    private var manager: AccountManagerProtocol!
    
    override init() {
        super.init()
    }
    
    convenience init(
        pickingFromLibraryObservable: Observable<UIImage?>,
        subPhotoButtonObservables: [Observable<UIImage?>],
        manager: AccountManagerProtocol
    ) {
        self.init()

        self.manager = manager
        pickingFromLibraryObservable.subscribe(onNext: { [weak self] image in
            guard let self = self else {
                return
            }
            self.mainPhoto.accept(image)
        }).disposed(by: disposeBag)

        subPhotoButtonObservables.forEach { [weak self] observable in
            guard let self = self else {
                return
            }
            observable.subscribe(onNext: { [weak self] image in
                self?.mainPhoto.accept(image)
            }).disposed(by: self.disposeBag)
        }
        
        mainPhoto.asDriver().drive(onNext: { image in
            self.isNextButtonEnabled.accept(image != nil)
        }).disposed(by: disposeBag)
    }
}
