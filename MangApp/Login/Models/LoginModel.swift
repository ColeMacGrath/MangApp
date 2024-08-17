//
//  LoginModel.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import Foundation

@Observable
class LoginModel {
    var username: String = ""
    var password: String = ""
    var showAlert: Bool = false
    var showSignUpView: Bool = false
    var interactor: NetworkInteractor

    init(interactor: NetworkInteractor = NetworkInteractor.shared) {
        self.interactor = interactor
    }
    
    init (username: String, password: String, interactor: NetworkInteractor = NetworkInteractor.shared) {
        self.username = username
        self.password = password
        self.interactor = interactor
    }
    
    func login() {
        Task {
            let value = await interactor.login(username: username, password: password)
            
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
}
