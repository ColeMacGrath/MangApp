//
//  SearchRequestBody.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-14.
//

import Foundation

struct SearchRequestBody: Codable {
    var searchTitle: String?
    var searchAuthorFirstName: String?
    var searchAuthorLastName: String?
    var searchGenres: [String]?
    var searchDemographics: [String]?
    var searchThemes: [String]?
    var searchContains: Bool
}
