//
//  FriendViewModel.swift
//  ClientVK
//
//  Created by Egor on 06.03.2021.
//

import Foundation
import RxSwift

protocol FriendViewModelProtocol {
    var model: FriendModel { get set }
    var fullName: BehaviorSubject<String> { get }
    var profileImage: BehaviorSubject<Data?> { get }
}

class FriendViewModel: FriendViewModelProtocol {
    
    var model: FriendModel
    var fullName: BehaviorSubject<String>
    var profileImage: BehaviorSubject<Data?>
    var photos: [Data?] {
        return model.userPhotos
    }
    
    init(model: FriendModel) {
        self.model = model
        fullName = BehaviorSubject(value: model.getFullName())
        profileImage = BehaviorSubject(value: model.profileImage)
        
        // subscribe model on subjects changes
        fullName.subscribe(onNext: { model.setFullName(fullName: $0) })
        profileImage.subscribe(onNext: { model.profileImage = $0 })
    }
    
    func setProfileImage(with url: String) {
        if let url = URL(string: url) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, resp, err in
                guard let data = data, err == nil else { return }
                self?.profileImage.onNext(data)
            }
            
            task.resume()
        }
    }
    
    func loadImages() {
        DispatchQueue.global().async { [weak self] in
            self?.model.loadImages()
        }
    }
}
