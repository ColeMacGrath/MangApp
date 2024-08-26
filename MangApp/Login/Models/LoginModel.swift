//
//  LoginModel.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import Foundation

@Observable
class LoginModel {
    var email: String = String() {
        didSet {
            _ = validateEmail()
        }
    }
    var password: String = String() {
        didSet {
            _ = validatePassword()
        }
    }
    var showLoadingView: Bool = false
    var showAlertView: Bool = false
    var showSignUpView: Bool = false
    var isValidPassword: Bool = true
    var isValidMail: Bool = true
    var isLoginButtonDisabled: Bool {
        return !(validateEmail() && validatePassword())
    }

    var interactor: NetworkInteractor
    
    init(interactor: NetworkInteractor = NetworkInteractor.shared) {
        self.interactor = interactor
        if isFirstLaunch() {
            interactor.isLoggedIn = false
            _ = KeychainManager.shared.deleteToken()
        }
    }
    
    init (username: String, password: String, interactor: NetworkInteractor = NetworkInteractor.shared) {
        self.email = username
        self.password = password
        self.interactor = interactor
    }
    
    func login() {
        Task {
            showLoadingView = true
            let value = await interactor.login(username: email.lowercased(), password: password)
            
            guard value == .ok else {
                showLoadingView = false
                showAlertView = true
                return
            }
            showLoadingView = false
            interactor.isLoggedIn = true
        }
    }
    
    func logOut() {
        if KeychainManager.shared.deleteToken() {
            interactor.isLoggedIn = false
            showSignUpView = false
        }
    }
    
    private func isFirstLaunch() -> Bool {
        let hasLaunchedBefore = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        guard hasLaunchedBefore else { return false }
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        return hasLaunchedBefore
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
