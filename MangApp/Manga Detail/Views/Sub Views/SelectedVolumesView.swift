//
//  SelectedVolumesView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-18.
//

import SwiftUI

struct SelectedVolumesView: View {
    @Environment(OwnMangaModel.self) private var model
    var body: some View {
        @Bindable var model = model
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
            ForEach(1...(model.ownManga?.manga.volumes ?? model.manga?.volumes ?? 0), id: \.self) { volume in
                Button {
                    model.append(volume: volume)
                } label: {
                    Circle()
                        .fill(((model.selectedVolumes!.contains(volume))) ? Color.accentColor : Color.gray)
                        .overlay(
                            Text(String(volume))
                                .foregroundColor(.white)
                        )
                }
            }
        }
    }
}

#Preview {
    SelectedVolumesView()
}
