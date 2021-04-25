//
//  SignUpViewModel.swift
//  GeekMobile
//
//  Created by Egor on 10.03.2021.
//

import Foundation
import RxSwift

protocol SignUpViewModelProtocol {
    var model: SignUpModel { get set }
    var isSignUpButtonEnabled: BehaviorSubject<Bool> { get set }
    func areFieldsCorrect()
}

class SignUpViewModel: SignUpViewModelProtocol {
    
    var model: SignUpModel
    var isSignUpButtonEnabled: BehaviorSubject<Bool>
    var bag: DisposeBag = DisposeBag()
    
    init(model: SignUpModel) {
        self.model = model
        isSignUpButtonEnabled = BehaviorSubject(value: false)
    }
    
    func areFieldsCorrect() {
        do {
            guard let email = try model.email.value() else { return }
            guard let name = try model.name.value() else { return }
            guard let surname = try model.surname.value() else { return }
            guard let password = try model.password.value() else { return }
            
            let isCorrect =  email.isValid(.email) && name.isValid(.name) && surname.isValid(.name) && password.isValid(.password)
            isSignUpButtonEnabled.onNext(isCorrect)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func signUp(completion: @escaping (Bool, String?) -> Void) {
        model.signUp(completion: completion)
    }
}
