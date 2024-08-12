//
//  FilterMenu.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-12.
//

import SwiftUI

struct FilterMenu: View {
    var genres: [Genre]
    @Binding var selectedGenres: Set<Genre>
    var demographics: [Demographic]
    @Binding var selectedDemographics: Set<Demographic>
    var themes: [Theme]
    @Binding var selectedThemes: Set<Theme>
    
    var body: some View {
        Menu {
            Menu("Genres") {
                ForEach(genres) { genre in
                    Toggle(genre.genre, isOn: Binding(
                        get: { selectedGenres.contains(genre) },
                        set: { isSelected in
                            if isSelected {
                                selectedGenres.insert(genre)
                            } else {
                                selectedGenres.remove(genre)
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
                                selectedDemographics.insert(demographic)
                            } else {
                                selectedDemographics.remove(demographic)
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
                                selectedThemes.insert(theme)
                            } else {
                                selectedThemes.remove(theme)
                            }
                        }
                    ))
                }
            }
        } label: {
            Image(systemName: "slider.horizontal.3")
        }
    }
}
