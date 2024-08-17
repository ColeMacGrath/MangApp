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
            LoginBodyView(email: $model.email, password: $model.password)
                .padding(.top)
            ImageTextField(text: $model.confirmedPassword, outsideTitle: "Confirm password", image: Image(systemName: "lock"), placeholderText: "Enter password", isSecure: true)
                .padding(.horizontal)
            Spacer()
            RoundedActionButton(title: "Sign Up", backgroundColor: .accentColor) {
                model.signUp()
            }
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
