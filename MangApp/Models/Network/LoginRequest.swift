//
//  LoginRequest.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let user: UserResponse
}

struct UserResponse: Codable {
    let authToken: String
}

struct SignUpRequest: Codable {
    let email: String
    let password: String
}
