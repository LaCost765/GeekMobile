//
//  NewsItemModel.swift
//  GeekMobile
//
//  Created by Egor on 25.03.2021.
//

import Foundation

class NewsItemModel {
    
    var text: String
    var image: Data?
    var likes: Int
    var comments: Int
    var reposts: Int
    var views: Int
    
    init(text: String, image: Data?, likes: Int, comments: Int, reposts: Int, views: Int) {
        
        self.text = text
        self.image = image
        self.likes = likes
        self.comments = comments
        self.reposts = reposts
        self.views = views
    }
}
