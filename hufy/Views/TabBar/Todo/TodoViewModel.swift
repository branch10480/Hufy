//
//  TodoViewModel.swift
//  hufy
//
//  Created by branch10480 on 2020/08/29.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources
import FirebaseAuth

class TodoViewModel: BaseViewModel {

    let todos: BehaviorRelay<[TodoSectionModel]> = .init(value: [
        .init(model: .todo, items: [
            .row(data: Todo()),
            .row(data: Todo()),
            .row(data: Todo()),
            .row(data: Todo()),
            .row(data: Todo()),
            .row(data: Todo()),
            .row(data: Todo()),
            .row(data: Todo()),
            .row(data: Todo()),
            .row(data: Todo()),
            .row(data: Todo()),
            .row(data: Todo())
        ]),
        .init(model: .done, items: [])
    ])
    
    private let accountManager: AccountManagerProtocol
    private let todoManager: TodoManagerProtocol
    
    init(
        accountManager: AccountManagerProtocol,
        todoManager: TodoManagerProtocol,
        addButtonTap: Observable<Void>
    ) {
        self.accountManager = accountManager
        self.todoManager = todoManager
        super.init()
        self.setTodoGroupIdToManager()
    }
    
    func textFieldDidEndEditing(todo: Todo, text: String) {
        print("== Text editing is finished ==")
        print(todo.dictionary)
        print("Edited text is '\(text)'")
    }
    
    private func setTodoGroupIdToManager() {
        accountManager.getTodoGroupId().subscribe(onNext: { [weak self] groupId in
            self?.todoManager.removeTodoListener()
            self?.todoManager.setTodoListener(todoGroupId: groupId)
        }).disposed(by: disposeBag)
    }
}
