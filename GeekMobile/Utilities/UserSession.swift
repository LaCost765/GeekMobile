//
//  UserSession.swift
//  GeekMobile
//
//  Created by Egor on 15.04.2021.
//

import Foundation

class UserSession {
    
    static var shared: UserSession = UserSession()
    
    public var vkToken: String?
    public var userID: Int?
    
    private init() {
        
    }
}
