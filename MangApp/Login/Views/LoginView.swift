//
//  LoginView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import SwiftUI

struct LoginView: View {
    @Environment(LoginModel.self) private var model
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    var body: some View {
        @Bindable var model = model
        GeometryReader { geometry in
#if !os(visionOS)
            Color(.loginBackground)
                .edgesIgnoringSafeArea(.all)
#endif
            VStack {
                if horizontalSizeClass == .compact,
                   geometry.size.width < geometry.size.height {
                    LoginHeader()
                    Spacer()
                    LoginBodyView(email: $model.username, password: $model.password)
                    
                    RoundedActionButton(title: "Sign In", backgroundColor: .purple) {
                        model.login()
                    }
                    
                    RoundedActionButton(title: "Sign up", backgroundColor: .pink) {
                        //
                    }
#if !os(macOS)
                    .fullScreenCover(isPresented: $model.interactor.isLoggedIn) {
                        SelectableItemsView()
                    }
#endif
                    Spacer()
                    
                } else {
                    Spacer()
                    HStack {
                        HalfScreenRoundedImage(image: Image(.login), width: geometry.size.width, height: geometry.size.height)
                        
                        VStack {
                            Spacer()
                            LoginHeader()
                            LoginBodyView(email: $model.username, password: $model.password)
                            
                            RoundedActionButton(title: "Sign In", backgroundColor: .purple) {
                                model.login()
                            }
                            
                            RoundedActionButton(title: "Sign up", backgroundColor: .pink) {
                            }
#if !os(macOS)
                            .fullScreenCover(isPresented: $model.interactor.isLoggedIn) {
                                SelectableItemsView()
                            }
#endif
                            Spacer()
                        }
                    }
                }
            }
        }.alert(isPresented: $model.showAlert) {
            Alert(
                title: Text("Important message"),
                message: Text("This is an alert message."),
                dismissButton: .default(Text("Got it!"))
            )
        }
    }
}

#Preview {
    LoginView()
        .environment(LoginModel())
}
