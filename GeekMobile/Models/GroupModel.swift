//
//  GroupModel.swift
//  ClientVK
//
//  Created by Egor on 07.03.2021.
//

import Foundation

protocol GroupModelProtocol {
    var image: Data? { get set }
    var title: String { get set }
    var subtitle: String { get set }
}

class GroupModel: GroupModelProtocol {
    var image: Data?
    var title: String
    var subtitle: String
    
    init(title: String, subtitle: String, image: Data? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
}
