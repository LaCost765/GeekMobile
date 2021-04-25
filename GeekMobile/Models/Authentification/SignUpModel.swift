//
//  SignUpModel.swift
//  GeekMobile
//
//  Created by Egor on 10.03.2021.
//

import Foundation
import Firebase
import RxSwift

protocol SignUpModelProtocol {
    var email: BehaviorSubject<String?> { get set }
    var name: BehaviorSubject<String?> { get set }
    var surname: BehaviorSubject<String?> { get set }
    var password: BehaviorSubject<String?> { get set }
}

class SignUpModel: SignUpModelProtocol {
    
    //MARK: Properties
    var email: BehaviorSubject<String?>
    var name: BehaviorSubject<String?>
    var surname: BehaviorSubject<String?>
    var password: BehaviorSubject<String?>
    
    init() {
        email = BehaviorSubject(value: "")
        name = BehaviorSubject(value: "")
        surname = BehaviorSubject(value: "")
        password = BehaviorSubject(value: "")
    }
    
    func signUp(completion: @escaping (Bool, String?) -> Void) {
        
        guard case let email?? = self.email.safeValue(),
              case let name?? = self.name.safeValue(),
              case let surname?? = self.surname.safeValue(),
              case let password?? = self.password.safeValue() else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(false, error.localizedDescription)
                return
            }
            
            guard let user = authResult?.user else {
                print("No user data")
                return
            }
        
            
            let fbManager = FirebaseManager(userUID: user.uid)
            fbManager.configureDefaultUserState(name: "\(name) \(surname)")
            completion(true, nil)
        }
        
    }
}


