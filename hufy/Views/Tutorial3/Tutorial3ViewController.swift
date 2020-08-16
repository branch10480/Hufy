//
//  Tutorial3ViewController.swift
//  hufy
//
//  Created by branch10480 on 2020/08/16.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit

class Tutorial3ViewController: BaseViewController {
    
    lazy var viewModel: Tutorial3ViewModel = Tutorial3ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setup() {
        super.setup()
        title = "Tutorial3VC.title".localized
    }
    
    private func bind() {
    }

}
