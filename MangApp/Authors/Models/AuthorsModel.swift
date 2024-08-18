//
//  AuthorsModel.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-14.
//

import Foundation

@Observable
class AuthorsModel {
    private var authorsLoaded = false
    var interactor: NetworkInteractor
    var authors: [Author] = []
    
    init(interactor: NetworkInteractor = NetworkInteractor.shared) {
        self.interactor = interactor
    }
    
    func fetchAuthors() {
        guard !isOnPreview else {
            authors.setAuthorsArray()
            return
        }
        
        guard let url = URL.authors else { return }
        let request = URLRequest(url: url)
        Task {
            guard let response = await interactor.perform(request: request, responseType: [Author].self)?.data else { return }
            authors = response
        }
    }
}
