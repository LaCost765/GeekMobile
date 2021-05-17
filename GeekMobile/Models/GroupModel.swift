//
//  GroupModel.swift
//  ClientVK
//
//  Created by Egor on 07.03.2021.
//

import Foundation
import RxSwift
import RealmSwift

//protocol GroupModel: Object, Decodable {
//    dynamic var id: Int { get set }
//    dynamic var name: String { get set }
//    dynamic var photoUrl: String { get set }
//
//    func loadPhoto() -> Observable<Data>
//}

class GroupModel: Object, Decodable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var photoUrl: String = ""
    
    override init() { }
    
    init(id: Int, name: String, photoUrl: String) {
        self.id = id
        self.name = name
        self.photoUrl = photoUrl
    }
    
    func loadPhoto() -> Observable<Data> {
        
        return NetworkManager.shared.makeRequest(url: photoUrl)
    }
    
}
