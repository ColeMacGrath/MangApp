//
//  EditMangaInfoView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-17.
//

import SwiftUI

struct EditMangaInfoView: View {
    @Environment(OwnMangaModel.self) private var model
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        @Bindable var model = model
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Section("Owned Volumes") {
                        SelectedVolumesView()
                            .environment(self.model)
                    }
                    
                    Section("Current reading volume") {
                        SelectedReadingVolumes()
                            .environment(self.model)
                    }
                }
                .padding(.horizontal)
            }
            
            ColoredRoundedButton(title: "Save") {
                if let manga = model.manga {
                    Task {
                        if await model.save(manga: manga) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            
            .navigationTitle("Editing \(model.ownManga?.manga.title ?? "")")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }.buttonStyle(.automatic)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditMangaInfoView()
            .environment(OwnMangaModel(manga: .defaultManga, ownManga: OwnManga(id: "", volumesOwned: [1, 2, 3, 5], completeCollection: false, readingVolume: 1, manga: Manga.defaultManga)))
    }
    
}
