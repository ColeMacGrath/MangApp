//
//  ContentView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import SwiftUI

struct InitialView: View {
    @Environment(LoginModel.self) private var model
    
    var body: some View {
        @Bindable var model = model
        
        if KeychainManager.shared.hasToken {
            SelectableItemsView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    InitialView()
        .environment(LoginModel())
}
