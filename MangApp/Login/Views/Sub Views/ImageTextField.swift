//
//  ImageTextField.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-16.
//

import SwiftUI

struct ImageTextField: View {
    @Binding var text: String
    @Binding var isValid: Bool
    var outsideTitle: String?
    var image: Image?
    var placeholderText: String?
    var invalidMessage: String?
    var isSecure = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if let outsideTitle {
                Text(outsideTitle)
                    .foregroundStyle(.secondary)
            }
            HStack {
                if let image {
                    image.padding()
                }
                
                if isSecure {
                    SecureField(placeholderText ?? "", text: $text)
                } else {
                    TextField(placeholderText ?? "", text: $text)
                }
                
            }.overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 0.5)
            ).foregroundColor(.accentColor)
            if !isValid,
                let invalidMessage {
                Text(invalidMessage)
                    .foregroundStyle(.red)
            }
        }
       
    }
}

#Preview {
    ImageTextField(text: .constant(""), isValid: .constant(false), outsideTitle: "Outside Title", image: Image(systemName: "person"), invalidMessage: "Invalid Message")
        .padding()
}
