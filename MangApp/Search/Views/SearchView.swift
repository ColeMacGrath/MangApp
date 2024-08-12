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
                MangasCollectonView(mangas: filteredMangas, title: "Search")
            }
            .navigationTitle("Search Mangas")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    FilterMenu(genres: genres, selectedGenres: $selectedGenres, demographics: demographics, selectedDemographics: $selectedDemographics, themes: themes, selectedThemes: $selectedThemes)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
}
