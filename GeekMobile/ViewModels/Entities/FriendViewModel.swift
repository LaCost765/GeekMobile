//
//  FriendViewModel.swift
//  GeekMobile
//
//  Created by Egor on 25.04.2021.
//

import Foundation
import RxSwift
import RxRelay

class FriendViewModel: DisposeBagHolder {
    
    let model: FriendModel
    var fullName: BehaviorRelay<String>
    var profilePhoto: BehaviorSubject<Data?>
    var photos: BehaviorRelay<[PhotoModel]>
        
    init(model: FriendModel) {
        self.model = model
        self.fullName = BehaviorRelay<String>(value: "\(model.name) \(model.surname)")
        self.profilePhoto = BehaviorSubject<Data?>(value: nil)
        self.photos = BehaviorRelay<[PhotoModel]>(value: [])
        
        super.init()

        self.loadProfilePhoto()
    }
    
    func loadProfilePhoto() {
        
        model.loadProfilePhoto()
            .subscribe(onNext: { [weak self] data in
                
                guard let `self` = self else { return }
                self.profilePhoto.onNext(data)
            })
            .disposed(by: bag)
    }
        
    func loadPhotos() {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in

            guard let `self` = self else { return }
            self.model.loadPhotos()
                .subscribe(onNext: { data in
                    
                    ParserJSON
                        .getPhotosForUser(data: data)
                        .subscribe(onNext: { photoModel in
                            
                            photoModel.loadPhotoData()
                                .subscribe(onNext: { data in
                                    
                                    photoModel.data = data
                                    var arr = self.photos.value
                                    arr.append(photoModel)
                                    self.photos.accept(arr)
                            })
                            .disposed(by: self.bag)
                        })
                        .disposed(by: self.bag)
                        
                })
                .disposed(by: self.bag)
        }
    }
}
