//
//  CurrentUser.swift
//  GeekMobile
//
//  Created by Egor on 15.03.2021.
//

import Foundation
import Firebase

class CurrentUser: GeekUser {
    
    static var shared: CurrentUser?
    
    static func initialize() {
        shared = CurrentUser()
    }
    
    private init() {
        
        guard let currentUser = Auth.auth().currentUser else {
            fatalError("Can't initizlize current user")
        }
        
        super.init(uid: currentUser.uid)
    }
}
