//
//  TabBarViewController.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private let homeVC = HomeViewController()
    private let anniversaryVC = AnniversaryViewController()
    private let todoVC = TodoViewController()
    private let settingVC = SettingViewController()
    
    private lazy var anniversaryNC = MyNavigationController(rootViewController: anniversaryVC)
    private lazy var todoNC = MyNavigationController(rootViewController: todoVC)
    private lazy var settingNC = MyNavigationController(rootViewController: settingVC)

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func setup() {
        view.backgroundColor = UIColor.background
        
        homeVC.tabBarItem = UITabBarItem(title: "TabBarViewController.item1.title".localized, image: nil, tag: 0)
        anniversaryNC.tabBarItem = UITabBarItem(title: "TabBarViewController.item2.title".localized, image: nil, tag: 1)
        todoNC.tabBarItem = UITabBarItem(title: "TabBarViewController.item3.title".localized, image: nil, tag: 2)
        settingNC.tabBarItem = UITabBarItem(title: "TabBarViewController.item4.title".localized, image: nil, tag: 3)
        
        setViewControllers([
            homeVC,
            anniversaryNC,
            todoNC,
            settingNC
        ], animated: true)
    }

}
