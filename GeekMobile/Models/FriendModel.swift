//
//  FriendModel.swift
//  GeekMobile
//
//  Created by Egor on 25.04.2021.
//

import Foundation
import RxSwift
import Alamofire
import RealmSwift

class FriendModel: Object, Decodable {
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var surname: String = ""
    @objc dynamic var profileImageURL: String = ""
        
    override init() { }
    
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
