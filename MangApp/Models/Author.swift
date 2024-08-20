//
//  Author.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-18.
//

import Foundation
import SwiftData

@Model
final class Author: Codable, Hashable, Identifiable {
    var id: String
    var lastName: String
    var firstName: String
    var role: String
    
    init(id: String, lastName: String, firstName: String, role: String) {
        self.id = id
        self.lastName = lastName
        self.firstName = firstName
        self.role = role
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case lastName
        case firstName
        case role
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.role = try container.decode(String.self, forKey: .role)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(role, forKey: .role)
    }
    
    static func == (lhs: Author, rhs: Author) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var initials: String {
        let firstInitial = firstName.first?.uppercased() ?? ""
        let lastInitial = lastName.first?.uppercased() ?? ""
        return firstInitial + lastInitial
    }
}
