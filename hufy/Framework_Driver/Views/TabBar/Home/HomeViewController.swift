//
//  HomeViewController.swift
//  hufy
//
//  Created by branch10480 on 2020/08/22.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var bgImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setup() {
        super.setup()
        bgImageView.image = UIImage(named: "homeBg")
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
