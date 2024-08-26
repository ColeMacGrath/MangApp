//
//  SearchBar.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-12.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onCommit: () -> Void
    
    var body: some View {
        TextField("Search...", text: $text, onCommit: onCommit)
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray5))
            .cornerRadius(8)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    
                    if !text.isEmpty {
                        Button(action: {
                            self.text.removeAll()
                        }) {
                            Image(systemName: "multiply.circle.fill")
                        }
                        .padding(.trailing, 8)
                    }
                }
            )
    }
}


#Preview {
    SearchBar(text: .constant(.emptyString), onCommit: {})
}
