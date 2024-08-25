//
//  SignupModel.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-16.
//

import Foundation

@Observable
class SignUpModel {
    var showLoadingView = false
    var showAlertView = false
    var alertMessage = ""
    var alertType: AlertType = .error
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
    
    @MainActor
    func signUp() {
        Task {
            showLoadingView = true
            let value = await interactor.signUp(email: email.lowercased(), password: password)
            guard value == .created else {
                showLoadingView = false
                alertMessage = "Oops, an error ocurred at sign up, try agin"
                alertType = .error
                showAlertView = true
                return
            }
            
            let loginValue = await interactor.login(username: email.lowercased(), password: password)
            guard loginValue == .ok else {
                showLoadingView = false
                alertMessage = "Account created, but ocurred an error at login"
                alertType = .warning
                showAlertView = true
                return
            }
            
            showLoadingView = false
            interactor.isLoggedIn = true
            email.removeAll()
            password.removeAll()
            confirmedPassword.removeAll()
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
