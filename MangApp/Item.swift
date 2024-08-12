//
//  Item.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-05.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
