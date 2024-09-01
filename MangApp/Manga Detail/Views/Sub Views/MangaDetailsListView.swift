//
//  MangaDetailsListView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

struct MangaDetailsListView: View {
    var manga: Manga
    @Environment(\.presentationMode) var presentationMode
    var modalPresentation: Bool
    let orderedMangaSections: [(section: String, fields: [String])] = [
        ("General Information", [
            "title",
            "titleJapanese",
            "score",
            "synopsis",
            "volumes",
            "startDate",
            "endDate",
            "status"
        ]),
        ("Demographics", ["demographics"]),
        ("Genres", ["genres"]),
        ("Themes", ["themes"]),
        ("Authors", ["authors"]),
        ("Other Information", [
            "id",
            "background",
            "url"
        ])
    ]
    
    let fieldTitles: [String: String] = [
        "title": "Title",
        "titleJapanese": "Japanese Title",
        "score": "Score",
        "synopsis": "Synopsis",
        "volumes": "Volumes",
        "startDate": "Start Date",
        "endDate": "End Date",
        "status": "Status",
        "demographics": "Demographics",
        "genres": "Genres Titles",
        "themes": "Themes",
        "authors": "Author Name",
        "id": "ID",
        "background": "Background",
        "url": "Visit in MyAnimeList"
    ]
    
    var body: some View {
        Group {
            if modalPresentation {
                NavigationStack {
                    contentView
#if os(iOS)
                        .navigationBarTitle("Manga Details", displayMode: .inline)
#endif
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    presentationMode.wrappedValue.dismiss()
                                }.buttonStyle(.automatic)
                            }
                        }
                }
            } else {
                contentView
                
            }
        }
    }
    
    var contentView: some View {
        List {
            ForEach(orderedMangaSections, id: \.section) { section in
                let sectionRows = section.fields.compactMap { key in
                    getValue(for: key).map { (title: fieldTitles[key], value: $0) }
                }
                
                
                
                if !sectionRows.isEmpty {
                    Section(header: Text(section.section)) {
                        ForEach(sectionRows, id: \.title) { row in
                            if row.title == "Author Name" {
                                ForEach(manga.authors) { author in
                                    SubtitleRowView(title: "\(author.firstName) \(author.lastName)", subtitle: author.role)
                                }
                            } else if let rowTitle = row.title,
                                      rowTitle == "Visit in MyAnimeList",
                                      let url = manga.url?.toURL {
                                Button(action: {
#if os(iOS)
                                    UIApplication.shared.open(url)
#endif
                                }) {
                                    HStack {
                                        SubtitleRowView(title: rowTitle, subtitle: url.absoluteString)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.secondary)
                                    }
                                }
                            } else {
                                if !row.value.isEmpty,
                                   let rowTitle = row.title {
                                    SubtitleRowView(title: rowTitle, subtitle: row.value)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func getValue(for key: String) -> String? {
        switch key {
        case "title":
            return manga.title
        case "titleJapanese":
            return manga.titleJapanese
        case "score":
            return "\(manga.score)"
        case "synopsis":
            return manga.sypnosis
        case "volumes":
            return manga.volumes.map { "\($0)" }
        case "startDate":
            return manga.startDate?.shortDate()
        case "endDate":
            return manga.endDate?.shortDate()
        case "status":
            return manga.status
        case "demographics":
            return manga.demographics.map { $0.demographic }.joined(separator: ", ")
        case "genres":
            return manga.genres.map { $0.genre }.joined(separator: ", ")
        case "themes":
            guard let themes = manga.themes else { return nil }
            return themes.map { $0.theme }.joined(separator: ", ")
        case "authors":
            return manga.authors.first.map { "\($0.firstName) \($0.lastName)" }
        case "firstName":
            return manga.authors.first?.firstName
        case "lastName":
            return manga.authors.first?.lastName
        case "role":
            return manga.authors.first?.role
        case "id":
            return "\(manga.id)"
        case "background":
            return manga.background
        case "url":
            return manga.url
        default:
            return nil
        }
    }
}


#Preview {
    NavigationStack {
        MangaDetailsListView(manga: Manga.defaultManga, modalPresentation: true)
    }
}

