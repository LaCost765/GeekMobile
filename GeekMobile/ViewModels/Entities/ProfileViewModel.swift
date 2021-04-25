//
//  ProfileViewModel.swift
//  GeekMobile
//
//  Created by Egor on 13.03.2021.
//

import Foundation
import RxSwift


class ProfileViewModel {
    
    var name: BehaviorSubject<String>
    var profilePhoto: BehaviorSubject<Data?>
    var model: UserModel
    var bag: DisposeBag = DisposeBag()

    init() {
        
        guard let currentUser = CurrentUser.shared else {
            fatalError("Can't get current user instance")
        }
        
        model = currentUser
        name = BehaviorSubject(value: model.name ?? "")
        profilePhoto = BehaviorSubject(value: model.profileImage)
        
        name.subscribe(onNext: { [weak self] value in
            self?.model.name = value
        })
        
        profilePhoto.subscribe(onNext: { [weak self] value in
            self?.model.profileImage = value
        })
        
        self.loadName()
        self.loadProfilePhoto()
    }
    
    func loadName() {
        model.loadUserName { [weak self] name in
            self?.name.onNext(name)
        }
    }
    
    func loadProfilePhoto() {
        model.loadUserImage { [weak self] photo in
            self?.profilePhoto.onNext(photo)
        }
    }
}
