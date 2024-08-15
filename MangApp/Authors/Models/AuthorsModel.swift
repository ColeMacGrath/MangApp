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
        guard !authorsLoaded else { return }
        Task {
            guard let url = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com/list/authors") else { return }
            let request = URLRequest(url: url)
            guard let response = await interactor.perform(request: request, responseType: [Author].self) else { return }
            authors = response.data
            authorsLoaded = true
        }
    }
}
