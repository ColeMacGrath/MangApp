//
//  HomeView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

struct SelectableItemsView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSize
    @State private var screen: SelectableItem? = .home
    
    var body: some View {
        if horizontalSize == .compact {
            TabView {
                ForEach(SelectableItem.allCases) { screen in
                    NavigationStack {
                        screen.destination
                    }
                    .tabItem { screen.label }
                }
            }
        } else {
            NavigationSplitView {
                List(SelectableItem.allCases, selection: $screen) { screen in
                    NavigationLink(value: screen) {
                        screen.label
                    }
                }
#if os(iOS)
                .listStyle(.sidebar)
#endif
                .navigationTitle("MangApp")
            } detail: {
                if let screen {
                    screen.destination
                } else {
                    ContentUnavailableView("In progress", systemImage: "book", description: Text("View still in progress"))
                }
            }
        }
    }
}

#Preview {
    SelectableItemsView()
}
