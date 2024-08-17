//
//  SignUpView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-16.
//

import SwiftUI

struct SignUpView: View {
    @Environment(SignUpModel.self) private var model
    @Environment(\.presentationMode) private var presentationMode
    
    
    var body: some View {
        @Bindable var model = model
        NavigationStack {
            LoginBodyView(email: $model.email, password: $model.password, isValidMail: $model.isValidMail, isValidPassword: $model.isValidPassword)
                .padding(.top)
            ImageTextField(text: $model.confirmedPassword, isValid: $model.isValidConfirmedPassword, outsideTitle: "Confirm password", image: Image(systemName: "lock"), placeholderText: "Enter password", invalidMessage: "Password doesn't match", isSecure: true)
                .padding(.horizontal)
            Spacer()
            RoundedActionButton(title: "Sign Up", backgroundColor: .accentColor) {
                model.signUp()
            }.disabled(model.isSignUpButtonDisabled)
            .padding(.vertical)
            .navigationTitle("Enter your details")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }.buttonStyle(.automatic)
                }
            }
        }
    }
}

#Preview {
    SignUpView()
        .environment(SignUpModel())
}
