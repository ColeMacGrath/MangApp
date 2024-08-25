//
//  SearchView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(SearchModel.self) private var model
    @State private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        @Bindable var model = model
        GeometryReader { geometry in
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        SearchBar(text: $model.searchText) {
                            model.resetSearch()
                        }
                        .padding(.horizontal)
                        
                        SearchPicker(selectionType: $model.selectedSearchType)
                            .padding(.horizontal)
                            .onChange(of: model.selectedSearchType) {
                                model.resetSearch(fromPicker: true)
                            }
                        
                        if !model.mangasResults.isEmpty {
                            if !model.searchText.isEmpty  {
                                SubtitleSerachView(selectionType: $model.selectedSearchType)
                            }
                            LazyVGrid(columns: columns) {
                                ForEach(model.mangasResults) { manga in
                                    NavigationLink(destination: MangaDetailView(manga: manga)) {
                                        MangaItemView(manga: manga)
                                            .onAppear {
                                                if manga == model.mangasResults.last {
                                                    model.loadMoreMangas()
                                                }
                                            }
                                    }
                                }
                            }.padding(.horizontal)
                        }
                    }
                    .navigationTitle("Search Mangas")
                    .toolbar {
#if os(macOS)
                        if model.filtersLoaded {
                            FilterMenu(genres: model.availableGenres, selectedGenres: $model.selectedGenres, demographics: model.availableDemographics, selectedDemographics: $model.selectedDemographics, themes: model.availableThemes, selectedThemes: $model.selectedThemes, resetAction: {
                                model.resetToInitialState()
                            })
                        }
#else
                        ToolbarItem(placement: .topBarTrailing) {
                            if model.filtersLoaded {
                                FilterMenu(genres: model.availableGenres, selectedGenres: $model.selectedGenres, demographics: model.availableDemographics, selectedDemographics: $model.selectedDemographics, themes: model.availableThemes, selectedThemes: $model.selectedThemes, resetAction: {
                                    model.resetToInitialState()
                                })
                            }
                        }
#endif
                    }
                    .onAppear {
                        model.fetchFilters()
                        //updateColumns(isCompact: horizontalSizeClass == .compact)
                    }
                    .onChange(of: geometry.size) {
                        updateColumns(isCompact: horizontalSizeClass == .compact)
                    }
                    .refreshable {
                        model.resetToInitialState()
                    }
                }.overlay {
                    if model.isLoading,
                       model.mangasResults.isEmpty {
                        ProgressView("Loading...")
                    } else if model.hasError {
                        ErrorView(button: ColoredRoundedButton(title: "Retry", action: {
                            model.loadMoreMangas()
                        })).padding()
                    }
                }
            }
        }
    }
    
    private func updateColumns(isCompact: Bool) {
        columns = Array(repeating: .init(.flexible()), count: isCompact ? 3 : 5)
    }
}

#Preview {
    SearchView()
        .environment(SearchModel())
}
