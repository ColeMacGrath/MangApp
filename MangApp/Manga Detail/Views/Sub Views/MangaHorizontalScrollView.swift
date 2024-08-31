//
//  MangaHorizontalScrollView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

struct MangaHorizontalScrollView: View {
    var title: String
    var mangas: [Manga]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
            }
            .padding(.top)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(mangas.prefix(10)) { manga in
                        NavigationLink(destination: MangaDetailView(manga: manga)) {
                            MangaItemView(manga: manga)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MangaHorizontalScrollView(title: "Secton Title", mangas: [.defaultManga])
}
