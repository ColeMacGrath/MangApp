//
//  Collection.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import SwiftUI

struct MangasCollectonView: View {
    @Namespace private var namespace
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(CollectionModel.self) private var model
    @Environment(\.modelContext) private var modelContext
    @State private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    @State private var showOfflineModeModal: Bool = false
    var title: String
    
    var body: some View {
        @Bindable var model = model
        if model.showErrorView {
            ErrorView(title: "An error occurred while loading authors.", button: ColoredRoundedButton(title: "Retry", action: {
                model.isDataLoaded = false
                model.loadInitialMangas(context: modelContext)
            })).padding()
        } else if model.mangaList.isEmpty && model.ownMangas.isEmpty,
                  model.isLoading {
            LoadingMessageView()
        } else {
            GeometryReader { geometry in
                ScrollView {
                    if model.offline {
                        HStack {
                            SearchBar(text: $model.searchText) {
                                model.filterMangas()
                            }
                            .padding(.leading)
                            FilterMenu(genres: model.availableGenres, selectedGenres: $model.selectedGenres, demographics: model.availableDemographics, selectedDemographics: $model.selectedDemographics, themes: model.availableThemes, selectedThemes: $model.selectedThemes, resetAction: {
                                model.resetToInitialState(context: modelContext)
                            })
                        }
                        
                        if !model.searchText.isEmpty {
                            SearchPicker(selectionType: $model.selectedSearchType)
                                .padding(.horizontal)
                                .onChange(of: model.selectedSearchType) {
                                    model.filterMangas()
                                }
                        }
                    }
                    LazyVGrid(columns: columns) {
                        ForEach(getCurrentMangas()) { manga in
                               
                            NavigationLink(destination: MangaDetailView(manga: manga)
                                .navigationTransition(.zoom(sourceID: manga.mainPictureURL, in: namespace))
                                .environment(self.model)) {
                                    MangaItemView(manga: manga)
                                        
                                        .onAppear {
                                            if manga == model.mangaList.last {
                                                model.loadMoreMangas()
                                            }
                                        }
                                }
                                
                        }
                    }
                    
                }
                .toolbar {
                    if model.collectionType == .collection {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                if model.offline {
                                    model.loadOfflineManas()
                                } else {
                                    showOfflineModeModal = true
                                }
                            }) {
                                model.offline ? Image(systemName: "bolt.horizontal.icloud.fill") : Image(systemName: "bolt.horizontal.icloud")
                            }
                        }
                    }
                }
                .navigationTitle(title)
                .onAppear {
                    updateColumns(isCompact: horizontalSizeClass == .compact)
                    model.loadInitialMangas(context: modelContext)
                }
                .onChange(of: geometry.size) {
                    updateColumns(isCompact: horizontalSizeClass == .compact)
                }
                .refreshable {
                    model.reloadMangas()
                }
                .sheet(isPresented: $showOfflineModeModal) {
                    NavigationStack {
                        OfflineInfoView()
                            .environment(model)
                    }
                }
            }
        }
    }
    
    private func getCurrentMangas() -> [Manga] {
        model.offline ? model.filteredMangas.map { $0.manga } : model.collectionType == .collection ? model.ownMangas.map { $0.manga } : model.mangaList
    }
    
    private func updateColumns(isCompact: Bool) {
        columns = Array(repeating: .init(.flexible()), count: isCompact ? 3 : 5)
    }
}

#Preview {
    NavigationStack {
        MangasCollectonView(title: "My Collection")
            .environment(CollectionModel(collectionType: .best))
    }
}
