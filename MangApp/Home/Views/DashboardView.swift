//
//  Dashboard.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

struct DashboardView: View {
    @Environment(DashboardModel.self) private var model
    @State private var showAboutView = false
    
    var body: some View {
        @Bindable var model = model
        NavigationStack {
            MangaHorizontalScrollView(title: "My Collection", mangas: $model.mangaCollection.wrappedValue)
            MangaHorizontalScrollView(title: "The Best", mangas: $model.bestMangas.wrappedValue)
                .navigationTitle("Home")
                .toolbar {
#if !os(macOS)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showAboutView = true
                        } label: {
                            Image(systemName: "person.circle.fill")
                        }
                    }
#endif
                }
                .sheet(isPresented: $showAboutView) {
                    AboutView()
                }
        }.onAppear {
            model.loadCollection()
        }
    }
    
}


#Preview {
    NavigationStack {
        DashboardView()
            .environment(DashboardModel())
    }
}
