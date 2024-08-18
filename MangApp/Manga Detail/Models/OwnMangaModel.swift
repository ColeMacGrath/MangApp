//
//  OwnMangaModel.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-17.
//

import Foundation

@Observable
class OwnMangaModel {
    private var interactor: NetworkInteractor
    var selectedVolumes: [Int]?
    var selectedReadingVolume: Int?
    var ownManga: OwnManga?
    var manga: Manga?
    var isLoaded = false
    
    
    init(manga: Manga? = nil, interactor: NetworkInteractor = NetworkInteractor.shared, ownManga: OwnManga? = nil) {
        self.interactor = interactor
    }
    
    func loadOwn(manga: Manga) {
        guard let url: URL = .ownManga?.appending(path: String(manga.id)),
              let request: URLRequest = .request(method: .GET, url: url, authenticated: true) else { return }
        isLoaded = false
        selectedVolumes = []
        
        
        Task {
            guard let response = await interactor.perform(request: request, responseType: OwnManga.self)?.data else {
                self.manga = manga
                ownManga = nil
                isLoaded = true
                return
            }
            
            ownManga = response
            self.manga = manga
            selectedVolumes = ownManga?.volumesOwned
            selectedReadingVolume = ownManga?.readingVolume
            
            isLoaded = true
        }
    }
    
    func save(manga: Manga) -> Bool {
        guard let url: URL = .ownManga,
              let body = createRequestBody(manga: manga),
              let request: URLRequest = .request(method: .POST, url: url, body: body, authenticated: true) else { return false }
        
        Task {
            guard await interactor.perform(request: request, responseType: EditMangaRequestBody.self)?.status == .created else { return false }
            let completeCollection = selectedVolumes?.count ?? 0 >= manga.volumes ?? 0
            ownManga = OwnManga(id: UUID().uuidString, volumesOwned: selectedVolumes ?? [], completeCollection: completeCollection, readingVolume: selectedReadingVolume, manga: manga)
            return true
        }
        return true
    }
    
    private func createRequestBody(manga: Manga) -> EditMangaRequestBody? {
        let completeCollection = selectedVolumes?.count ?? 0 >= manga.volumes ?? 0
        return EditMangaRequestBody(manga: manga.id, completeCollection: completeCollection, volumesOwned: selectedVolumes ?? [], readingVolume: selectedReadingVolume)
    }
    
    func append(volume: Int) {
        if var selectedVolumes = self.selectedVolumes {
            if selectedVolumes.contains(volume) {
                if let _ = self.selectedReadingVolume {
                    self.selectedReadingVolume = nil
                }
                selectedVolumes.removeAll(where: { $0 == volume })
            } else {
                selectedVolumes.append(volume)
            }
            self.selectedVolumes = selectedVolumes
        }
    }
    
    func append(readingVolume: Int) {
        if let selectedReadingVolume = self.selectedReadingVolume,
           selectedReadingVolume == readingVolume {
            self.selectedReadingVolume = nil
        } else {
            if let selectedVolumes = self.selectedVolumes {
                if !selectedVolumes.contains(readingVolume) {
                    append(volume: readingVolume)
                }
                self.selectedReadingVolume = readingVolume
            }
        }
    }
    
}
