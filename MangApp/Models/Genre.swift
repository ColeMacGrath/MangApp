//
//  Genre.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-18.
//

import Foundation
import SwiftData

@Model
final class Genre: Codable, Hashable, Identifiable {
    var id: String
    var genre: String
    
    init(id: String, genre: String) {
        self.id = id
        self.genre = genre
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case genre
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.genre = try container.decode(String.self, forKey: .genre)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(genre, forKey: .genre)
    }
    
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
