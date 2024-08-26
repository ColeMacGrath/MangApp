//
//  ErrorView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-14.
//

import SwiftUI

struct ErrorView: View {
    var title: String = "Whoops!"
    var subtitle: String = "Something didn’t work as expected"
    var button: ColoredRoundedButton
    
    var body: some View {
        VStack(alignment: .center) {
            Image(.phoneAlert)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 250)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color.accentColor)
                Text(subtitle)
                    .font(.title2)
                button
            }
        }
    }
}

#Preview {
    ErrorView(button: ColoredRoundedButton(title: .emptyString, action: {}))
}
