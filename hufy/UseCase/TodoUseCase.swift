//
//  TodoManager.swift
//  hufy
//
//  Created by branch10480 on 2020/08/29.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import FirebaseFirestore
import FirebaseFirestoreSwift

enum TodoUseCaseError: Error {
    case unknown
}

protocol TodoUseCaseProtocol {
    var todos: BehaviorRelay<[Todo]> { get }
    
    func set(todoGroupId: String)
    func setTodoListener()
    func removeTodoListener()
    func addTodo()
    func save(_ todo: Todo) -> Observable<Void>
    func removeTodo(_ todo: Todo) -> Observable<Void>
}

final class TodoUseCase: TodoUseCaseProtocol {
    
    static let shared = TodoUseCase()
    private init() {}
    
    private(set) var todos: BehaviorRelay<[Todo]> = .init(value: [])
    
    private let db = Firestore.firestore()
    private var todoGroupId: String!
    private var listener: ListenerRegistration?
    private var todoCollectioinRef: CollectionReference {
        return db.collection("todoGroups")
            .document(self.todoGroupId ?? "")
            .collection("todos")
    }
    
    deinit {
        removeTodoListener()
    }
    
    func set(todoGroupId: String) {
        self.todoGroupId = todoGroupId
    }
    
    func setTodoListener() {
        guard self.listener == nil else {
            return
        }
        // Subscribe
        self.listener = todoCollectioinRef.addSnapshotListener { [weak self] snap, error in
                
                if let error = error {
                    Logger.default.debug(error.localizedDescription)
                }
                
                guard let snap = snap else {
                    return
                }
                
                snap.documentChanges.forEach { change in
                    guard let self = self else { return }
                    var original = self.todos.value
                    switch change.type {
                    case .added, .modified:
                        guard let todo = Todo(JSON: change.document.data()) else {
                            return
                        }
                        original.removeAll { tmpTodo -> Bool in
                            tmpTodo.id == todo.id
                        }
                        original.append(todo)
                        self.todos.accept(original)
                        Logger.default.debug("New todo was updated!")
                    case .removed:
                        guard let todo = Todo(JSON: change.document.data()) else {
                            return
                        }
                        original.removeAll { tmpTodo -> Bool in
                            tmpTodo.id == todo.id
                        }
                        self.todos.accept(original)
                        Logger.default.debug("Todo was removed!")
                    }
                }
            }
    }
    
    func removeTodoListener() {
        listener?.remove()
    }
    
    func addTodo() {
        var original = todos.value
        original.append(Todo())
        todos.accept(original)
    }

    func save(_ todo: Todo) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer -> Disposable in
            
            guard let self = self else {
                return Disposables.create()
            }
            
            let ref = self.todoCollectioinRef.document(todo.id)
            ref.setData(todo.dictionary, merge: true) { error in
                if let error = error {
                    observer.onError(error)
                }
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func removeTodo(_ todo: Todo) -> Observable<Void> {
        var todos = self.todos.value
        todos.removeAll { tmpTodo -> Bool in
            tmpTodo.id == todo.id
        }
        self.todos.accept(todos)
        return Observable<Void>.create { [weak self] observer -> Disposable in
            
            guard let self = self else {
                return Disposables.create()
            }
            
            let ref = self.todoCollectioinRef.document(todo.id)
            ref.delete { error in
                if let error = error {
                    observer.onError(error)
                }
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
