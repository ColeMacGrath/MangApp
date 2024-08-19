//
//  MangaList.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-18.
//

import Foundation

struct MangaList: Decodable {
    let mangas: [Manga]
    
    private enum RootKeys: String, CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        self.mangas = try container.decode([Manga].self, forKey: .items)
    }
}
