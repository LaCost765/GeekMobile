//
//  ParserJSON.swift
//  GeekMobile
//
//  Created by Egor on 25.04.2021.
//

import Foundation
import RxSwift
import SwiftyJSON

class ParserJSON {
    
    static func getGroups(data jsonData: Data) -> Observable<GroupModel> {
        
        if UserSession.shared.vkToken == nil || UserSession.shared.vkToken == "" {
            print("Error in getFriends(data jsonData: Data) call: No access_token")
        }

        return Observable<GroupModel>.create { observer -> Disposable in
              
            let json = JSON(jsonData)
            json[VkAPI.response.rawValue][VkAPI.items.rawValue].arrayObject?
                .map { JSON($0) }
                .forEach { group in
                    let name = group[VkAPI.Group.name.rawValue].string ?? ""
                    let id = group[VkAPI.Group.id.rawValue].int ?? 0
                    let photo = group[VkAPI.Group.photo.rawValue].string ?? ""
                    
                    let model = GroupModel(id: id, name: name, photoUrl: photo)
                    observer.onNext(model)
                }
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    static func getFriends(data jsonData: Data) -> Observable<FriendModel> {
        
        if UserSession.shared.vkToken == nil || UserSession.shared.vkToken == "" {
            print("Error in getFriends(data jsonData: Data) call: No access_token")
        }
        
        return Observable<FriendModel>.create { observer -> Disposable in
              
            let json = JSON(jsonData)
            json[VkAPI.response.rawValue][VkAPI.items.rawValue].arrayObject?
                .map { JSON($0) }
                .forEach { friend in
                    let name = friend[VkAPI.Friend.name.rawValue].string ?? ""
                    let surname = friend[VkAPI.Friend.surname.rawValue].string ?? ""
                    let id = friend[VkAPI.Friend.id.rawValue].int ?? 0
                    let profilePhotoUrl = friend[VkAPI.Friend.photo.rawValue].string ?? ""
                    
                    let model = FriendModel(name: name, surname: surname, id: String(id), profileImageURL: profilePhotoUrl)
                    observer.onNext(model)
                }
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
        
    static func getPhotosForUser(data jsonPhotosData: Data) -> Observable<PhotoModel> {
        
        if UserSession.shared.vkToken == nil || UserSession.shared.vkToken == "" {
            print("Error in getFriends(data jsonData: Data) call: No access_token")
        }
        
        return Observable<PhotoModel>.create { observer -> Disposable in
              
            guard let json = try? JSON(data: jsonPhotosData) else {
                return Disposables.create()
            }
            json[VkAPI.response.rawValue][VkAPI.items.rawValue].arrayObject?
                .map { JSON($0) }
                .forEach { photoObject in
                    guard let sizeData = photoObject[VkAPI.Photo.sizes.rawValue].array?.last else { return }
                    
                    guard let url = sizeData[VkAPI.Photo.url.rawValue].string else { return }
                    guard let likes = photoObject["likes"]["count"].int else { return }
                    
                    observer.onNext(PhotoModel(url: url, likes: likes))
                }
            print()
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}
