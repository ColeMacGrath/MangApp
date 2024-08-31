//
//  DashboardModel.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-12.
//

import Foundation

@Observable
class DashboardModel {
    var mangaCollection: [OwnManga] = []
    var bestMangas: [Manga] = []
    var interactor: NetworkInteractor
    private var isDataLoaded: Bool = false
    var showErrorView = false
    var isLoading = false
    
    init(interactor: NetworkInteractor = NetworkInteractor.shared) {
        self.interactor = interactor
    }
    
    func loadMangas() {
        guard !isOnPreview else {
            mangaCollection = []
            bestMangas.setMangaArray()
            return
        }
        isLoading = true
        Task {
            async let collectionResponse = await loadCollection()
            async let bestMangasResponse = await interactor.mangasArray(collectionType: .best)
            let (collectionResult, bestMangasResult) = await (collectionResponse, bestMangasResponse)
            
            guard collectionResult.status == .ok, bestMangasResult.status == .ok else {
                isDataLoaded = false
                showErrorView = true
                isLoading = false
                return
            }
            
            mangaCollection = collectionResult.mangas ?? []
            bestMangas = bestMangasResult.mangas ?? []
            isDataLoaded = true
            showErrorView = false
            isLoading = false
        }
    }
    
    private func loadCollection() async -> (status: URLRequestResult, mangas: [OwnManga]?)  {
        guard !isOnPreview else { return (.ok, []) }
        guard let url: URL = .mangas(collectionType: .collection),
              let request: URLRequest = .request(method: .GET, url: url, authenticated: true) else {
            return (status: URLRequestResult.appUnavailable, mangas: [])
        }
        
        let response = await interactor.perform(request: request, responseType: [OwnManga].self)
        return (response?.status ?? .ok, response?.data ?? [])
    }
    
    
}
