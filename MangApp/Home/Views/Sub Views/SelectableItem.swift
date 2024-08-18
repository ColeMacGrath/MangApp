//
//  SelectableItems.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import Foundation
import SwiftUI

enum SelectableItem: CaseIterable, Identifiable {
    case home
    case collection
    case best
    case authors
    case search
    
    var label: Label<Text, Image> {
        switch self {
        case .home: Label("Home", systemImage: "house")
        case .collection: Label("Collection", systemImage: "books.vertical")
        case .best: Label("Best", systemImage: "star")
        case .authors: Label("Authors", systemImage: "highlighter")
        case .search: Label("Search", systemImage: "magnifyingglass")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .home:
            DashboardView()
        case .collection:
            MangasCollectonView(title: "My Collection")
                .environment(CollectionModel(collectionType: .collection))
        case .best:
            MangasCollectonView(title: "The Best")
                .environment(CollectionModel(collectionType: .best))
        case .authors:
            AuthorsView()
        case .search:
            SearchView()
            
        }
    }
    
    var id: SelectableItem { self }
}
