//
//  ViewModifiers.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import Foundation
import SwiftUI

struct SemiTransparentModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(.roundedBorder)
            .opacity(0.7)
            .padding(.horizontal)
    }
}

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

struct DefaultImagePlaceholder: ViewModifier {
    var isLoader: Bool
    
    init(isLoader: Bool = false) {
        self.isLoader = isLoader
    }
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .foregroundStyle(.gray)
                .overlay {
                    if isLoader {
                        ProgressView()
                            .font(.largeTitle)
                    } else {
                        Image(systemName: "book.circle")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                    }
                }
        }
        .aspectRatio(0.66, contentMode: .fit)
        .padding()
    }
}

struct BouncyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: configuration.isPressed)
    }
}
