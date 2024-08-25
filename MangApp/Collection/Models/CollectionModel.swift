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
    private var isDataLoaded: Bool = false
    private var queryPaths: [String]?
    var isLoading: Bool = false
    var offline = false
    var collectionType: CollectionViewType
    var mangaList: [Manga] = []
    var ownMangas: [OwnManga] = []
    var interactor: NetworkInteractor
    
    init(interactor: NetworkInteractor = NetworkInteractor.shared, collectionType: CollectionViewType = .best, queryPaths: [String]? = nil) {
        self.interactor = interactor
        self.collectionType = collectionType
        self.queryPaths = queryPaths
    }
    
    func loadInitialMangas(per: Int = 20, context: ModelContext? = nil) {
        guard !isDataLoaded else { return }
        guard !offline else {
            guard let context else { return }
            loadLocalCollection(context: context)
            return
        }
        
        currentPage = 1
        mangaList.removeAll()
        loadMangas(page: currentPage, per: per)
        isDataLoaded = true
    }
    
    private func loadLocalCollection(context: ModelContext) {
        self.ownMangas.removeAll()
        let fetchDescriptor = FetchDescriptor<OwnManga>()
        do {
            ownMangas = try context.fetch(fetchDescriptor)
            isDataLoaded = true
        } catch {
            isDataLoaded = true
        }
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
        isLoading = true
        Task {
            guard let url: URL = .mangas(page: collection ? nil : page, per: collection ? nil : per, collectionType: collectionType, queryPaths: queryPaths),
                  let request: URLRequest = .request(method: .GET, url: url, authenticated: collectionType == .collection) else {
                isLoading = false
                return
            }
            
            if collectionType == .collection,
               let response = await interactor.perform(request: request, responseType: [OwnManga].self) {
                self.totalItems = response.metadata?.total ?? 0
                ownMangas = response.data ?? []
            } else if  let response = await interactor.perform(request: request, responseType: [Manga].self) {
                self.totalItems = response.metadata?.total ?? 0
                mangaList.append(contentsOf: response.data ?? [])
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
