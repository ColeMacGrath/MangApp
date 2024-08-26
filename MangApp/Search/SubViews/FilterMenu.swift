//
//  FilterMenu.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-12.
//

import SwiftUI

struct FilterMenu: View {
    var genres: [Genre]
    @Binding var selectedGenres: [Genre]
    var demographics: [Demographic]
    @Binding var selectedDemographics: [Demographic]
    var themes: [Theme]
    @Binding var selectedThemes: [Theme]
    var resetAction: () -> Void
    
    var body: some View {
        Menu {
            Menu("Genres") {
                ForEach(genres, id: \.self) { genre in
                    Button(action: {
                        toggleSelection(for: genre, in: &selectedGenres)
                    }) {
                        HStack {
                            Text(genre.genre)
                            if selectedGenres.contains(genre) {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            
            Menu("Demographics") {
                ForEach(demographics, id: \.self) { demographic in
                    Button(action: {
                        toggleSelection(for: demographic, in: &selectedDemographics)
                    }) {
                        HStack {
                            Text(demographic.demographic)
                            if selectedDemographics.contains(demographic) {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            
            Menu("Themes") {
                ForEach(themes, id: \.self) { theme in
                    Button(action: {
                        toggleSelection(for: theme, in: &selectedThemes)
                    }) {
                        HStack {
                            Text(theme.theme)
                            if selectedThemes.contains(theme) {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            
            Section {
                Button(role: .destructive, action: {
                    resetAction()
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Reset Filters")
                    }
                }
            }
            
        } label: {
            Label(String(), systemImage: "slider.horizontal.3")
        }
    }
    
    private func toggleSelection<T: Equatable>(for item: T, in collection: inout [T]) {
        if let index = collection.firstIndex(of: item) {
            collection.remove(at: index)
        } else {
            collection.append(item)
        }
    }
}
