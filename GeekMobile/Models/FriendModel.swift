//
//  FriendModel.swift
//  GeekMobile
//
//  Created by Egor on 25.04.2021.
//

import Foundation
import RxSwift
import Alamofire

protocol FriendModel {
    var id: String { get set }
    var name: String { get set }
    var surname: String { get set }
    var profileImageURL: String { get set }
    var photosURLs: [String] { get set }
    
    func loadProfilePhoto() -> Observable<Data>
    func loadPhotos() -> Observable<Data>
}

class FriendModelImpl: DisposeBagHolder, FriendModel {
    
    var id: String
    var name: String
    var surname: String
    var profileImageURL: String
    var photosURLs: [String] = []
    
    init(name: String, surname: String, id: String, profileImageURL: String) {
        self.name = name
        self.surname = surname
        self.id = id
        self.profileImageURL = profileImageURL
    }
    
    func loadProfilePhoto() -> Observable<Data> {
        
        return NetworkManager.shared.makeRequest(url: profileImageURL)
    }
    
    /// Load photos with urls in photosURLs property
    func loadPhotos() -> Observable<Data> {

        let params: Parameters = [
            VkAPI.Photo.id.rawValue : self.id,
            VkAPI.Photo.extended.rawValue : "1",
            VkAPI.token.rawValue : UserSession.shared.vkToken ?? "",
            VkAPI.v.rawValue : VkAPI.Constants.v.rawValue
        ]
        
        return NetworkManager.shared.makeRequest(url: "\(VkAPI.Constants.url.rawValue)/photos.getAll", params: params)
    }
    
    
}
