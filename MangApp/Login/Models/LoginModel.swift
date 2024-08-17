//
//  LoginModel.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import Foundation

@Observable
class LoginModel {
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
    var showAlert: Bool = false
    var showSignUpView: Bool = false
    var isValidPassword: Bool = true
    var isValidMail: Bool = true
    var isLoginButtonDisabled: Bool {
        return !(validateEmail() && validatePassword())
    }

    var interactor: NetworkInteractor
    
    init(interactor: NetworkInteractor = NetworkInteractor.shared) {
        self.interactor = interactor
    }
    
    init (username: String, password: String, interactor: NetworkInteractor = NetworkInteractor.shared) {
        self.email = username
        self.password = password
        self.interactor = interactor
    }
    
    func login() {
        Task {
            let value = await interactor.login(username: email.lowercased(), password: password)
            
            guard value == .ok else {
                showAlert = true
                return
            }
            interactor.isLoggedIn = true
        }
    }
    
    func logOut() {
        if KeychainManager.shared.deleteToken() {
            interactor.isLoggedIn = false
            showSignUpView = false
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
        } catch {}
        
        isValidMail = evaluation || email.isEmpty
        return isValidMail
    }
    
    private func validatePassword() -> Bool {
        isValidPassword = password.count >= 8 || password.count == 0
        return password.count >= 8
    }
}
