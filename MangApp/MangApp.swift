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
    @State private var loginModel = LoginModel()
    @State private var dashboardModel = DashboardModel()
    @State private var collectionModel = CollectionModel()
    @State private var searchModel = SearchModel()
    @State private var authorsModel = AuthorsModel()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
        }
        .environment(loginModel)
        .environment(dashboardModel)
        .environment(collectionModel)
        .environment(authorsModel)
        .environment(searchModel)
        .modelContainer(sharedModelContainer)
    }
}
