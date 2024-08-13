//
//  MangaItemView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

struct MangaItemView: View {
    var manga: Manga
    @Environment(\.isOnPreview) private var isOnPreview: Bool
    @State private var isPressed = false
    
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
#if os(macOS)
                Image("manga_cover_image")
                    .mangaViewImageModifier()
#else
                Image(.mangaCover)
                    .mangaViewImageModifier()
#endif
                    
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
