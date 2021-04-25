//
//  LoginViewModel.swift
//  ClientVK
//
//  Created by Egor on 27.02.2021.
//

import Foundation
import RxSwift

protocol LoginViewModelProtocol {
    var model: LoginModel { get }
    var isSignInButtonEnabled: BehaviorSubject<Bool> { get set }
    func areFieldsCorrect()
}


class LoginViewModel: LoginViewModelProtocol {
    
    // Properties
    let model: LoginModel
    var isSignInButtonEnabled: BehaviorSubject<Bool>
    var bag: DisposeBag = DisposeBag()
    
    // Initializers
    init(model: LoginModel) {
        self.model = model
        isSignInButtonEnabled = BehaviorSubject(value: false)
    }
    
    func areFieldsCorrect() {
        do {
            guard let email = try model.email.value() else { return }
            guard let password = try model.password.value() else { return }
            
            let isCorrect =  email.isValid(.email) && password.isValid(.password)
            isSignInButtonEnabled.onNext(isCorrect)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func signIn(completion: @escaping (Bool, String?) -> Void) {
        model.signIn(completion: completion)
    }
}
