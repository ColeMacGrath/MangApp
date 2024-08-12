//
//  SubtitleRowView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import SwiftUI

struct SubtitleRowView: View {
    var title: String
    var subtitle: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundStyle(Color(uiColor: .label))
                .bold()
            Text(subtitle)
        }
    }
}

#Preview {
    SubtitleRowView(title: "Title", subtitle: "Subtitle")
}
