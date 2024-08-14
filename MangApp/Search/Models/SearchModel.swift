//
//  SearchModel.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-13.
//

import Foundation

@Observable
class SearchModel {
    var searchText: String = ""
    var selectedSearchType: SearchType = .title
    var selectedGenres: [Genre] = []
    var selectedDemographics: [Demographic] = []
    var selectedThemes: [Theme] = []
    var availableGenres: [Genre] = []
    var availableDemographics: [Demographic] = []
    var availableThemes: [Theme] = []
    
    var mangasResults: [Manga] = []
    private var currentPage: Int = 1
    private var totalItems: Int = 0
    var isLoading: Bool = false
    var hasError: Bool = false
    var errorMessage: String = ""
    private var isDataLoaded: Bool = false
    var interactor: NetworkInteractor
    
    init(interactor: NetworkInteractor = NetworkInteractor.shared) {
        self.interactor = interactor
    }
    
    func resetSearch(keepingValues: Bool = false) {
        if !keepingValues {
            searchText = ""
            selectedGenres.removeAll()
            selectedDemographics.removeAll()
            selectedThemes.removeAll()
            mangasResults.removeAll()
        }
        currentPage = 1
        totalItems = 0
        isDataLoaded = false
        hasError = false
        errorMessage = ""
    }
    
    func loadInitialMangas(per: Int = 20) {
        guard !isDataLoaded else { return }
        currentPage = 1
        mangasResults.removeAll()
        loadMangas(page: currentPage, per: per)
        isDataLoaded = true
    }
    
    func loadMoreMangas(per: Int = 20) {
        guard !isLoading else { return }
        isLoading = true
        loadMangas(page: currentPage + 1, per: per)
    }
    
    func reloadMangas(per: Int = 20) {
        isDataLoaded = false
        loadInitialMangas(per: per)
    }
    
    private func loadMangas(page: Int, per: Int) {
        isLoading = true
        hasError = false
        Task {
            let requestBody = createRequestBody(page: page, per: per)
            guard let url = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com/search/manga") else { return }
            guard let postRequest = URLRequest.post(url: url, body: requestBody) else {
                self.hasError = true
                self.errorMessage = "Failed to create request."
                self.isLoading = false
                return
            }
            
            let response = await interactor.perform(request: postRequest, responseType: [Manga].self)
            guard let newMangas = response?.data else {
                self.hasError = true
                self.errorMessage = "Failed to load mangas. Please try again."
                self.isLoading = false
                return
            }
            self.currentPage = page
            self.mangasResults.append(contentsOf: newMangas)
            self.totalItems = response?.metadata?.total ?? 0
            self.isLoading = false
        }
    }
    
    private func createRequestBody(page: Int = 1, per: Int = 20) -> SearchRequestBody {
        var body = SearchRequestBody(
            searchContains: true,
            page: page,
            per: per
        )
        
        if !searchText.isEmpty {
            switch selectedSearchType {
            case .title:
                body.searchTitle = searchText
            case .author:
                body.searchAuthorFirstName = searchText
                body.searchAuthorLastName = searchText
            }
        }
        
        if !selectedGenres.isEmpty {
            body.searchGenres = selectedGenres.map { $0.genre }
        }
        
        if !selectedDemographics.isEmpty {
            body.searchDemographics = selectedDemographics.map { $0.demographic }
        }
        
        if !selectedThemes.isEmpty {
            body.searchThemes = selectedThemes.map { $0.theme }
        }
        
        return body
    }
    func fetchFilters() {
        guard let demographicsURL = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com/list/demographics"),
              let genersURL = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com/list/genres"),
              let themesURL = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com/list/themes") else { return }
        let demographicsRequest = URLRequest.get(url: demographicsURL)
        let genresRequest = URLRequest.get(url: genersURL)
        let themesRequest = URLRequest.get(url: themesURL)
        
        Task {
            async let demographicsPerform = await interactor.perform(request: demographicsRequest, responseType: [String].self)
            async let genresPerform = await interactor.perform(request: genresRequest, responseType: [String].self)
            async let themesPerform = await interactor.perform(request: themesRequest, responseType: [String].self)
            let (demographicsResponse, genresResponse, themesResponse) = await (demographicsPerform, genresPerform, themesPerform)
            
            self.availableDemographics = demographicsResponse?.data.map { Demographic(id: UUID().uuidString, demographic: $0) } ?? []
            self.availableGenres = genresResponse?.data.map { Genre(id: UUID().uuidString, genre: $0) } ?? []
            self.availableThemes = themesResponse?.data.map { Theme(id: UUID().uuidString, theme: $0) } ?? []
        }
    }
    
    var hasMorePages: Bool {
        return mangasResults.count < totalItems
    }
    
    var filtersLoaded: Bool {
        return !availableGenres.isEmpty && !availableDemographics.isEmpty && !availableThemes.isEmpty
    }
}

enum SearchType: String, CaseIterable, Identifiable {
    case title
    case author
    
    var id: String { rawValue }
}

struct SearchRequestBody: Codable {
    var searchTitle: String?
    var searchAuthorFirstName: String?
    var searchAuthorLastName: String?
    var searchGenres: [String]?
    var searchDemographics: [String]?
    var searchThemes: [String]?
    var searchContains: Bool
    var page: Int
    var per: Int
}
