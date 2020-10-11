//
//  TrashDayViewController.swift
//  hufy
//
//  Created by branch10480 on 2020/10/11.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit

class TrashDayViewController: BaseViewController {
    
    private lazy var viewModel = TrashDayViewModel()

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
