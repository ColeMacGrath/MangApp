//
//  ImageTextField.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-16.
//

import SwiftUI

struct ImageTextField: View {
    @Binding var text: String
    var outsideTitle: String?
    var image: Image?
    var placeholderText: String?
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
        }
       
    }
}

#Preview {
    ImageTextField(text: .constant(""), outsideTitle: "Outside Title", image: Image(systemName: "person"))
        .padding()
}
