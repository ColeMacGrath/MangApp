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

    var interactor: DataInteractor

    init(interactor: DataInteractor = NetworkInteractor.shared) {
        self.interactor = interactor
    }
    
    func login() {
        Task {
            let value = await interactor.login(username: username, password: password)
            if value == .ok {
                interactor.isLoggedIn = true
            } else {
                showAlert = true
            }
        }
    }
    
    func logOut() {
        if KeychainManager.shared.deleteToken() {
            interactor.isLoggedIn = false
        }
        
    }
}
