//
//  User.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-18.
//

import Foundation

class User: Codable, Hashable, Identifiable {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
