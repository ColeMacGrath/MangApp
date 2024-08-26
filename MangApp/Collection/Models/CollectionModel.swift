//
//  CollectionModel.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-12.
//

import Foundation
import SwiftData

@Observable
class CollectionModel {
    private var currentPage: Int = 1
    private var totalItems: Int = 0
    private var queryPaths: [String]?
    private var modelContext: ModelContext?
    var showErrorView: Bool = false
    var isLoading: Bool = false
    var offline = false
    var collectionType: CollectionViewType
    var mangaList: [Manga] = []
    var ownMangas: [OwnManga] = []
    var filteredMangas: [OwnManga] = []
    var interactor: NetworkInteractor
    var isDataLoaded: Bool = false
    var availableGenres: [Genre] = []
    var availableDemographics: [Demographic] = []
    var availableThemes: [Theme] = []
    var selectedSearchType: SearchType = .title
    var searchText = String() {
        didSet {
            filterMangas()
        }
    }
    var selectedGenres: [Genre] = [] {
        didSet {
            filterMangas()
        }
    }
    var selectedDemographics: [Demographic] = [] {
        didSet {
            filterMangas()
        }
    }
    var selectedThemes: [Theme] = [] {
        didSet {
            filterMangas()
        }
    }
    
    init(interactor: NetworkInteractor = NetworkInteractor.shared, collectionType: CollectionViewType = .best, queryPaths: [String]? = nil) {
        self.interactor = interactor
        self.collectionType = collectionType
        self.queryPaths = queryPaths
    }
    
    func filterMangas() {
        if selectedGenres.isEmpty,
           selectedThemes.isEmpty,
           selectedDemographics.isEmpty,
           searchText.isEmpty {
            isDataLoaded = false
            loadInitialMangas()
            return
        }
        
        filteredMangas = ownMangas.filter { ownManga in
            let manga = ownManga.manga
            let hasMatchingGenres = manga.genres.contains(where: selectedGenres.contains)
            let hasMatchingDemographics = manga.demographics.contains(where: selectedDemographics.contains)
            let hasMatchingThemes = manga.themes?.contains(where: selectedThemes.contains) ?? false
            let matchesCriteria = selectedGenres.isEmpty && selectedDemographics.isEmpty && selectedThemes.isEmpty ? true : hasMatchingGenres || hasMatchingDemographics || hasMatchingThemes
            
            if !searchText.isEmpty {
                switch selectedSearchType {
                case .title:
                    return matchesCriteria && manga.title.localizedCaseInsensitiveContains(searchText)
                case .author:
                    return matchesCriteria && manga.authors.contains { author in
                        author.firstName.localizedCaseInsensitiveContains(searchText) ||
                        author.lastName.localizedCaseInsensitiveContains(searchText)
                    }
                }
            } else {
                return matchesCriteria
            }
        }
    }
    
    func resetToInitialState(context: ModelContext) {
        selectedGenres.removeAll()
        selectedDemographics.removeAll()
        selectedThemes.removeAll()
        searchText.removeAll()
        isDataLoaded = false
        loadInitialMangas(context: context)
    }
    
    func loadOfflineManas() {
        offline = false
        isDataLoaded = false
        loadInitialMangas()
    }
    
    func loadInitialMangas(per: Int = 20, context: ModelContext? = nil) {
        if let context {
            self.modelContext = context
        }
        guard !isDataLoaded else { return }
        guard !offline else {
            loadLocalCollection(context: context ?? self.modelContext)
            return
        }
        
        currentPage = 1
        mangaList.removeAll()
        loadMangas(page: currentPage, per: per)
        isDataLoaded = true
    }
    
    private func loadLocalCollection(context: ModelContext?) {
        guard let context else { return }
        ownMangas.removeAll()
        let fetchDescriptor = FetchDescriptor<OwnManga>()
        do {
            ownMangas = try context.fetch(fetchDescriptor)
            filteredMangas = ownMangas
            print("HERE ***", filteredMangas.count)
            setLocalFilters(ownMangas: ownMangas)
            isDataLoaded = true
        } catch {
            isDataLoaded = true
        }
    }
    
    private func setLocalFilters(ownMangas: [OwnManga]) {
        availableGenres = Array(Set(ownMangas.flatMap { $0.manga.genres }))
        availableThemes = Array(Set(ownMangas.flatMap { $0.manga.themes ?? [] }))
        availableDemographics = Array(Set(ownMangas.flatMap { $0.manga.demographics }))
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
        guard !isOnPreview else {
            self.mangaList.setMangaArray()
            return
        }
        let collection = collectionType == .collection
        showErrorView = false
        isLoading = true
        Task {
            guard let url: URL = .mangas(page: collection ? nil : page, per: collection ? nil : per, collectionType: collectionType, queryPaths: queryPaths),
                  let request: URLRequest = .request(method: .GET, url: url, authenticated: collectionType == .collection) else {
                isLoading = false
                showErrorView = true
                return
            }
            
            if collectionType == .collection,
               let response = await interactor.perform(request: request, responseType: [OwnManga].self) {
                self.totalItems = response.metadata?.total ?? 0
                ownMangas = response.data ?? []
            } else if  let response = await interactor.perform(request: request, responseType: [Manga].self) {
                self.totalItems = response.metadata?.total ?? 0
                mangaList.append(contentsOf: response.data ?? [])
            } else {
                showErrorView = true
            }
            
            self.currentPage = page
            isLoading = false
        }
    }
    
    func remove(manga: Manga) {
        ownMangas.removeAll(where: { $0.manga == manga })
    }
    
    var hasMorePages: Bool {
        return mangaList.count < totalItems
    }
}
