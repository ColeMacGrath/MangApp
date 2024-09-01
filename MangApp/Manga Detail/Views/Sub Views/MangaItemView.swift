//
//  MangaItemView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

struct MangaItemView: View {
    var manga: Manga
    
    var body: some View {
        VStack {
            if let URL = manga.mainPicture?.toURL,
               !isOnPreview {
                AsyncImage(url: URL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .mangaViewImageModifier()
                    case .empty:
                        RoundedRectangle(cornerRadius: 8)
                            .modifier(DefaultImagePlaceholder(isLoader: true))
                    default:
                        RoundedRectangle(cornerRadius: 8)
                            .modifier(DefaultImagePlaceholder())
                    }
                }
            } else {
                Image(.mangaCover)
                    .mangaViewImageModifier()
            }
            Text(manga.title)
                .font(.headline)
                
            if let genre = manga.genres.first?.genre {
                Text(genre)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .lineLimit(1)
        .minimumScaleFactor(0.7)
    }
}

#Preview {
    MangaItemView(manga: Manga.defaultManga)
}
