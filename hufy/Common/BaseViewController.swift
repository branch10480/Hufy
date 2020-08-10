//
//  BaseViewController.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var progressViewService: ProgressViewServiceProtocol = ProgressViewService()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        view.backgroundColor = UIColor.background
    }
}
