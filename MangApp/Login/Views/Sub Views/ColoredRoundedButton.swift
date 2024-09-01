//
//  ColoredRoundedButton.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import Foundation
import SwiftUI

struct ColoredRoundedButton: View {
    var title: String
    var backgroundColor: Color = .accentColor
    var foregroundColor: Color = .white
    var asLoader: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                HStack {
                    if asLoader {
                        ProgressView()
                            .padding(.horizontal, 4)
                    }
                    Text(title)
                }
            }
            .padding()
            .tint(foregroundColor)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .disabled(asLoader)
#if !os(iOS)
        .buttonStyle(ClearButtonStyle())
#endif
    }
}


#Preview {
    ColoredRoundedButton(title: "Loading...", asLoader: true, action: {})
}
