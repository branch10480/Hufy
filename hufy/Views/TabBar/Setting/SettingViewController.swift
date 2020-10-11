//
//  SettingViewController.swift
//  hufy
//
//  Created by branch10480 on 2020/08/22.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SettingViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private static let sectionsData: [SectionOfSettingData] = [
        .init(header: "SettingVC.section.user".localized, items: [
            .editName,
            .editIcon,
            .invitation,
            .logout
        ]),
        .init(header: "SettingVC.section.aboutApp".localized, items: [
            .contact,
            .reviewApp,
            .privacyPolicy,
            .termsOfUse,
            .appVersion
        ])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func setup() {
        super.setup()
        title = "SettingVC.title".localized
    }
    
    private func bind() {
        // TableView Data Source
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfSettingData>(configureCell: { dataSource, tableView, indexPath, item in
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell.textLabel?.numberOfLines = 0
            let item = dataSource[indexPath]
            cell.textLabel?.text = item.title
            switch item {
            case .appVersion:
                cell.selectionStyle = .none
            default:
                cell.selectionStyle = .default
            }
            return cell
        })
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        Observable.just(SettingViewController.sectionsData)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // TableView Selection
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
            let item = dataSource[indexPath]
            switch item {
            case .editName:
                let vc = Tutorial3ViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            case .editIcon:
                let vc = Tutorial2ViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            case .invitation:
                let vc = InvitationViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
                break
            case .logout:
                break
            case .contact:
                break
            case .reviewApp:
                break
            case .privacyPolicy:
                break
            case .termsOfUse:
                break
            case .appVersion:
                break
            }
        }).disposed(by: disposeBag)
    }
}

struct SectionOfSettingData {
    var header: String
    var items: [Item]
}

extension SectionOfSettingData: SectionModelType {
    typealias Item = SettingSectionItem
    init(original: SectionOfSettingData, items: [SettingSectionItem]) {
        self = original
        self.items = items
    }
}

enum SettingSectionItem {
    case editName
    case editIcon
    case invitation
    case logout
    case contact
    case reviewApp
    case privacyPolicy
    case termsOfUse
    case appVersion
}
extension SettingSectionItem {
    var title: String {
        switch self {
        case .editName:
            return "SettingVC.sectionItem.editName".localized
        case .editIcon:
            return "SettingVC.sectionItem.editIcon".localized
        case .invitation:
            return "SettingVC.sectionItem.invitation".localized
        case .logout:
            return "SettingVC.sectionItem.logout".localized
        case .contact:
            return "SettingVC.sectionItem.contact".localized
        case .reviewApp:
            return "SettingVC.sectionItem.reviewApp".localized
        case .privacyPolicy:
            return "SettingVC.sectionItem.privacyPolicy".localized
        case .termsOfUse:
            return "SettingVC.sectionItem.termsOfUse".localized
        case .appVersion:
            return "SettingVC.sectionItem.appVersion".localized
        }
    }
}
