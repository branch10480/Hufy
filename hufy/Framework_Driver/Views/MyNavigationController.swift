//
//  MyNavigationController.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit

class MyNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = .buttonBackground
        navigationBar.tintColor = .buttonText
        navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.buttonText
        ]
    }

}
