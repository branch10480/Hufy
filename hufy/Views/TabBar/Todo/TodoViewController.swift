//
//  TodoViewController.swift
//  hufy
//
//  Created by branch10480 on 2020/08/22.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import IQKeyboardManagerSwift
import FirebaseAuth

class TodoViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var viewForTableViewInsetBottom: UIView!

    // for debug
    @IBOutlet weak var debugStackView: UIStackView!
    @IBOutlet weak var debugLabel: UILabel!
    
    private static let cellId = "TodoCell"

    lazy var viewModel: TodoViewModel = .init(
        accountManager: AccountManager.shared,
        todoManager: TodoManager.shared,
        addButtonTap: self.addButton.rx.tap.asObservable(),
        tableViewItemDeleted: self.tableView.rx.itemDeleted.asObservable()
                                .map({ indexPath -> Todo in
                                    let item = self.dataSource[indexPath]
                                    switch item {
                                    case .row(let todo):
                                        return todo
                                    }
                                })
    )
    
    var hapticFeedbackService: HapticFeedbackServiceProtocol = HapticFeedbackService()
    
    lazy var dataSource = RxTableViewSectionedAnimatedDataSource<TodoSectionModel>(
        animationConfiguration: AnimationConfiguration(insertAnimation: .automatic, reloadAnimation: .automatic, deleteAnimation: .automatic),
        configureCell: { [weak self] (dataSource, tableView, indexPath, item) -> UITableViewCell in
            switch item {
            case .row(let todo):
                let cell = tableView.dequeueReusableCell(withIdentifier: TodoViewController.cellId, for: indexPath) as! TodoTableViewCell
                cell.set(todo)
                cell.selectionStyle = .none
                if let self = self {
                    cell.textView.rx.didChange.asObservable()
                        .observe(on: MainScheduler.instance)
                        .subscribe(onNext: { _ in
                            tableView.beginUpdates()
                            tableView.endUpdates()
                            IQKeyboardManager.shared.reloadLayoutIfNeeded()
                        })
                        .disposed(by: cell.disposeBag)

                    cell.textView.rx.didBeginEditing.asObservable()
                        .subscribe(onNext: { [weak self] in
                            self?.tableView.isScrollEnabled = false
                        })
                        .disposed(by: cell.disposeBag)
                    
                    cell.textView.rx.didEndEditing.asObservable()
                        .subscribe(onNext: { [weak cell, todo, weak self] _ in
                            guard let cell = cell else { return }
                            Logger.default.debug(cell.textView.text ?? "")
                            self?.viewModel.textFieldDidEndEditing(todo: todo, text: cell.textView.text)
                            self?.tableView.isScrollEnabled = true
                        })
                        .disposed(by: cell.disposeBag)
                    
                    cell.checkButton.rx.tap.bind { [weak self, todo] in
                        self?.viewModel.checkButtonTap(todo: todo)
                        self?.hapticFeedbackService.prepareImpactFeedback(style: .medium)
                        self?.hapticFeedbackService.impactFeedback()
                    }
                    .disposed(by: cell.disposeBag)
                }
                if todo.isNew {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        cell.textView.becomeFirstResponder()
                    })
                }
                return cell
            }
        },
        titleForHeaderInSection: { dataSource, section in
            switch section {
            case 0:
                return "TodoViewController.sec0.headerTitle".localized
            case 1:
                if dataSource[section].items.isEmpty {
                    return nil
                } else {
                    return "TodoViewController.sec1.headerTitle".localized
                }
            default:
                return nil
            }
            
        },
        canEditRowAtIndexPath: { (dataSource, indexPath) -> Bool in
            return true
        },
        canMoveRowAtIndexPath: { (dataSource, indexPath) -> Bool in
            return true
        }
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Debug
        #if DEBUG
            debugStackView.isHidden = false
            var debugText = ""
            debugText += "User ID is \(Auth.auth().currentUser?.uid ?? "")\n"
            debugText += "Partner ID is \(AccountManager.shared.partner.value?.id ?? "")\n"
            debugLabel.text = debugText
        #else
            debugStackView.isHidden = true
        #endif
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset.bottom = viewForTableViewInsetBottom.bounds.height - 32
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func setup() {
        super.setup()

        title = "TodoVC.title".localized
        tableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil), forCellReuseIdentifier: TodoViewController.cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
        
        // add button
        addButton.superview?.layer.shadowColor = UIColor.black.cgColor
        addButton.superview?.layer.shadowOffset = .init(width: 0, height: 1)
        addButton.superview?.layer.shadowOpacity = 0.16
        addButton.superview?.layer.shadowRadius = 2
        addButton.superview?.layer.cornerRadius = 28
        addButton.layer.cornerRadius = 28
        addButton.layer.masksToBounds = true
        addButton.setBackgroundImage(UIImage.create(withColor: .buttonBackground), for: .normal)
        addButton.setTitleColor(.buttonText, for: .normal)
        let addButtonImage = UIImage(named: "plus")?
            .withRenderingMode(.alwaysTemplate)
        addButton.setImage(addButtonImage, for: .normal)
        addButton.tintColor = .buttonText
    }
    
    private func bind() {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            guard let self = self else { return }
            self.viewModel.todos
                .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
                .disposed(by: self.disposeBag)

            self.addButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    DispatchQueue.main.async {
                        guard let self = self,
                              let firstSectionModel = self.dataSource.sectionModels.first,
                              firstSectionModel.items.count > 0 else
                        {
                            return
                        }
                        let firstIndexPath = IndexPath(row: firstSectionModel.items.count - 1, section: 0)
                        self.tableView.scrollToRow(at: firstIndexPath, at: .top, animated: true)
                    }
                })
                .disposed(by: self.disposeBag)
        }
    }

}

// MARK: - RxDataSources

typealias TodoSectionModel = AnimatableSectionModel<SectionId, TodoSectionItem>

enum SectionId: String, IdentifiableType {
    case todo
    case done
    
    var identity: String {
        return self.rawValue
    }
}

enum TodoSectionItem: IdentifiableType, Equatable {
    
    case row(data: Todo)
    
    var identity: String {
        switch self {
        case .row(let todo):
            return todo.id
        }
    }
    
    static func == (lhs: TodoSectionItem, rhs: TodoSectionItem) -> Bool {
        let lTodo: Todo
        let rTodo: Todo
        switch lhs {
        case .row(let todo):
            lTodo = todo
        }
        switch rhs {
        case .row(let todo):
            rTodo = todo
        }
        
        // TODO 残りの他フィールドも条件に加える
        
        return  lhs.identity == rhs.identity &&
                lTodo.title == rTodo.title &&
                lTodo.isDone == rTodo.isDone &&
                lTodo.isNew == rTodo.isNew
    }
}
