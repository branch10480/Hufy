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
    
    var viewModel: Tutorial2ViewModel!
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainImageButton: BaseButton!
    @IBOutlet var imageButtons: [UIButton]!
    @IBOutlet var imageViews: [UIImageView]!
    @IBOutlet weak var stackViewWithSubPhotosAtFirst: UIStackView!
    @IBOutlet weak var pickFromLibraryButton: BaseButton!
    @IBOutlet weak var nextButtonWrapperView: UIView!
    @IBOutlet weak var nextButton: BaseButton!

    private let sideMargin: CGFloat = 32
    private let separativeMargin: CGFloat = 16
    
    let images: [UIImage?] = [
        UIImage(named: "pose_pien_uruuru_man"),
        UIImage(named: "pose_pien_uruuru_woman"),
        UIImage(named: "beads_cushion_man"),
        UIImage(named: "beads_cushion_woman"),
        UIImage(named: "megane_hikaru_man"),
        UIImage(named: "megane_hikaru_woman"),
        UIImage(named: "video_cooking_man"),
        UIImage(named: "video_cooking_woman")
    ]
    
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
        pickFromLibraryButton.type = .defaultDesign
        nextButton.setTitle("Tutorial2VC.nextButton.title".localized, for: .normal)
        nextButton.type = .defaultDesign
        
        setImageDesign(view: mainImageView, isMain: true)
        
        nextButtonWrapperView.backgroundColor = .other2
        
        // pickingFromLibraryObservable
        let imagePickerStream = Observable.merge([
            mainImageButton.rx.tap.asObservable(),
            pickFromLibraryButton.rx.tap.asObservable()
        ])
        let pickingFromLibraryObservable = imagePickerStream.flatMap { [weak self] (Void) in
            return UIImagePickerController.rx.createWithParent(self, animated: true) { picker in
                picker.sourceType = .photoLibrary
                picker.allowsEditing = true
            }
        }.flatMap { (imagePicker: UIImagePickerController) in
            return imagePicker.rx.didFinishPickingMediaWithInfo
        }.do(onNext: { [weak self] dic in
            self?.presentedViewController?.dismiss(animated: true, completion: nil)
        }).map { info in
            return info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage
        }
        
        // set sub photos
        for i in 0..<min(images.count, imageViews.count) {
            let imageView = imageViews[i]
            imageView.image = images[i]
            setImageDesign(view: imageView, isMain: false)
        }
        var buttonObservables: [Observable<UIImage?>] = []
        for i in 0..<min(images.count, imageButtons.count) {
            let image = self.images[i]
            let observable = imageButtons[i].rx.tap.flatMap {
                Observable<UIImage?>.create { observer in
                    observer.onNext(image)
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
            buttonObservables.append(observable)
        }
        
        viewModel = Tutorial2ViewModel(
            pickingFromLibraryObservable: pickingFromLibraryObservable,
            subPhotoButtonObservables: buttonObservables,
            nextButtonTap: nextButton.rx.tap.asObservable(),
            manager: AccountManager()
        )
    }
    
    private func setImageDesign(view: UIView, isMain: Bool) {
        let screenSize = UIScreen.main.bounds
        if isMain {
            view.layer.cornerRadius = screenSize.width / 3 / 2
            view.layer.borderWidth = 3
        } else {
            let numberOfRow = stackViewWithSubPhotosAtFirst.arrangedSubviews.count
            let displayableSize: CGFloat = screenSize.width - sideMargin * 2 - CGFloat(numberOfRow - 1) * separativeMargin
            view.layer.cornerRadius = displayableSize / CGFloat(numberOfRow) / 2
            view.layer.borderWidth = 2
        }
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.other2.cgColor
    }
    
    private func bind() {
        viewModel.isLoading.asDriver().drive(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.progressViewService.show(view: self.view)
            } else {
                self.progressViewService.dismiss(view: self.view)
            }
        }).disposed(by: disposeBag)

        viewModel.mainPhoto.bind(to: mainImageView.rx.image)
            .disposed(by: disposeBag)
        viewModel.isNextButtonEnabled.bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        viewModel.imageUploadComplete.subscribe(onNext: { [weak self] result in
            guard result else {
                return
            }
            let vc = Tutorial3ViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }

}
