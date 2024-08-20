//
//  OwnMangaModel.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-17.
//

import Foundation
import SwiftData

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
    
    private func setLoadedItems(manga: Manga, ownManga: OwnManga) {
        self.ownManga = ownManga
        self.manga = manga
        selectedVolumes = ownManga.volumesOwned
        selectedReadingVolume = ownManga.readingVolume
        isLoaded = true
    }
    
    private func loadOwnLocal(manga: Manga, context: ModelContext) -> OwnManga? {
        let fetchDescriptor = FetchDescriptor<OwnManga>(
            predicate: #Predicate { $0.manga.id == manga.id }
        )
        do {
            let ownManga = try context.fetch(fetchDescriptor).first
            return ownManga
        } catch {
            print("Failed to fetch or delete OwnManga instances: \(error)")
            return nil
        }
    }
    
    private func setSelectedValues(newOwnManga: OwnManga) {
        self.ownManga = newOwnManga
        selectedReadingVolume = ownManga?.readingVolume
        selectedVolumes = ownManga?.volumesOwned
    }
    
    func loadOwn(manga: Manga, offline: Bool = false, context: ModelContext? = nil) {
        guard !offline else {
            guard let context,
            let ownManga = loadOwnLocal(manga: manga, context: context)
            else { return }
            setLoadedItems(manga: manga, ownManga: ownManga)
            return
        }
        
        guard let url: URL = .ownManga?.appending(path: String(manga.id)),
              let request: URLRequest = .request(method: .GET, url: url, authenticated: true) else { return }
        isLoaded = false
        selectedVolumes = []
        selectedReadingVolume = nil
        
        Task {
            guard let response = await interactor.perform(request: request, responseType: OwnManga.self)?.data else {
                self.manga = manga
                ownManga = nil
                isLoaded = true
                return
            }
            setLoadedItems(manga: manga, ownManga: response)
        }
    }
    
    @MainActor
    private func saveLocal(newOwnManga: OwnManga? = nil, manga: Manga, context: ModelContext) {
        let completeCollection = selectedVolumes?.count ?? 0 >= manga.volumes ?? 0
        let newOwnManga = newOwnManga ?? OwnManga(id: UUID().uuidString, volumesOwned: selectedVolumes ?? [], completeCollection: completeCollection, readingVolume: selectedReadingVolume, manga: manga)
        
        if let localOwnManga = loadOwnLocal(manga: manga, context: context) {
            localOwnManga.volumesOwned = selectedVolumes ?? []
            localOwnManga.completeCollection = completeCollection
            localOwnManga.readingVolume = selectedReadingVolume
        } else {
            context.insert(newOwnManga)
        }
        setSelectedValues(newOwnManga: newOwnManga)
    }
    
    @MainActor
    func delete(manga: Manga, context: ModelContext) async -> Bool {
        guard await deleteRemote(manga: manga) else { return false }
        deleteLocal(manga: manga, context: context)
        return true
    }
    
    private func deleteRemote(manga: Manga) async -> Bool {
        guard let url: URL = .ownManga?.appending(path: String(manga.id))   ,
              let request: URLRequest = .request(method: .DELETE, url: url, authenticated: true) else { return false }
        guard await interactor.perform(request: request, responseType: EditMangaRequestBody.self)?.status == .ok else { return false }
        reset()
        return true
    }
    
    @MainActor
    private func deleteLocal(manga: Manga, context: ModelContext) {
        let fetchDescriptor = FetchDescriptor<OwnManga>(
            predicate: #Predicate { $0.manga.id == manga.id }
        )
        do {
            let ownMangasToDelete = try context.fetch(fetchDescriptor)
            ownMangasToDelete.forEach({ print($0.manga.title); context.delete($0) })
        } catch {
            print("Failed to fetch or delete OwnManga instances: \(error)")
        }
    }
    
    private func reset() {
        self.selectedVolumes = nil
        self.selectedReadingVolume = nil
        self.ownManga = nil
    }
    
    private func createRequestBody(manga: Manga) -> EditMangaRequestBody? {
        let completeCollection = selectedVolumes?.count ?? 0 >= manga.volumes ?? 0
        return EditMangaRequestBody(manga: manga.id, completeCollection: completeCollection, volumesOwned: selectedVolumes ?? [], readingVolume: selectedReadingVolume)
    }
    
    @MainActor
    func save(manga: Manga, context: ModelContext, offline: Bool = false) async -> Bool {
        guard !offline else {
            saveLocal(manga: manga, context: context)
            return true
        }
        
        guard let url: URL = .ownManga,
              let body = createRequestBody(manga: manga),
              let request: URLRequest = .request(method: .POST, url: url, body: body, authenticated: true) else { return false }
        guard await interactor.perform(request: request, responseType: EditMangaRequestBody.self)?.status == .created else { return false }
        let completeCollection = selectedVolumes?.count ?? 0 >= manga.volumes ?? 0
        
        let newOwnManga = OwnManga(id: UUID().uuidString, volumesOwned: selectedVolumes ?? [], completeCollection: completeCollection, readingVolume: selectedReadingVolume, manga: manga)
        saveLocal(newOwnManga: ownManga, manga: manga, context: context)
        setSelectedValues(newOwnManga: newOwnManga)
        
        return true
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
