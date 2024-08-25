//
//  AuthorsView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-14.
//

import SwiftUI

struct AuthorsView: View {
    @State private var columns: [GridItem] = []
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(AuthorsModel.self) private var model
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            if model.authors.isEmpty {
                HStack {
                    ProgressView()
                    Text("Loading...")
                }.foregroundStyle(.secondary)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(model.authors) { author in
                            VStack(alignment: .center) {
                                AuthorProfilePlaceHolder(author: author)
                            }
                            .padding()
                            .onTapGesture {
                                path.append(author)
                            }
                        }
                    }
                }
                .navigationDestination(for: Author.self) { author in
                    MangasCollectonView(title: author.fullName)
                        .environment(CollectionModel(collectionType: .author, queryPaths: [author.id]))
                }
            }
        }
        .navigationTitle("Authors")
        .onAppear {
            model.fetchAuthors()
            updateColumns(isCompact: horizontalSizeClass == .compact)
        }
    }
    
    private func updateColumns(isCompact: Bool) {
        columns = Array(repeating: .init(.flexible()), count: isCompact ? 3 : 5)
    }
}
#Preview {
    NavigationStack {
        AuthorsView()
            .environment(AuthorsModel())
    }
}
