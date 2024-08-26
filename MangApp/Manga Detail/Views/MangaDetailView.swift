//
//  MangaDetailView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

struct MangaDetailView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSize
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.modelContext) private var modelContext
    @Environment(OwnMangaModel.self) private var model
    @Environment(CollectionModel.self) private var collectionModel
    @State private var contentHeight: CGFloat = 0
    @State private var isDetailViewPresented = false
    @State private var isEditPresented = false
    var manga: Manga
    
    init(manga: Manga) {
        self.manga = manga
    }
    
    var body: some View {
        @Bindable var model = model
        GeometryReader { geometry in
            HStack {
                VStack {
                    ScoreView(score: manga.score)
                    
                    AsyncMangaImageView(geometry: geometry, url: manga.mainPicture?.toURL)
                    
                    MangaDetailTitlesView(manga: manga)
                        .environment(model)
                    
                    if !model.isLoaded {
                        ColoredRoundedButton(title: "Loading", asLoader: true, action: {})
                            .padding(.bottom)
                    } else if model.ownManga != nil {
                        ColoredRoundedButton(title: "Remove from collection") {
                            Task {
                                if await model.delete(manga: manga, context: modelContext) {
                                    collectionModel.remove(manga: manga)
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }.padding(.bottom)
                    } else if model.isLoaded {
                        ColoredRoundedButton(title: "Add to collection") {
                            if let volumes = manga.volumes,
                               volumes > 0 {
                                isEditPresented = true
                            } else {
                                Task {
                                    _ = await model.save(manga: manga, context: modelContext)
                                }
                            }
                            
                        }.padding(.bottom)
                    }
                }
                
                if horizontalSize != .compact {
                    MangaDetailsListView(manga: manga, modalPresentation: false)
                }
            }
            .onAppear {
                model.loadOwn(manga: manga, offline: collectionModel.offline, context: modelContext)
            }
            .toolbar {
                if model.ownManga != nil {
                    ToolbarItem(placement: .topBarLeading) {
                        if let volumes = manga.volumes,
                           volumes > 0 {
                            Button {
                                isEditPresented = true
                            } label: {
                                Image(systemName: "square.and.pencil")
                            }
                        }
                    }
                }
                
                if horizontalSize == .compact {
                    ToolbarItem(placement: .topBarTrailing) {
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
            .sheet(isPresented: $isEditPresented) {
                EditMangaInfoView()
                    .environment(self.model)
                    .presentationDetents([.fraction(0.4), .medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MangaDetailView(manga: Manga.defaultManga)
            .environment(OwnMangaModel(manga: .defaultManga, ownManga: OwnManga(id: .emptyString, volumesOwned: [1], completeCollection: false, readingVolume: 1, manga: Manga.defaultManga)))
    }
}
