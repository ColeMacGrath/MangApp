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
        .padding(.horizontal)
    }
}

#Preview {
    RoundedActionButton(title: "Button Text", backgroundColor: .accent, action: {})
}
