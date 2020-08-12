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
    @IBOutlet var imageViews: [UIImageView]!
    @IBOutlet weak var stackViewWithSubPhotosAtFirst: UIStackView!
    @IBOutlet weak var pickFromLibraryButton: UIButton!
    
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
        pickFromLibraryButton.setDefaultDesign(radius: 24)
        
        setImageDesign(view: mainImageView, isMain: true)
        
        // set sub photos
        for i in 0..<min(images.count, imageViews.count) {
            let imageView = imageViews[i]
            imageView.image = images[i]
            setImageDesign(view: imageView, isMain: false)
        }
        var buttonObservables: [Observable<UIImage?>] = []
        for i in 0..<min(images.count, imageButtons.count) {
            let observable = imageButtons[i].rx.tap.flatMap {
                return Observable<Int>.create { observer -> Disposable in
                    observer.onNext(i)
                    observer.onCompleted()
                    return Disposables.create()
                }
            }.flatMap { tag in
                Observable<UIImage?>.create { observer in
                    observer.onNext(self.images[tag])
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
            buttonObservables.append(observable)
        }

        buttonObservables.forEach { observable in
            observable.subscribe(onNext: { [weak self] image in
                self?.mainImageView.image = image
            }).disposed(by: disposeBag)
        }
        
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
        let imagePickerStream = Observable.merge([
            mainImageButton.rx.tap.asObservable(),
            pickFromLibraryButton.rx.tap.asObservable()
        ])
        imagePickerStream.flatMap { [weak self] (Void) in
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
        }.bind(to: mainImageView.rx.image)
        .disposed(by: disposeBag)
    }

}
