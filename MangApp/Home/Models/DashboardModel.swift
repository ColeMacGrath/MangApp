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
    
    func loadCollecion() {
        Task {
            let (collectionResponse, bestMangasResponse) = await (interactor.mangasArray(collectionType: .mangas), interactor.mangasArray(collectionType: .best))
            if collectionResponse.status == .ok {
                mangaCollection = collectionResponse.mangas ?? []
            }
            if bestMangasResponse.status == .ok {
                bestMangas = bestMangasResponse.mangas ?? []
            }
        }
    }
}
