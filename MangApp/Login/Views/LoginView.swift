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
            Color(.loginBackground)
                .edgesIgnoringSafeArea(.all)
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
#if os(iOS)
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
#if os(iOS)
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
            .loadingView(isPresented: $model.showLoadingView, message: "logging in", fullScreen: true)
            .alertView(isPresented: $model.showAlertView, message: "Oops, an error ocurred at loggin in, try agin", mode: .error)
        }
        
    }
}

#Preview {
    LoginView()
        .environment(LoginModel())
}
