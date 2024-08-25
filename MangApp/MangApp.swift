//
//  MangAppApp.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-05.
//

import SwiftUI
import SwiftData

@main
struct MangApp: App {
    @Environment(\.scenePhase) var scenePhase
    @State private var loginModel = LoginModel()
    @State private var dashboardModel = DashboardModel()
    @State private var collectionModel = CollectionModel()
    @State private var searchModel = SearchModel()
    @State private var authorsModel = AuthorsModel()
    @State private var signUpModel = SignUpModel()
    @State private var ownMangaModel = OwnMangaModel()
    @State private var tokenRenewalToken = TokenRenewalToken()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            OwnManga.self,
            Manga.self,
            Genre.self,
            Author.self,
            Theme.self,
            Demographic.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            InitialView()
                .onChange(of: scenePhase) {
                    if scenePhase == .active {
                        tokenRenewalToken.renewTokenIfNeeded()
                    }
                }
        }
        .environment(loginModel)
        .environment(dashboardModel)
        .environment(collectionModel)
        .environment(authorsModel)
        .environment(searchModel)
        .environment(signUpModel)
        .environment(ownMangaModel)
        .modelContainer(sharedModelContainer)
    }
}
