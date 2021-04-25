//
//  LoginViewController.swift
//  ClientVK
//
//  Created by Egor on 27.02.2021.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIScrollableViewController {

    @IBOutlet weak var emailView: UITitleTextErrorView!
    @IBOutlet weak var passwordView: UITitleTextErrorView!
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel: LoginViewModel = LoginViewModel(model: LoginModel())

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        bindViewModel()
    }
    
    func bindViewModel() {

        viewModel.isSignInButtonEnabled.bind(to: loginButton.rx.isEnabled).disposed(by: viewModel.bag)
        emailView.textField.rx.text.bind(to: viewModel.model.email).disposed(by: viewModel.bag)
        passwordView.textField.rx.text.bind(to: viewModel.model.password).disposed(by: viewModel.bag)
    }
    
    func configureSubviews() {
        emailView.textType = .email
        passwordView.textType = .password
        
        emailView.handleTextFieldChanged = viewModel.areFieldsCorrect
        passwordView.handleTextFieldChanged = viewModel.areFieldsCorrect
        
    }
    
    @IBAction func successfullSignUp(segue: UIStoryboardSegue) {
        self.showNotificationAlert(title: "Регистрация прошла успешно!",
                                   message: "Войдите в систему с созданной учетной записью",
                                   buttonTitle: "Отлично")
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        viewModel.signIn { success, message in
            if success {
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar") as! UITabBarController
                self.view.window?.rootViewController = viewController
                self.view.window?.makeKeyAndVisible()
                //self.performSegue(withIdentifier: "successfullSignIn", sender: sender)
                
            } else {
                self.showNotificationAlert(title: "Ошибка входа!",
                                           message: message ?? "Что-то пошло не так, повторите попытку",
                                           buttonTitle: "Отмена",
                                           style: .destructive)
            }
        }
    }
}


