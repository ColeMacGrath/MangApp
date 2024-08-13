//
//  MangaDetailView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

struct MangaDetailView: View {
    @Environment(\.isOnPreview) private var isOnPreview: Bool
    @Environment(\.horizontalSizeClass) private var horizontalSize
    @Environment(\.presentationMode) var presentationMode
    @State private var isDetailViewPresented = false
    var manga: Manga
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack {
                    ScoreView(score: manga.score)
                    
                    if let url = manga.mainPicture?.toURL,
                       !isOnPreview {
                        AsyncMangaImageView(geometry: geometry, url: url)
                    } else {
#if os(macOS)
                        Image("manga_cover_image")
                            .resizable()
                            .aspectRatio(0.66, contentMode: .fit)
                            .mask(RoundedRectangle(cornerRadius: 10.0))
                            .padding()
#else
                        Image(.mangaCover)
                            .resizable()
                            .aspectRatio(0.66, contentMode: .fit)
                            .mask(RoundedRectangle(cornerRadius: 10.0))
                            .padding()
#endif
                        
                    }
                    
                    MangaDetailTitlesView(manga: manga)
                    Button(action: {
                        //TODO
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10.0)
                                .foregroundStyle(.purple)
                            Text("Add to collection")
                                .bold()
                                .foregroundStyle(.white)
                        }.frame(maxHeight: 50.0)
                    }).padding()
                }
                
                if horizontalSize != .compact {
                    MangaDetailsListView(manga: manga, modalPresentation: false)
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isDetailViewPresented = true
                    } label: {
                        Image(systemName: "info.circle.fill")
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










