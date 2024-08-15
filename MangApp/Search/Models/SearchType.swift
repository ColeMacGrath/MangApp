//
//  SearchType.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-14.
//

import Foundation

enum SearchType: String, CaseIterable, Identifiable {
    case title
    case author
    
    var id: String { rawValue }
}
