//
//  TrashDayViewController.swift
//  hufy
//
//  Created by branch10480 on 2020/10/11.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources

class TrashDayViewController: BaseViewController {
    
    private static let cellId = "TrashDayCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var viewModel = TrashDayViewModel()
    var accountManager: AccountManagerProtocol = AccountManager()
    
    lazy var dataSource = RxTableViewSectionedAnimatedDataSource<TrashDaySectionModel>(
        animationConfiguration: AnimationConfiguration(insertAnimation: .automatic, reloadAnimation: .automatic, deleteAnimation: .automatic),
        configureCell: { [weak self] (dataSource, tableView, indexPath, item) -> UITableViewCell in
            guard let self = self,
                  let userSelf = self.accountManager.userSelf.value else
            {
                return .init()
            }
            switch item {
            case .day(let day):
                let cell = tableView.dequeueReusableCell(withIdentifier: TrashDayViewController.cellId, for: indexPath) as! TrashDayTableViewCell
                cell.set(day, me: userSelf, partner: userSelf.partner)
                cell.selectionStyle = .none
                return cell
            }
        }
    )

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setup() {
        super.setup()
        
        title = "TabBarViewController.item5.title".localized
    }
    
    private func bind() {
        
    }
}


typealias TrashDaySectionModel = AnimatableSectionModel<TrashDaySectionId, TrashDaySectionItem>


enum TrashDaySectionId: String, IdentifiableType {
    case normal
    
    var identity: String {
        return self.rawValue
    }
}

enum TrashDaySectionItem: IdentifiableType, Equatable {
    case day(TrashDay)
    
    var identity: String {
        switch self {
        case .day(let day):
            return day.day
        }
    }
    
    static func == (lhs: TrashDaySectionItem, rhs: TrashDaySectionItem) -> Bool {
        let lDay: TrashDay
        let rDay: TrashDay
        switch lhs {
        case .day(let day):
            lDay = day
        }
        switch rhs {
        case .day(let day):
            rDay = day
        }
        
        // TODO 残りの他フィールドも条件に加える
        
        return  lDay.id == rDay.id &&
                lDay.day == rDay.day &&
                lDay.isOn == rDay.isOn &&
                lDay.inChargeOf == rDay.inChargeOf &&
                lDay.remark == rDay.remark
    }
}
