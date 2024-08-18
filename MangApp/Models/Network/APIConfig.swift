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
        case list
        case mangas
        case bestMangas
        case author = "mangaByAuthor"
        case authors
        case demographics
        case genres
        case themes
        case users
        case collection
        case manga
    }
    
    static var baseURL: URL? {
        return URL(string: baseURLString)
    }
}
