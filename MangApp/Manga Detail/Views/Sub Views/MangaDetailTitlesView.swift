//
//  MangaDetailTitlesView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

struct MangaDetailTitlesView: View {
    var manga: Manga
    @State var isLoaded: Bool
    @State var isCollectionCompleted: Bool
    
    var body: some View {
        HStack {
            Text(manga.title)
                
            if isLoaded,
               isCollectionCompleted {
                Text(" ✅")
            }
        }
        .bold()
        .font(.title)
        
        Text(manga.titleJapanese ?? "")
            .foregroundStyle(.secondary)
            .font(.title2)
            .padding(.bottom)
    }
}

#Preview {
    NavigationStack {
        MangaDetailTitlesView(manga: .defaultManga, isLoaded: true, isCollectionCompleted: true)
    }
}

