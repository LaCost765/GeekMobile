//
//  CurrentUserModel.swift
//  GeekMobile
//
//  Created by Egor on 13.03.2021.
//

import Foundation
import Firebase
import RxSwift

protocol UserModel {
    var name: String? { get set }
    var profileImage: Data? { get set }
    var friendsUIDs: [String] { get set }
    var photos: [String] { get set }
    var uid: String { get set }
    
    func loadUserName(callback: @escaping (String) -> Void)
    func loadUserImage(callback: @escaping (Data?) -> Void)
}

class GeekUser: UserModel {
    
    var uid: String
    var name: String?
    var profileImage: Data?
    var friendsUIDs: [String] = []
    var photos: [String] = []
    var firebaseManager: FirebaseManager
    
    init(uid: String) {
        self.uid = uid
        firebaseManager = FirebaseManager(userUID: uid)
    }
    
    func loadUserName(callback: @escaping (String) -> Void) {
        
        firebaseManager.getUserName(by: self.uid) { [weak self] name in
            self?.name = name
            callback(name)
        }
    }
    
    func loadUserImage(callback: @escaping (Data?) -> Void) {
        
        firebaseManager.getUserProfilePhoto { [weak self] data in
            
            self?.profileImage = data
            callback(data)
        }
    }
}
