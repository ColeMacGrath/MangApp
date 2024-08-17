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
        VStack(alignment: .leading) {
            Text("Hey, There 👋\nFind you favorites mangas here")
                .bold()
                .font(.largeTitle)
            Text("Enter you email adderss and password to login")
                .font(.title2)
                .foregroundStyle(.secondary)
        }.minimumScaleFactor(0.5)
    }
}

#Preview {
    LoginHeader()
}

