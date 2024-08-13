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
#if os(macOS)
                .foregroundStyle(Color(.labelColor))
#else
                .foregroundStyle(Color(.label))
#endif
                .bold()
            Text(subtitle)
        }
    }
}

#Preview {
    SubtitleRowView(title: "Title", subtitle: "Subtitle")
}
