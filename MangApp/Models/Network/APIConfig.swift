//
//  APIConfig.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import Foundation

struct APIConfig {
    static let baseURLString = "https://mymanga-acacademy-5607149ebe3d.herokuapp.com"
    enum APIEndpoints: String {
        case login = "users/login"
        case list = "list"
        case mangas = "mangas"
        case bestMangas = "bestMangas"
        case author = "mangaByAuthor"
        case authors = "authors"
    }
    
    static var baseURL: URL? {
        return URL(string: baseURLString)
    }
}
