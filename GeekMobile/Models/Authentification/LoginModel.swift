//
//  LoginDataModel.swift
//  ClientVK
//
//  Created by Egor on 27.02.2021.
//

import Foundation
import Firebase
import RxSwift

protocol LoginModelProtocol {
    var email: BehaviorSubject<String?> { get set }
    var password: BehaviorSubject<String?> { get set }
}

class LoginModel: LoginModelProtocol {
    
    //MARK: Properties
    var email: BehaviorSubject<String?>
    var password: BehaviorSubject<String?>
    
    init() {
        email = BehaviorSubject(value: "")
        password = BehaviorSubject(value: "")
    }
    
    func signIn(completion: @escaping (Bool, String?) -> Void) {
        
        guard case let email?? = self.email.safeValue(),
              case let password?? = self.password.safeValue() else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            
          guard let strongSelf = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
                completion(false, error.localizedDescription)
                return
            }
            
            completion(true, nil)
          // ...
        }
    }
}
