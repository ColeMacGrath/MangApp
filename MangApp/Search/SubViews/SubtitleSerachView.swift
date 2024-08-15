//
//  SubtitleSerachView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-14.
//

import SwiftUI

struct SubtitleSerachView: View {
    @Binding var selectionType: SearchType
    
    var body: some View {
        Text(selectionType == .author ? "Results by Author" : "Results by Title")
            .font(.callout)
            .foregroundStyle(.secondary)
            .padding()
        
    }
}

#Preview {
    SubtitleSerachView(selectionType: .constant(.author))
}
