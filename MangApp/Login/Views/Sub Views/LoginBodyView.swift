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
    
    var body: some View {
        Group {
            ImageTextField(text: $email, outsideTitle: "Email", image: Image(systemName: "person"), placeholderText: "Enter email")
            ImageTextField(text: $password, outsideTitle: "Password", image: Image(systemName: "lock"), placeholderText: "Enter password", isSecure: true)
        }
        .padding(.horizontal)
    }
}


#Preview {
    LoginBodyView(email: .constant(String()), password: .constant(String()))
}

