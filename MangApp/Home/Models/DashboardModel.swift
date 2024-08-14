//
//  DashboardModel.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-12.
//

import Foundation

@Observable
class DashboardModel {
    var mangaCollection: [Manga] = []
    var bestMangas: [Manga] = []
    var interactor: NetworkInteractor
    
    init(interactor: NetworkInteractor = NetworkInteractor.shared) {
        self.interactor = interactor
    }
    
    func loadCollection() {
        Task {
            async let collectionResponse = interactor.mangasArray(collectionType: .mangas)
            async let bestMangasResponse = interactor.mangasArray(collectionType: .best)
            let (collectionResult, bestMangasResult) = await (collectionResponse, bestMangasResponse)
            
            if collectionResult.status == .ok {
                mangaCollection = collectionResult.mangas ?? []
            }
            if bestMangasResult.status == .ok {
                bestMangas = bestMangasResult.mangas ?? []
            }
        }
    }
}
