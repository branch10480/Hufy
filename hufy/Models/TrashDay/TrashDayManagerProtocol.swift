//
//  TrashDayManagerProtocol.swift
//  hufy
//
//  Created by branch10480 on 2020/10/11.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

protocol TrashDayManagerProtocol {
    var days: BehaviorRelay<[TrashDay]> { get }
    
    func set(groupId: String)
    func setTodoListener()
    func removeTodoListener()
    func save(_ day: TrashDay) -> Observable<Void>
}
