//
//  RoundedActionButton.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

struct RoundedActionButton: View {
    var title: String
    var backgroundColor: Color
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .applyButtonStyle(backgroundColor: backgroundColor)
        }
#if !os(iOS)
        .buttonStyle(ClearButtonStyle())
#endif
        .padding(.horizontal)
    }
}

struct ClearButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.clear)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

#Preview {
    RoundedActionButton(title: "Button Text", backgroundColor: .accent, action: {})
}
