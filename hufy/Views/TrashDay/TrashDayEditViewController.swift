//
//  TrashDayEditViewController.swift
//  hufy
//
//  Created by branch10480 on 2020/10/11.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit

class TrashDayEditViewController: BaseViewController {
    
    @IBOutlet weak var switchDescriptionLabel: UILabel!
    @IBOutlet weak var switchOfEdition: UISwitch!
    @IBOutlet weak var whatTrashDayLabel: UILabel!
    @IBOutlet weak var whatTrashDayTextField: UITextField!
    @IBOutlet weak var inChargeOfLabel: UILabel!
    @IBOutlet weak var inChargeOfMeButton: UIButton!
    @IBOutlet weak var inChargeOfMeImageView: UIImageView!
    @IBOutlet weak var inChargeOfPartnerButton: UIButton!
    @IBOutlet weak var inChargeOfPartnerImageView: UIImageView!
    @IBOutlet weak var invitationButton: UIButton!
    @IBOutlet weak var remarkTitleLabel: UILabel!
    @IBOutlet weak var remarkTextView: UITextView!
    @IBOutlet weak var registrationButton: UIButton!
    
    private lazy var viewModel = TrashDayEditViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func setup() {
        super.setup()
    }
    
    private func bind() {
        
    }
}
