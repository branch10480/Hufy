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
        .init(model: .todo, items: []),
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
        self.bind()
    }
    
    func textFieldDidEndEditing(todo: Todo, text: String) {
        print("== Text editing is finished ==")
        print(todo.dictionary)
        print("Edited text is '\(text)'")
    }
    
    private func bind() {
        
        todoManager.todos.subscribe(onNext: { [weak self] todos in
                self?.setupSectionModels(todos: todos)
            })
            .disposed(by: disposeBag)
        
        accountManager.getTodoGroupId().subscribe(onNext: { [weak self] groupId in
                self?.todoManager.removeTodoListener()
                self?.todoManager.setTodoListener(todoGroupId: groupId)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupSectionModels(todos: [Todo]) {
        let completed: [Todo] = todos
            .filter { $0.isDone }
            .sorted { (todo1, todo2) -> Bool in
                guard let timestamp1 = todo1.createdAt,
                      let timestamp2 = todo2.createdAt else { return true }
                return timestamp1.compare(timestamp2) != .orderedDescending
            }
        let incompleted: [Todo] = todos
            .filter { !$0.isDone }
            .sorted { (todo1, todo2) -> Bool in
                guard let timestamp1 = todo1.createdAt,
                      let timestamp2 = todo2.createdAt else { return true }
                return timestamp1.compare(timestamp2) != .orderedDescending
            }
        let todoSection = TodoSectionModel(model: .todo, items: incompleted.map{ TodoSectionItem.row(data: $0) })
        let completedSection = TodoSectionModel(model: .todo, items: completed.map{ TodoSectionItem.row(data: $0) })
        self.todos.accept([
            todoSection,
            completedSection
        ])
    }
}
