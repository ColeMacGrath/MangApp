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
    var isLoading: Bool = false
    var showErrorView: Bool = false
    var isDataLoaded = false
    
    init(interactor: NetworkInteractor = NetworkInteractor.shared) {
        self.interactor = interactor
    }
    
    func fetchAuthors() {
        guard !isOnPreview else {
            authors.setAuthorsArray()
            return
        }
        
        guard !isDataLoaded else { return }
        guard let url = URL.authors else { return }
        let request = URLRequest(url: url)
        Task {
            isLoading = true
            showErrorView = false
            guard let response = await interactor.perform(request: request, responseType: [Author].self)?.data else {
                isLoading = false
                showErrorView = true
                return
            }
            authors = response
            isDataLoaded = true
            isLoading = false
        }
    }
}
