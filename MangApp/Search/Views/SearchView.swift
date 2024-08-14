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
    @State private var columns: [GridItem] = []
    
    var body: some View {
        @Bindable var model = model
        GeometryReader { geometry in
            NavigationStack {
                VStack(alignment: .leading) {
                    
                    SearchBar(text: $model.searchText) {
                        model.resetSearch()
                        model.loadInitialMangas()
                    }
                    .padding(.horizontal)
                    
                    Picker("Select Search Type", selection: $model.selectedSearchType) {
                        ForEach(SearchType.allCases) { searchType in
                            Text(searchType.rawValue).tag(searchType)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .onChange(of: model.selectedSearchType) {
                        model.resetSearch(keepingValues: true)
                        model.loadInitialMangas()
                    }
                    .onChange(of: model.selectedGenres) {
                        model.resetSearch(keepingValues: true)
                    }
                    
                    
                    
                    if model.isLoading {
                        ProgressView("Loading...")
                            .padding()
                    } else if model.hasError {
                        VStack {
                            Text(model.errorMessage)
                                .font(.callout)
                                .foregroundColor(.red)
                                .padding()
                            
                            Button("Retry") {
                                model.loadInitialMangas()
                            }
                            .padding()
                        }
                    } else if model.mangasResults.isEmpty {
                        Text("No results found.")
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        Text(model.selectedSearchType == .author ? "Results by Author" : "Results by Title")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .padding()
                        
                        ScrollView {
                            LazyVGrid(columns: columns) {
                                ForEach(model.mangasResults, id: \.self) { manga in
                                    NavigationLink(destination: MangaDetailView(manga: manga)) {
                                        MangaItemView(manga: manga)
                                    }
                                }
                                
                                if model.hasMorePages {
                                    ProgressView()
                                        .onAppear {
                                            model.loadMoreMangas()
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .navigationTitle("Search Mangas")
                .toolbar {
#if os(macOS)
                    if model.filtersLoaded {
                        FilterMenu(genres: model.availableGenres, selectedGenres: $model.selectedGenres, demographics: model.availableDemographics, selectedDemographics: $model.selectedDemographics, themes: model.availableThemes, selectedThemes: $model.selectedThemes)
                    }
#else
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if model.filtersLoaded {
                            FilterMenu(genres: model.availableGenres, selectedGenres: $model.selectedGenres, demographics: model.availableDemographics, selectedDemographics: $model.selectedDemographics, themes: model.availableThemes, selectedThemes: $model.selectedThemes)
                        }
                    }
#endif
                }
                .onAppear {
                    model.fetchFilters()
                    updateColumns(isCompact: horizontalSizeClass == .compact)
                }
                .onChange(of: geometry.size) {
                    updateColumns(isCompact: horizontalSizeClass == .compact)
                }
                .refreshable {
                    model.reloadMangas()
                }
            }
        }
    }
    
    private func updateColumns(isCompact: Bool) {
        columns = Array(repeating: .init(.flexible()), count: isCompact ? 3 : 5)
    }
}
