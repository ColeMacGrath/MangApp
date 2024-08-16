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
        VStack {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
                Spacer()
                Button(action: {
                    print("See All")
                }) {
                    Text("See all")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.trailing)
                }
            }
            .padding(.top)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(mangas) { manga in
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
