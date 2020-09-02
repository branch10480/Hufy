//
//  TodoManagerProtocol.swift
//  hufy
//
//  Created by branch10480 on 2020/08/29.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

enum TodoManagerError: Error {
    case unknown
}

protocol TodoManagerProtocol {
    var todos: BehaviorRelay<[Todo]> { get }
    
    func set(todoGroupId: String)
    func setTodoListener()
    func removeTodoListener()
    func addTodo()
    func save(_ todo: Todo) -> Observable<Void>
    func removeTodo(_ todo: Todo) -> Observable<Void>
}
