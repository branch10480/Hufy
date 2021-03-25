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
    
    private let accountUseCase: AccountUseCaseProtocol
    private let todoUseCase: TodoUseCaseProtocol
    
    init(
        accountUseCase: AccountUseCaseProtocol,
        todoUseCase: TodoUseCaseProtocol,
        addButtonTap: Observable<Void>,
        tableViewItemDeleted: Observable<Todo>
    ) {
        self.accountUseCase = accountUseCase
        self.todoUseCase = todoUseCase
        super.init()
        self.subscribe(
            addButtonTap: addButtonTap,
            tableViewItemDeleted: tableViewItemDeleted
        )
    }
    
    func textFieldDidEndEditing(todo: Todo, text: String) {
        Logger.default.debug("== Text editing is finished ==")
        Logger.default.debug(todo.dictionary)
        Logger.default.debug("Edited text is '\(text)'")
        var todo = todo
        todo.title = text
        Logger.default.debug("Todo to send is ...")
        Logger.default.debug(todo)
        todoUseCase.save(todo).subscribe(onNext: { _ in
            Logger.default.debug("Todo was saved!")
        }, onError: { error in
            Logger.default.debug(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }
    
    func checkButtonTap(todo: Todo) {
        var todo = todo
        todo.isDone = !todo.isDone
        todoUseCase.save(todo).subscribe(onNext: {
            Logger.default.debug("Todo was saved!")
        }, onError: { error in
            Logger.default.debug(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }
    
    private func subscribe(
        addButtonTap: Observable<Void>,
        tableViewItemDeleted: Observable<Todo>
    ) {
        
        todoUseCase.todos.subscribe(onNext: { [weak self] todos in
                self?.setupSectionModels(todos: todos)
            })
            .disposed(by: disposeBag)
        
        accountUseCase.getTodoGroupId().subscribe(onNext: { [weak self] groupId in
            self?.todoUseCase.set(todoGroupId: groupId)
                self?.todoUseCase.removeTodoListener()
                self?.todoUseCase.setTodoListener()
            })
            .disposed(by: disposeBag)
        
        addButtonTap.subscribe(onNext: { [weak self] _ in
                self?.todoUseCase.addTodo()
            })
            .disposed(by: disposeBag)
        
        tableViewItemDeleted
            .flatMapLatest { [weak self] todo -> Observable<Void> in
                guard let self = self else { return Observable<Void>.just(()) }
                return self.todoUseCase.removeTodo(todo)
            }
            .subscribe()
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
