//
//  AuthorProfilePlaceHolder.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-15.
//

import SwiftUI

struct AuthorProfilePlaceHolder: View {
    var author: Author
    var body: some View {
        Circle()
            .fill(Color(.tertiarySystemFill))
            .overlay(Text(author.initials))
            .foregroundColor(.white)
            .font(.system(size: 24, weight: .bold))
            .frame(width: 80)
        Text(author.fullName)
    }
}

#Preview {
    AuthorProfilePlaceHolder(author: Author(id: .emptyString, lastName: "Last Name", firstName: "First Name", role: .emptyString))
}
