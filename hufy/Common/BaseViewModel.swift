//
//  BaseViewModel.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class BaseViewModel {
    let isLoading: BehaviorRelay<Bool> = .init(value: false)
    let disposeBag: DisposeBag = DisposeBag()
}
