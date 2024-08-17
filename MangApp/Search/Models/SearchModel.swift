//
//  SearchModel.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-13.
//

import Foundation

@Observable
class SearchModel {
    private var currentPage: Int = 1
    private var totalItems: Int = 0
    private var isDataLoaded: Bool = false
    private var isBulkUpdating: Bool = false
    private var itemsPerPage = 20
    var isLoading: Bool = false
    var hasError: Bool = false
    var errorMessage: String = ""
    
    var searchText: String = ""
    var selectedSearchType: SearchType = .title
    var availableGenres: [Genre] = []
    var availableDemographics: [Demographic] = []
    var availableThemes: [Theme] = []
    var mangasResults: [Manga] = []
    
    var interactor: NetworkInteractor
    
    var hasMorePages: Bool {
        return mangasResults.count < totalItems
    }
    
    var filtersLoaded: Bool {
        return !availableGenres.isEmpty && !availableDemographics.isEmpty && !availableThemes.isEmpty
    }
    
    var selectedGenres: [Genre] = [] {
        didSet {
            if !isBulkUpdating {
                resetSearch(keepingValues: true)
            }
        }
    }
    
    var selectedDemographics: [Demographic] = [] {
        didSet {
            if !isBulkUpdating {
                resetSearch(keepingValues: true)
            }
        }
    }
    
    var selectedThemes: [Theme] = [] {
        didSet {
            if !isBulkUpdating {
                resetSearch(keepingValues: true)
            }
        }
    }
    
    init(interactor: NetworkInteractor = NetworkInteractor.shared) {
        self.interactor = interactor
    }
    
    private func loadMangas(page: Int, per: Int) {
        guard !isOnPreview else {
            mangasResults.setMangaArray()
            isDataLoaded = true
            return
        }
        guard !isLoading else { return }
        isLoading = true
        hasError = false
        
        Task {
            let requestBody = createRequestBody(page: page, per: per)
            guard var urlComponents = URLComponents(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com/search/manga") else { return }
            urlComponents.queryItems = [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per", value: "\(per)")
            ]
            guard let url = urlComponents.url else { return }
            
            guard let postRequest: URLRequest = .request(method: .POST, url: url, body: requestBody) else {
                hasError = true
                errorMessage = "Failed to create request."
                isLoading = false
                return
            }
            
            let response = await interactor.perform(request: postRequest, responseType: [Manga].self)
            guard let newMangas = response?.data else {
                hasError = true
                errorMessage = "Failed to load mangas. Please try again."
                isLoading = false
                return
            }
            currentPage = page
            mangasResults.append(contentsOf: newMangas)
            totalItems = response?.metadata?.total ?? .zero
            isLoading = false
            isDataLoaded = true
        }
    }
    
    private func createRequestBody(page: Int = 1, per: Int = 20) -> SearchRequestBody {
        var body = SearchRequestBody(
            searchContains: true
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
    
    func resetToInitialState() {
        isBulkUpdating = true
        selectedGenres.removeAll()
        selectedDemographics.removeAll()
        selectedThemes.removeAll()
        isBulkUpdating = false
        resetSearch(keepingValues: true)
    }
    
    func resetSearch(keepingValues: Bool = true, fromPicker: Bool = false) {
        guard !(fromPicker && searchText.isEmpty) else { return }
        
        if !keepingValues {
            searchText = ""
            selectedGenres.removeAll()
            selectedDemographics.removeAll()
            selectedThemes.removeAll()
            mangasResults.removeAll()
        }
        
        currentPage = 1
        totalItems = 0
        hasError = false
        errorMessage = ""
        loadInitialMangas()
    }
    
    func loadInitialMangas(per: Int = 20) {
        guard !isLoading else { return }
        mangasResults.removeAll()
        loadMangas(page: 1, per: per)
    }
    
    func loadMoreMangas(per: Int = 20) {
        guard !isLoading && hasMorePages else { return }
        loadMangas(page: currentPage + 1, per: per)
    }
    
    func fetchFilters() {
        guard !isOnPreview else {
            availableDemographics.setDemographicsArray()
            availableGenres.setGenresArray()
            availableThemes.setThemesArray()
            return
        }
        
        guard !isDataLoaded,
              let demographicsURL: URL = .demographics,
              let genresURL: URL = .genres,
              let themesURL: URL = .themes,
              let demographicsRequest: URLRequest = .request(method: .GET, url: demographicsURL),
              let genresRequest: URLRequest = .request(method: .GET, url: genresURL),
              let themesRequest: URLRequest = .request(method: .GET, url: themesURL) else { return }
        
        Task {
            async let demographicsPerform = await interactor.perform(request: demographicsRequest, responseType: [String].self)
            async let genresPerform = await interactor.perform(request: genresRequest, responseType: [String].self)
            async let themesPerform = await interactor.perform(request: themesRequest, responseType: [String].self)
            
            let (demographicsResponse, genresResponse, themesResponse) = await (demographicsPerform, genresPerform, themesPerform)
            
            guard let demographicsData = demographicsResponse?.data,
            let genresData = genresResponse?.data,
            let themesData = themesResponse?.data else { return }
            
            
            availableDemographics = demographicsData.map { Demographic(id: UUID().uuidString, demographic: $0) }
            availableGenres = genresData.map { Genre(id: UUID().uuidString, genre: $0) }
            availableThemes = themesData.map { Theme(id: UUID().uuidString, theme: $0) }
            
            if !availableDemographics.isEmpty || !availableGenres.isEmpty || !availableThemes.isEmpty {
                isDataLoaded = true
            }
        }
    }
}

