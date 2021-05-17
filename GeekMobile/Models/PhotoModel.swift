//
//  PhotoModel.swift
//  GeekMobile
//
//  Created by Egor on 13.03.2021.
//

import Foundation
import RxSwift
import RealmSwift

class PhotoModel: Object, Decodable {
    
    @objc dynamic var likes: Int = 0
    @objc dynamic var data: Data?
    @objc dynamic var url: String = ""
    
    override init() { }
    
    init(url: String, likes: Int) {
        
        self.likes = likes
        self.url = url
    }
    
    func loadPhotoData() -> Observable<Data> {
        
        return NetworkManager.shared.makeRequest(url: url)
    }
}
