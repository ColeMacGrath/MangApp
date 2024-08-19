//
//  OwnManga.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-18.
//

import Foundation
import SwiftData

@Model
class OwnManga: Codable, Hashable, Identifiable {
    @Attribute(.unique)
    var id: String
    var volumesOwned: [Int]
    var completeCollection: Bool
    var readingVolume: Int?
    var manga: Manga
    
    init(id: String, volumesOwned: [Int], completeCollection: Bool, readingVolume: Int?, manga: Manga) {
        self.id = id
        self.volumesOwned = volumesOwned
        self.completeCollection = completeCollection
        self.readingVolume = readingVolume
        self.manga = manga
    }

    enum CodingKeys: String, CodingKey {
        case id
        case volumesOwned
        case completeCollection
        case readingVolume
        case manga
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.volumesOwned = try container.decode([Int].self, forKey: .volumesOwned)
        self.completeCollection = try container.decode(Bool.self, forKey: .completeCollection)
        self.readingVolume = try container.decodeIfPresent(Int.self, forKey: .readingVolume)
        self.manga = try container.decode(Manga.self, forKey: .manga)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(volumesOwned, forKey: .volumesOwned)
        try container.encode(completeCollection, forKey: .completeCollection)
        try container.encode(readingVolume, forKey: .readingVolume)
        try container.encode(manga, forKey: .manga)
    }

    static func == (lhs: OwnManga, rhs: OwnManga) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
