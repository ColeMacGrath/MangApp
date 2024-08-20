//
//  Theme.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-18.
//

import Foundation
import SwiftData

@Model
final class Theme: Codable, Hashable, Identifiable {
    var id: String
    var theme: String
    init(id: String, theme: String) {
        self.id = id
        self.theme = theme
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case theme
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.theme = try container.decode(String.self, forKey: .theme)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(theme, forKey: .theme)
    }
    
    static func == (lhs: Theme, rhs: Theme) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
