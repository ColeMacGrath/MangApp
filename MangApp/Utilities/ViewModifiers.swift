//
//  ViewModifiers.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import Foundation
import SwiftUI

struct ButtonStyleModifier: ViewModifier {
    var backgroundColor: Color = .pink
    var foregroundColor: Color = .white
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(foregroundColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(10)
        
    }
}

struct BouncyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: configuration.isPressed)
    }
}

struct LoadingAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    var message: String?
    var color: Color = .accentColor
    var fullscreen: Bool = false
    
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isPresented)
            
            if isPresented {
                LoadingView(fullScreen: fullscreen, message: message, color: color)
                    .transition(.opacity)
                    .animation(.easeInOut, value: isPresented)
            }
        }
    }
}

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    var message: String
    var mode: AlertType
    
    @State private var dragOffset = CGSize.zero
    @State private var opacity: Double = 1.0
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                VStack {
                    Spacer()
                    Text(message)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(mode.backgroundColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .padding()
                        .offset(y: dragOffset.height)
#if os(iOS)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation
                                }
                                .onEnded { value in
                                    if value.translation.height > 100 {
                                        withAnimation {
                                            opacity = 0.0
                                            isPresented = false
                                        }
                                    } else {
                                        withAnimation {
                                            dragOffset = .zero
                                        }
                                    }
                                }
                        )
#endif
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 0.5)) {
                                dragOffset = .zero
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    opacity = 0.0
                                    isPresented = false
                                    resetState()
                                }
                            }
                        }
                        .transition(.move(edge: .bottom))
                }
                .edgesIgnoringSafeArea(.bottom)
                .opacity(opacity)
            }
        }
    }
    
    private func resetState() {
        dragOffset = .zero
        opacity = 1.0
    }
}
