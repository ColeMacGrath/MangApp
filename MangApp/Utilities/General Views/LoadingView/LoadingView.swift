//
//  LoadingView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-24.
//
import SwiftUI

struct LoadingView: View {
    var fullScreen: Bool = false
    var message: String? = nil
    var color: Color = .accentColor
    
    var body: some View {
        if fullScreen {
            ZStack {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    RotatingCircles(color: color)
                        .frame(width: 100, height: 100)
                    Text(message ?? "")
                }
                .foregroundStyle(color)
            }
            .transition(.opacity)
        } else {
            VStack(alignment: .center) {
                RotatingCircles(color: color)
                    .frame(width: 200, height: 200)
                Text(message ?? "")
            }
            .padding()
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(20)
            .shadow(radius: 10)
            .transition(.scale)
            .foregroundStyle(color)
        }
    }
}

#Preview {
    LoadingView(fullScreen: true, message: "Loading...", color: .accent)
}
