//
//  FriendModel.swift
//  ClientVK
//
//  Created by Egor on 06.03.2021.
//

import Foundation

protocol FriendProtocol {
    var name: String { get set }
    var surname: String { get set }
    var profileImage: Data? { get set }
    var userPhotos: [Data?] { get set }
    var photosCount: Int { get set }
}

class FriendModel: FriendProtocol {
    
    var name: String
    var surname: String
    var profileImage: Data?
    var userPhotos: [Data?]  = []
    var photosCount: Int
    private let imagesUrl = "https://picsum.photos/300"
    
    init(name: String, surname: String, photosCount: Int = 0, image: Data? = nil) {
        self.name = name
        self.surname = surname
        self.profileImage = image
        self.photosCount = photosCount
    }
    
    func getFullName() -> String {
        return "\(name) \(surname)"
    }
    
    func setFullName(fullName: String) {
        let pair = fullName.components(separatedBy: " ")
        if pair.count == 2 {
            name = pair[0]
            surname = pair[1]
        } else {
            print("Incorrect full name: \(fullName)")
        }
    }
    
    func loadImages() {

        if self.userPhotos.count < self.photosCount {
            loadImage(from: imagesUrl)
        }
    }
    
    func loadImage(from url: String) {
        
        if let url = URL(string: url) {
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, resp, err in
                guard let data = data, err == nil else { return }
                self?.userPhotos.append(data)
                self?.loadImages()
            }
            
            task.resume()
        }
    }
}
