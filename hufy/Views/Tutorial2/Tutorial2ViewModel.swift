//
//  Tutorial2ViewModel.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import Kingfisher

class Tutorial2ViewModel: BaseViewModel {
    var mainPhoto: BehaviorRelay<UIImage?> = .init(value: nil)
    var isNextButtonEnabled: BehaviorRelay<Bool> = .init(value: false)
    var allowGoingToNextView: Observable<URL?>!
    private var imageUploadComplete: BehaviorRelay<Bool> = .init(value: false)
    private var manager: AccountManagerProtocol!
    
    override init() {
        super.init()
    }
    
    convenience init(
        pickingFromLibraryObservable: Observable<UIImage?>,
        subPhotoButtonObservables: [Observable<UIImage?>],
        nextButtonTap: Observable<Void>,
        manager: AccountManagerProtocol
    ) {
        self.init()

        self.manager = manager
        pickingFromLibraryObservable.subscribe(onNext: { [weak self] image in
            guard let self = self else {
                return
            }
            self.mainPhoto.accept(image)
        }).disposed(by: disposeBag)

        subPhotoButtonObservables.forEach { [weak self] observable in
            guard let self = self else {
                return
            }
            observable.subscribe(onNext: { [weak self] image in
                self?.mainPhoto.accept(image)
            }).disposed(by: self.disposeBag)
        }
        
        mainPhoto.asDriver().drive(onNext: { image in
            self.isNextButtonEnabled.accept(image != nil)
        }).disposed(by: disposeBag)

        let mainPhotoNonNilObservable: Observable<UIImage> = mainPhoto.asObservable().filter { image -> Bool in
            return image != nil
        }.map { image in
            let image: UIImage = image!
            return image
        }
        let nextButtonObservable = nextButtonTap.withLatestFrom(mainPhotoNonNilObservable)
        nextButtonObservable.flatMapLatest { [weak self] image -> Observable<(Int64, Int64)> in
            self?.isLoading.accept(true)
            return manager.registerProfileImage(image: image)
        }.subscribe(onNext: { [weak self] progress, total in
            
            // TODO: show uploading progress to UI
            
            if progress == total {
                // upload has completed
                self?.imageUploadComplete.accept(true)
                self?.isLoading.accept(false)
            }
        }, onError: { [weak self] error in
            print(error.localizedDescription)
            self?.isLoading.accept(false)
        }).disposed(by: disposeBag)
        
        self.allowGoingToNextView = imageUploadComplete
            .filter { $0 }
            // Firebase Storageのアップロードが反映されるまでに間隔があるようなので遅延させる
            .do(onNext: { [weak self] _ in
                self?.isLoading.accept(true)
            })
            .flatMap { _ in
                return manager.getProfileImageURL()
            }
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { url in
                return Observable<URL?>.create { [weak self] observer -> Disposable in
                    ImageCache.default.clearMemoryCache()
                    let prefetcher = ImagePrefetcher(urls: [url!]) {
                        skippedResources, failedResources, completedResources in

                        observer.onNext(url)
                        observer.onCompleted()
                        
                        self?.isLoading.accept(false)
                    }
                    prefetcher.start()
                    return Disposables.create()
                }
            }.do(onNext: { [weak self] _ in
                guard let self = self else { return }
                manager.fetchUserSelf().flatMapLatest { user -> Observable<Void> in
                    var user = user
                    user.tutorial2Done = true
                    return manager.updateUser(user: user)
                }.subscribe().disposed(by: self.disposeBag)
            })
    }
}
