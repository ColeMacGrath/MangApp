//
//  SearchBar.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-12.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        TextField("Search...", text: $text)
            .padding(7)
            .background(Color(.systemGray))
            .cornerRadius(8)
            .padding(.horizontal, 10)
    }
}


#Preview {
    SearchBar(text: .constant(""))
}
