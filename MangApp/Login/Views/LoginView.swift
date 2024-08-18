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
                if horizontalSizeClass == .compact {
                    LoginHeader()
                        .padding(.top)
                    
                    LoginBodyView(email: $model.email, password: $model.password, isValidMail: $model.isValidMail, isValidPassword: $model.isValidPassword)
                        .padding(.top)
                    
                    Spacer()
                    RoundedActionButton(title: "Sign In", backgroundColor: .accentColor) {
                        model.login()
                    }.disabled(model.isLoginButtonDisabled)
                    
                    RoundedActionButton(title: "Sign up", backgroundColor: .pink) {
                        model.showSignUpView = true
                    }
#if !os(macOS)
                    .fullScreenCover(isPresented: $model.interactor.isLoggedIn) {
                        SelectableItemsView()
                    }
#endif
                    
                    .sheet(isPresented: $model.showSignUpView) {
                        SignUpView()
                    }
                } else {
                    HStack {
                        HalfScreenRoundedImage(image: Image(.login), width: geometry.size.width, height: geometry.size.height)
                        
                        VStack(alignment: .leading) {
                            LoginHeader()
                                .padding(.top)
                            Spacer()
                            LoginBodyView(email: $model.email, password: $model.password, isValidMail: $model.isValidMail, isValidPassword: $model.isValidPassword)
                            
                            RoundedActionButton(title: "Sign In", backgroundColor: .accentColor) {
                                if !model.isLoginButtonDisabled {
                                    model.login()
                                }
                            }
                            .padding(.top)
                            
                            RoundedActionButton(title: "Sign up", backgroundColor: .pink) {
                                model.showSignUpView = true
                            }
                            
                            Spacer()
                        }
#if !os(macOS)
                        .fullScreenCover(isPresented: $model.interactor.isLoggedIn) {
                            SelectableItemsView()
                        }
#endif
                        .sheet(isPresented: $model.showSignUpView) {
                            SignUpView()
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
