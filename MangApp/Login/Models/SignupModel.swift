//
//  SignupModel.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-16.
//

import Foundation

@Observable
class SignUpModel {
    var email: String = ""
    var password: String = ""
    var confirmedPassword: String = ""
    var interactor: NetworkInteractor
    
    init(interactor: NetworkInteractor = NetworkInteractor.shared) {
        self.interactor = interactor
    }
    
    func signUp() {
        Task {
            let value = await interactor.signUp(email: email, password: password)
            if value == .created {
                LoginModel(username: email, password: password).login()
                email.removeAll()
                password.removeAll()
                confirmedPassword.removeAll()
            }
        }
    }
}
