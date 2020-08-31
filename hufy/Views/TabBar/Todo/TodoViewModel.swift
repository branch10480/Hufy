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
        self.subscribe(addButtonTap: addButtonTap)
    }
    
    func textFieldDidEndEditing(todo: Todo, text: String) {
        print("== Text editing is finished ==")
        print(todo.dictionary)
        print("Edited text is '\(text)'")
        var todo = todo
        todo.title = text
        todoManager.save(todo).subscribe(onNext: { _ in
            print("Todo was saved!")
        }, onError: { error in
            print(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }
    
    private func subscribe(addButtonTap: Observable<Void>) {
        
        todoManager.todos.subscribe(onNext: { [weak self] todos in
                self?.setupSectionModels(todos: todos)
            })
            .disposed(by: disposeBag)
        
        accountManager.getTodoGroupId().subscribe(onNext: { [weak self] groupId in
            self?.todoManager.set(todoGroupId: groupId)
                self?.todoManager.removeTodoListener()
                self?.todoManager.setTodoListener()
            })
            .disposed(by: disposeBag)
        
        addButtonTap.subscribe(onNext: { [weak self] _ in
                self?.todoManager.addTodo()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupSectionModels(todos: [Todo]) {
        let completed: [Todo] = todos
            .filter { $0.isDone }
            .sorted { (todo1, todo2) -> Bool in
                return todo1.createdAt.compare(todo2.createdAt) != .orderedDescending
            }
        let incompleted: [Todo] = todos
            .filter { !$0.isDone }
            .sorted { (todo1, todo2) -> Bool in
                return todo1.createdAt.compare(todo2.createdAt) != .orderedDescending
            }
        let todoSection = TodoSectionModel(model: .todo, items: incompleted.map{ TodoSectionItem.row(data: $0) })
        let completedSection = TodoSectionModel(model: .done, items: completed.map{ TodoSectionItem.row(data: $0) })
        self.todos.accept([
            todoSection,
            completedSection
        ])
    }
}
