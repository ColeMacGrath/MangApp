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
    
    var body: some View {
        Menu {
            Menu("Genres") {
                ForEach(genres) { genre in
                    Toggle(genre.genre, isOn: Binding(
                        get: { selectedGenres.contains(genre) },
                        set: { isSelected in
                            if isSelected {
                                selectedGenres.append(genre)
                            } else {
                                selectedGenres.append(genre)
                            }
                        }
                    ))
                }
            }
            
            Menu("Demographics") {
                ForEach(demographics) { demographic in
                    Toggle(demographic.demographic, isOn: Binding(
                        get: { selectedDemographics.contains(demographic) },
                        set: { isSelected in
                            if isSelected {
                                selectedDemographics.append(demographic)
                            } else {
                                selectedDemographics.append(demographic)
                            }
                        }
                    ))
                }
            }
            
            Menu("Theme") {
                ForEach(themes) { theme in
                    Toggle(theme.theme, isOn: Binding(
                        get: { selectedThemes.contains(theme) },
                        set: { isSelected in
                            if isSelected {
                                selectedThemes.append(theme)
                            } else {
                                selectedThemes.append(theme)
                            }
                        }
                    ))
                }
            }
            
            Section {
                Button {
                    selectedGenres.removeAll()
                    selectedDemographics.removeAll()
                    selectedThemes.removeAll()
                } label: {
                    HStack {
                        Text("Reset Filters")
                            .foregroundStyle(.red)
                        Image(systemName: "trash")
                    }
                }
            }
            
        } label: {
            Image(systemName: "slider.horizontal.3")
        }
    }
}
