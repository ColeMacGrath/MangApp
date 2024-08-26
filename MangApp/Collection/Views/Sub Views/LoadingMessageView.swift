//
//  LoadingMessageView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-25.
//

import SwiftUI

struct LoadingMessageView: View {
    var body: some View {
        HStack(alignment: .center) {
            ProgressView()
            Text("Loading...")
        }.foregroundStyle(.secondary)
    }
}

#Preview {
    LoadingMessageView()
}
