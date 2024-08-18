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
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(foregroundColor)
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .cornerRadius(10)
                .padding([.horizontal, .top])
        }
    }
}


#Preview {
    ColoredRoundedButton(title: "Button", action: {})
}
