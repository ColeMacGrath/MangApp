//
//  Collection.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import SwiftUI

struct MangasCollectonView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var mangas: [Manga]
    var title: String
    @State private var columns: [GridItem] = []
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(mangas, id: \.self) { manga in
                        NavigationLink(destination: MangaDetailView(manga: manga)) {
                            MangaItemView(manga: manga)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle(title)
            .onAppear {
                updateColumns(isCompact: horizontalSizeClass == .compact)
            }
            .onChange(of: geometry.size) {
                updateColumns(isCompact: horizontalSizeClass == .compact)
            }
        }
    }
    
    private func updateColumns(isCompact: Bool) {
        columns = Array(repeating: .init(.flexible()), count: isCompact ? 3 : 5)
    }
}

#Preview {
    MangasCollectonView(mangas: [].getMangaArray(), title: "My Collection")
}
