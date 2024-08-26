//
//  MangaDetailTitlesView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

struct MangaDetailTitlesView: View {
    @Environment(OwnMangaModel.self) var model
    var manga: Manga
    
    var body: some View {
        @Bindable var model = model
        HStack {
            Text(manga.title)
                
            if model.isLoaded,
               model.ownManga?.completeCollection ?? false {
                Text(" ✅")
            }
        }
        .bold()
        .font(.title)
        .padding(.horizontal)
        
        Text(manga.titleJapanese ?? .emptyString)
            .foregroundStyle(.secondary)
            .font(.title2)
            .padding([.bottom, .horizontal])
    }
}

#Preview {
    NavigationStack {
        MangaDetailTitlesView(manga: .defaultManga)
    }
}

