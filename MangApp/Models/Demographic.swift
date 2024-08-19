//
//  Demographic.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-18.
//

import Foundation
import SwiftData

@Model
final class Demographic: Codable, Hashable, Identifiable {
    @Attribute(.unique)
    var id: String
    var demographic: String
    
    init(id: String, demographic: String) {
        self.id = id
        self.demographic = demographic
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case demographic
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.demographic = try container.decode(String.self, forKey: .demographic)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(demographic, forKey: .demographic)
    }
    
    static func == (lhs: Demographic, rhs: Demographic) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

