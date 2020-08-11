//
//  Tutorial2ViewController.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Tutorial2ViewController: BaseViewController {
    
    lazy var viewModel: Tutorial2ViewModel = Tutorial2ViewModel()
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainImageButton: UIButton!
    @IBOutlet var imageButtons: [UIButton]!
    @IBOutlet weak var stackViewWithSubPhotosAtFirst: UIStackView!
    @IBOutlet weak var pickFromLibraryButton: UIButton!
    
    private let sideMargin: CGFloat = 32
    private let separativeMargin: CGFloat = 16
    
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
        pickFromLibraryButton.setTitle("Tutorial2VC.pickFromLibraryButton.title".localized, for: .normal)
        pickFromLibraryButton.setDefaultDesign(radius: 24)
        
        setImageDesign(view: mainImageView, isMain: true)
        
    }
    
    private func setImageDesign(view: UIView, isMain: Bool) {
        let screenSize = UIScreen.main.bounds
        if isMain {
            view.layer.cornerRadius = screenSize.width / 3 / 2
            view.layer.borderWidth = 3
        } else {
            let numberOfRow = stackViewWithSubPhotosAtFirst.arrangedSubviews.count
            let displayableSize: CGFloat = screenSize.width - sideMargin * 2 - CGFloat(numberOfRow - 1) * separativeMargin
            view.layer.cornerRadius = displayableSize / CGFloat(numberOfRow)
            view.layer.borderWidth = 2
        }
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.other2.cgColor
    }
    
    private func bind() {
        let imagePickerStream = Observable.merge([
            mainImageButton.rx.tap.asObservable(),
            pickFromLibraryButton.rx.tap.asObservable()
        ])
        imagePickerStream.flatMap { [weak self] (Void) in
            return UIImagePickerController.rx.createWithParent(self, animated: true) { picker in
                picker.sourceType = .photoLibrary
                picker.allowsEditing = true
            }
        }
        .flatMap { (imagePicker: UIImagePickerController) in
            return imagePicker.rx.didFinishPickingMediaWithInfo
        }
        .do(onNext: { [weak self] dic in
            self?.presentedViewController?.dismiss(animated: true, completion: nil)
        })
        .map { info in
            return info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage
        }
        .bind(to: mainImageView.rx.image)
        .disposed(by: disposeBag)
    }

}
