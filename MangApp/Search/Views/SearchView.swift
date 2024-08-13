//
//  SearchView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var selectedDemographics: Set<Demographic> = []
    @State private var selectedGenres: Set<Genre> = []
    @State private var selectedThemes: Set<Theme> = []
    private let mangas = [].getMangaArray()
    private let demographics = [].getDemographicsArray()
    private let genres = [].getGenresArray()
    private let themes = [].getThemesArray()
    private var filteredMangas: [Manga] {
        mangas.filter { manga in
            let matchesSearchText = searchText.isEmpty ||
            manga.title.localizedCaseInsensitiveContains(searchText) ||
            manga.authors.contains(where: { $0.firstName.localizedCaseInsensitiveContains(searchText) || $0.lastName.localizedCaseInsensitiveContains(searchText) })
            
            let mangaGenreNames = Set(manga.genres.map { $0.genre })
            let selectedGenreNames = Set(selectedGenres.map { $0.genre })
            
            let mangaDemographicNames = Set(manga.demographics.map { $0.demographic })
            let selectedDemographicNames = Set(selectedDemographics.map { $0.demographic })
            
            let mangaThemes = manga.themes ?? []
            let mangaThemesNames = Set(mangaThemes.map { $0.theme })
            let selectedThemesNames = Set(selectedThemes.map { $0.theme })
            
            return matchesSearchText && selectedGenreNames.isSubset(of: mangaGenreNames) && selectedDemographicNames.isSubset(of: mangaDemographicNames) && selectedThemesNames.isSubset(of: mangaThemesNames)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(text: $searchText)
                TemporalCollectionView(mangas: filteredMangas, title: "Search")
            }
            .navigationTitle("Search Mangas")
            .toolbar {
#if os(macOS)
                FilterMenu(genres: genres, selectedGenres: $selectedGenres, demographics: demographics, selectedDemographics: $selectedDemographics, themes: themes, selectedThemes: $selectedThemes)
#else
                ToolbarItem(placement: .navigationBarTrailing) {
                    FilterMenu(genres: genres, selectedGenres: $selectedGenres, demographics: demographics, selectedDemographics: $selectedDemographics, themes: themes, selectedThemes: $selectedThemes)
                }
#endif
            }
        }
    }
}

#Preview {
    NavigationStack {
        TemporalCollectionView(mangas: [].getMangaArray(), title: "Search")
    }
}

struct TemporalCollectionView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var columns: [GridItem] = []
    var mangas: [Manga]
    var title: String
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(mangas, id: \.self) { manga in
                        NavigationLink(destination: MangaDetailView(manga: manga)) {
                            MangaItemView(manga: manga)
                        }
                    }                }
                .padding(.horizontal)
            }
            .navigationTitle(title)
        }.onAppear {
            updateColumns(isCompact: horizontalSizeClass == .compact)
        }
    }
    
    private func updateColumns(isCompact: Bool) {
        columns = Array(repeating: .init(.flexible()), count: isCompact ? 3 : 5)
    }
}
