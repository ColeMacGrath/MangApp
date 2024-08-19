//
//  Collection.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import SwiftUI
import TipKit

struct MangasCollectonView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(CollectionModel.self) private var model
    @Environment(\.modelContext) private var modelContext
    @State private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    @State private var showOfflineModeModal: Bool = false
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if model.offline {
                            model.offline = false
                            model.loadInitialMangas()
                        } else {
                            showOfflineModeModal = true
                        }
                    }) {
                        model.offline ? Image(systemName: "bolt.horizontal.icloud.fill") : Image(systemName: "bolt.horizontal.icloud")
                    }
                }
            }
            .navigationTitle(title)
            .onAppear {
                updateColumns(isCompact: horizontalSizeClass == .compact)
                model.loadInitialMangas(context: modelContext)
            }
            .onChange(of: geometry.size) {
                updateColumns(isCompact: horizontalSizeClass == .compact)
            }
            .refreshable {
                model.reloadMangas()
            }
            .sheet(isPresented: $showOfflineModeModal) {
                NavigationStack {
                    OfflineInfoView()
                        .environment(model)
                }
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
