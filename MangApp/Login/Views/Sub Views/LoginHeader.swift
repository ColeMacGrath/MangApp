//
//  LoginHeader.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

struct LoginHeader: View {
    var body: some View {
        welcomeMessage()
    }
    
    @ViewBuilder
    func welcomeMessage() -> some View {
        Text("Welcome Back")
            .bold()
            .font(.largeTitle)
        Text("We've missed you tracking mangas")
            .font(.title2)
            .foregroundStyle(.secondary)
    }
}

#Preview {
    LoginHeader()
}

