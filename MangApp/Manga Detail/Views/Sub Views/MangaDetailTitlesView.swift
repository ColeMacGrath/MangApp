//
//  MangaDetailTitlesView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

struct MangaDetailTitlesView: View {
    var manga: Manga
    var body: some View {
        Text(manga.title)
            .bold()
            .font(.title)
        Text(manga.titleJapanese ?? "")
            .foregroundStyle(.secondary)
            .font(.title2)
            .padding(.bottom)
    }
}

#Preview {
    NavigationStack {
        MangaDetailTitlesView(manga: Manga.defaultManga)
    }
}

