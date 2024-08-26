//
//  Dashboard.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

struct DashboardView: View {
    @Environment(DashboardModel.self) private var model
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var showAboutView = false
    
    var body: some View {
        @Bindable var model = model
        NavigationStack {
            if model.isLoading {
                LoadingMessageView()
            } else if model.showErrorView {
                ErrorView(title: "Something went wrong at loading mangas", button: ColoredRoundedButton(title: "Retry", action: {
                    model.loadMangas()
                })).padding()
            } else {
                GeometryReader { geometry in
                    ScrollView {
                        VStack {
                            MangaHorizontalScrollView(title: "My Collection", mangas: model.mangaCollection.map { $0.manga })
                            MangaHorizontalScrollView(title: "The Best", mangas: model.bestMangas)
                            
                        }.frame(height: horizontalSizeClass == .compact ? geometry.size.height * 1.3 : geometry.size.height * 1.6)
                            .navigationTitle("Home")
                            .toolbar {
#if !os(macOS)
                                ToolbarItem(placement: .topBarTrailing) {
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
                    }
                }
            }
        }.onAppear {
            model.loadMangas()
        }
    }
}

#Preview {
    NavigationStack {
        DashboardView()
            .environment(DashboardModel())
    }
}
