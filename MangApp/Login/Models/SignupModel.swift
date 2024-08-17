//
//  SignupModel.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-16.
//

import Foundation

@Observable
class SignUpModel {
    var email: String = "" {
        didSet {
            validateEmail()
        }
    }
    var password: String = "" {
        didSet {
            validatePassword()
        }
    }
    var confirmedPassword: String = "" {
        didSet {
            validateConfirmedPassword()
        }
    }
    var isValidMail: Bool = true
    var isValidPassword: Bool = true
    var isValidConfirmedPassword: Bool = true
    var interactor: NetworkInteractor
    var isSignUpButtonDisabled: Bool {
        return !(validateEmail() && validateEmail() && validateConfirmedPassword())
    }
    
    init(interactor: NetworkInteractor = NetworkInteractor.shared) {
        self.interactor = interactor
    }
    
    func signUp() {
        Task {
            let value = await interactor.signUp(email: email.lowercased(), password: password)
            if value == .created {
                LoginModel(username: email.lowercased(), password: password).login()
                email.removeAll()
                password.removeAll()
                confirmedPassword.removeAll()
            }
        }
    }
    
    private func validateEmail() -> Bool {
        let emailPattern = #"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}"#
        var evaluation = false
        do {
            if let _ = try email.firstMatch(of: Regex(emailPattern)) {
                evaluation = true
            } else {
                evaluation = false
            }
        } catch { }
        
        isValidMail = email.isEmpty || evaluation
        return isValidMail
    }
    
    private func validatePassword() -> Bool {
        if password.isEmpty {
            confirmedPassword.removeAll()
        }
        isValidPassword = password.isEmpty || password.count >= 8
        return password.count >= 8
    }
    
    private func validateConfirmedPassword() -> Bool {
        isValidConfirmedPassword = confirmedPassword.isEmpty || password.isEmpty || confirmedPassword == password
        return !password.isEmpty && confirmedPassword == password
    }
}
