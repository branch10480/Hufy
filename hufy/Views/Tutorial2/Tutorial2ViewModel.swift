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
    var subPhotos: [BehaviorRelay<UIImage?>] = [
        .init(value: nil),
        .init(value: nil),
        .init(value: nil),
        .init(value: nil),
        .init(value: nil),
        .init(value: nil),
        .init(value: nil),
        .init(value: nil),
        .init(value: nil),
        .init(value: nil)
    ]
//    private let manager: AccountManagerProtocol
    
    override init() {
        super.init()
    }
    
//    init(
//        mainPhotoTap: Observable<Void>, subPhotoTap: [Observable<Void>], manager: AccountManagerProtocol
//    ) {
//
//    }
}
