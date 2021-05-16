//
//  API.swift
//  GeekMobile
//
//  Created by Egor on 25.04.2021.
//

import Foundation

enum VkAPI: String {
    
    case response
    case items
    case count
    case token = "access_token"
    case v
    
    enum Constants: String {
        case url = "https://api.vk.com/method"
        case v = "5.130"
    }
    
    enum Friend: String {
        case name = "first_name"
        case surname = "last_name"
        case id
        case fields
        case photo = "photo_200_orig"
    }
    
    enum Photo: String {
        case id = "owner_id"
        case sizes
        case url
        case extended
        case likes
        case count
    }
    
    enum Group: String {
        case q
        case id
        case extended
        case name
        case photo = "photo_200"
    }
}
