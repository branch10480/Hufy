//
//  TrashDayManager.swift
//  hufy
//
//  Created by branch10480 on 2020/10/11.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import FirebaseFirestore
import FirebaseFirestoreSwift

enum TrashDayManagerError: Error {
    case unknown
}

final class TrashDayManager: TrashDayManagerProtocol {
    
    static let shared = TrashDayManager()
    private init() {}
    
    private(set) var days: BehaviorRelay<[TrashDay]> = .init(value: [])
    
    private let db = Firestore.firestore()
    private var groupId: String!
    private var listener: ListenerRegistration?
    private var daysCollectioinRef: CollectionReference {
        return db.collection("trashDays")
            .document(self.groupId ?? "")
            .collection("days")
    }
    
    deinit {
        removeTrashDayListener()
    }
    
    func set(groupId: String) {
        self.groupId = groupId
    }
    
    func setTrashDayListener() {
        guard self.listener == nil else {
            return
        }
        // Subscribe
        self.listener = daysCollectioinRef.addSnapshotListener { [weak self] snap, error in
                
                if let error = error {
                    Logger.default.debug(error.localizedDescription)
                }
                
                guard let snap = snap else {
                    return
                }
                
                snap.documentChanges.forEach { change in
                    guard let self = self else { return }
                    var original = self.days.value
                    switch change.type {
                    case .added, .modified:
                        guard let day = TrashDay(JSON: change.document.data()) else {
                            return
                        }
                        original.removeAll { tmpDay -> Bool in
                            tmpDay.day == day.day
                        }
                        original.append(day)
                        self.days.accept(original)
                        Logger.default.debug("New todo was updated!")
                    case .removed:
                        guard let day = TrashDay(JSON: change.document.data()) else {
                            return
                        }
                        original.removeAll { tmpDay -> Bool in
                            tmpDay.day == day.day
                        }
                        self.days.accept(original)
                        Logger.default.debug("Todo was removed!")
                    }
                }
            }
    }
    
    func removeTrashDayListener() {
        listener?.remove()
    }
    
    func save(_ day: TrashDay) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer -> Disposable in
            
            guard let self = self else {
                return Disposables.create()
            }
            
            let ref = self.daysCollectioinRef.document(day.id)
            ref.setData(day.dictionary, merge: true) { error in
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
