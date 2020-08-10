//
//  Tutorial2ViewController.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit

class Tutorial2ViewController: BaseViewController {
    
    lazy var viewModel: Tutorial2ViewModel = Tutorial2ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func setup() {
        super.setup()
        title = "Tutorial2VC.title".localized
    }
    
    private func bind() {
    }

}
