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
    
    var body: some View {
        NavigationStack {
            if model.authors.isEmpty {
                HStack {
                    ProgressView()
                    Text("Loading")
                }.foregroundStyle(.secondary)
                
            } else {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(model.authors) { author in
                            VStack(alignment: .center) {
                                Circle()
                                    .fill(Color(uiColor: .systemGray4))
                                    .overlay(Text(author.initials))
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold))
                                    .frame(width: 80)
                                Text(author.fullName)
                            }.padding()
                            
                        }
                    }
                }
                
            }
        }.onAppear {
            model.fetchAuthors()
            updateColumns(isCompact: horizontalSizeClass == .compact)
        }
        .navigationTitle("Authors")
    }
    
    private func updateColumns(isCompact: Bool) {
        columns = Array(repeating: .init(.flexible()), count: isCompact ? 3 : 5)
    }
}

#Preview {
    AuthorsView()
        .environment(AuthorsModel())
}
