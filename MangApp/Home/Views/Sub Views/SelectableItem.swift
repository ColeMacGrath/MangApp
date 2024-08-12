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
    case search

    var label: Label<Text, Image> {
        switch self {
        case .home: Label("Home", systemImage: "house")
        case .collection: Label("Collection", systemImage: "books.vertical")
        case .best: Label("Best", systemImage: "star")
        case .search: Label("Search", systemImage: "magnifyingglass")
        }
    }

    @ViewBuilder
    var destination: some View {
        switch self {
        case .home:
            DashboardView()
        case .collection:
            MangasCollectonView(mangas: [].getMangaArray(), title: "My Collection")
        case .search:
            SearchView()
        case .best:
            MangasCollectonView(mangas: [].getMangaArray(), title: "The Best")
        }
    }

    var id: SelectableItem { self }
}
