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

final class TodoManager: TodoManagerProtocol {
    
    private(set) var todos: BehaviorRelay<[Todo]> = .init(value: [])
    
    private let db = Firestore.firestore()
    private let todoGroupId: String? = nil
    private var listener: ListenerRegistration?
    
    deinit {
        listener?.remove()
    }
    
    func setTodoListener(todoGroupId: String) {
        // Subscribe
        self.listener = db.collection("todoGroups")
            .document(todoGroupId)
            .collection("todos")
            .addSnapshotListener { snap, error in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let snap = snap else {
                    return
                }
                
                snap.documentChanges.forEach { change in
                    switch change.type {
                    case .added:
                        print("New todo was created!")
                    case .modified:
                        print("Todo was updated!")
                    case .removed:
                        print("Todo was removed!")
                    }
                }
            }
    }
    
    func removeTodoListener() {
        listener?.remove()
    }

    func save(_ todo: Todo) {
        
    }
}
