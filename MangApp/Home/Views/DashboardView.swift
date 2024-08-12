//
//  Dashboard.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

struct DashboardView: View {
    private let sampleMangas = [].getMangaArray()
    @State private var showAboutView = false
    
    var body: some View {
        NavigationStack {
            MangaHorizontalScrollView(title: "My Collection", mangas: sampleMangas)
            MangaHorizontalScrollView(title: "The Best", mangas: sampleMangas)
                .navigationTitle("Home")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showAboutView = true
                        } label: {
                            Image(systemName: "person.circle.fill")
                        }
                    }
                }
                .sheet(isPresented: $showAboutView) {
                    AboutView()
                }
        }
    }
    
}


#Preview {
    NavigationStack {
        DashboardView()
    }
}
