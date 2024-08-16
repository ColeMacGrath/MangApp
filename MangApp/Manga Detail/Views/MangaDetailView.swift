//
//  MangaDetailView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

struct MangaDetailView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSize
    @Environment(\.presentationMode) var presentationMode
    @State private var isDetailViewPresented = false
    var manga: Manga
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack {
                    ScoreView(score: manga.score)
                    
                    AsyncMangaImageView(geometry: geometry, url: manga.mainPicture?.toURL)
                    
                    MangaDetailTitlesView(manga: manga)
                    
                    ColoredRoundedButton(title: "Add to collection") {
                        //TODO
                    }
                }
                
                if horizontalSize != .compact {
                    MangaDetailsListView(manga: manga, modalPresentation: false)
                }
            }
            .toolbar {
                if horizontalSize == .compact {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            isDetailViewPresented = true
                        } label: {
                            Image(systemName: "info.circle.fill")
                        }
                    }
                }
            }
            .sheet(isPresented: $isDetailViewPresented) {
                MangaDetailsListView(manga: manga, modalPresentation: true)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MangaDetailView(manga: Manga.defaultManga)
    }
}
