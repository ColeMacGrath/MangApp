//
//  LoginBodyView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

struct LoginBodyView: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var isValidMail: Bool
    @Binding var isValidPassword: Bool
    
    var body: some View {
        Group {
            ImageTextField(text: $email, isValid: $isValidMail, outsideTitle: "Email", image: Image(systemName: "person"), placeholderText: "Enter email", invalidMessage: "Invalid email")
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
            ImageTextField(text: $password, isValid: $isValidPassword, outsideTitle: "Password", image: Image(systemName: "lock"), placeholderText: "Enter password", invalidMessage: "Password must be at least 8 characters", isSecure: true)
        }
        .padding(.horizontal)
    }
}


#Preview {
    LoginBodyView(email: .constant(.emptyString), password: .constant(.emptyString), isValidMail: .constant(false), isValidPassword: .constant(false))
}

