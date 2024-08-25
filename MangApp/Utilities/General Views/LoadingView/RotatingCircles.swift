//
//  RotatingCircles.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-24.
//

import SwiftUI

struct RotatingCircles: View {
    @State private var isAnimating = false
    var color: Color = .accentColor
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .opacity(0.5)
                .frame(width: 30, height: 30)
                .offset(x: -40, y: 0)
                .rotationEffect(.degrees(isAnimating ? 360 : 0), anchor: .center)
            
            Circle()
                .fill(color)
                .frame(width: 30, height: 30)
                .offset(x: 40, y: 0)
                .rotationEffect(.degrees(isAnimating ? -360 : 0), anchor: .center)
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                isAnimating.toggle()
            }
        }
    }
}

#Preview {
    RotatingCircles()
}
