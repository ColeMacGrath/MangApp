//
//  Collection.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import SwiftUI

struct MangasCollectonView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(CollectionModel.self) private var model
    @State private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    var title: String
    
    var body: some View {
        @Bindable var model = model
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(model.collectionType == .collection ? model.ownMangas.map { $0.manga } : model.mangaList) { manga in
                        NavigationLink(destination: MangaDetailView(manga: manga)
                            .environment(self.model)) {
                                MangaItemView(manga: manga)
                                    .onAppear {
                                        if manga == model.mangaList.last {
                                            model.loadMoreMangas()
                                        }
                                    }
                            }
                    }
                }
            }
            .navigationTitle(title)
            .onAppear {
                updateColumns(isCompact: horizontalSizeClass == .compact)
                model.loadInitialMangas()
            }
            .onChange(of: geometry.size) {
                updateColumns(isCompact: horizontalSizeClass == .compact)
            }
            .refreshable {
                model.reloadMangas()
            }
        }
    }
    
    private func updateColumns(isCompact: Bool) {
        columns = Array(repeating: .init(.flexible()), count: isCompact ? 3 : 5)
    }
}

#Preview {
    NavigationStack {
        MangasCollectonView(title: "My Collection")
            .environment(CollectionModel(collectionType: .best))
    }
}
