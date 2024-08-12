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
        TextField("Enter username", text: $email)
            .modifier(SemiTransparentModifier())
        SecureField("Enter password", text: $password)
            .modifier(SemiTransparentModifier())
    }
}

#Preview {
    LoginBodyView(email: .constant(String()), password: .constant(String()))
}
