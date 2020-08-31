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

class TodoViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var viewForTableViewInsetBottom: UIView!
    
    private static let cellId = "TodoCell"

    lazy var viewModel: TodoViewModel = .init(
        accountManager: AccountManager(),
        todoManager: TodoManager(),
        addButtonTap: self.addButton.rx.tap.asObservable()
    )
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
                        .observeOn(MainScheduler.instance)
                        .subscribe(onNext: { _ in
                            tableView.beginUpdates()
                            tableView.endUpdates()
                        })
                        .disposed(by: self.disposeBag)

                    cell.textView.rx.didBeginEditing.asObservable()
                        .subscribe(onNext: { [weak self] in
                            self?.tableView.isScrollEnabled = false
                        })
                        .disposed(by: self.disposeBag)
                    cell.textView.rx.didEndEditing.asObservable()
                        .subscribe(onNext: { [weak cell, todo, weak self] _ in
                            guard let cell = cell else { return }
                            print(cell.textView.text ?? "")
                            self?.viewModel.textFieldDidEndEditing(todo: todo, text: cell.textView.text)
                            self?.tableView.isScrollEnabled = true
                        })
                        .disposed(by: self.disposeBag)
                }
                return cell
            }
        },
        canEditRowAtIndexPath: { (dataSource, indexPath) -> Bool in
            return false
        },
        canMoveRowAtIndexPath: { (dataSource, indexPath) -> Bool in
            return true
        }
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset.bottom = viewForTableViewInsetBottom.bounds.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func setup() {
        super.setup()
        title = "TodoVC.title".localized
        tableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil), forCellReuseIdentifier: TodoViewController.cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 1000
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
        return lhs.identity == rhs.identity
    }
}
