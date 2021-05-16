//
//  GroupModel.swift
//  ClientVK
//
//  Created by Egor on 07.03.2021.
//

import Foundation
import RxSwift

protocol GroupModel {
    var id: Int { get set }
    var name: String { get set }
    var photoUrl: String { get set }
    
    func loadPhoto() -> Observable<Data>
}

class GroupModelImpl: GroupModel {
    
    var id: Int
    var name: String
    var photoUrl: String
    
    init(id: Int, name: String, photoUrl: String) {
        self.id = id
        self.name = name
        self.photoUrl = photoUrl
    }
    
    func loadPhoto() -> Observable<Data> {
        
        return NetworkManager.shared.makeRequest(url: photoUrl)
    }
    
}
