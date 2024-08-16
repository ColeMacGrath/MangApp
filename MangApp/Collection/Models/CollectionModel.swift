//
//  CollectionModel.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-12.
//

import Foundation

@Observable
class CollectionModel {
    var mangaList: [Manga] = []
    private var currentPage: Int = 1
    private var totalItems: Int = 0
    private var isLoading: Bool = false
    private var isDataLoaded: Bool = false
    private var collectionType: CollectionViewType
    private var queryPaths: [String]?
    var interactor: NetworkInteractor

    init(interactor: NetworkInteractor = NetworkInteractor.shared, collectionType: CollectionViewType = .best, queryPaths: [String]? = nil) {
        self.interactor = interactor
        self.collectionType = collectionType
        self.queryPaths = queryPaths
    }
    
    func loadInitialMangas(per: Int = 20) {
        guard !isDataLoaded else { return }
        currentPage = 1
        mangaList.removeAll()
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
        Task {
            guard let url = URL.mangas(page: page, per: per, collectionType: collectionType, queryPaths: queryPaths) else { return }
            let response = await interactor.perform(request: .get(url: url), responseType: [Manga].self)
            guard let newMangas = response?.data else {
                isLoading = false
                return
            }
            self.currentPage = page
            self.mangaList.append(contentsOf: newMangas)
            self.totalItems = response?.metadata?.total ?? 0
            isLoading = false
        }
    }

    var hasMorePages: Bool {
        return mangaList.count < totalItems
    }
}
