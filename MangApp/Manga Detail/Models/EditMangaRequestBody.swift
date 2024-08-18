//
//  EditMangaRequestBody.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-18.
//

import Foundation

struct EditMangaRequestBody: Codable {
    var manga: Int
    var completeCollection: Bool
    var volumesOwned: [Int] = []
    var readingVolume: Int?
}
