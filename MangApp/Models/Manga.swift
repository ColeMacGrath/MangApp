//
//  Manga.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-18.
//

import Foundation
import SwiftData

@Model
class Manga: Codable, Hashable, Identifiable {
    var id: Int
    var title: String
    var titleJapanese: String?
    var status: String
    var startDate: Date?
    var score: Double
    var sypnosis: String?
    var themes: [Theme]?
    var genres: [Genre]
    var demographics: [Demographic]
    var authors: [Author]
    var titleEnglish: String?
    var background: String?
    var volumes: Int?
    var chapters: Int?
    var endDate: Date?
    var mainPicture: String?
    var url: String?
    var mainPictureURL: URL?
    
    init(
        id: Int,
        title: String,
        titleJapanese: String,
        status: String,
        startDate: Date,
        score: Double,
        genres: [Genre],
        authors: [Author],
        demographics: [Demographic],
        sypnosis: String? = nil,
        themes: [Theme]? = nil,
        titleEnglish: String? = nil,
        background: String? = nil,
        volumes: Int? = nil,
        chapters: Int? = nil,
        endDate: Date? = nil,
        mainPicture: String? = nil,
        url: String? = nil
    ) {
        self.id = id
        self.title = title
        self.titleJapanese = titleJapanese
        self.status = status
        self.startDate = startDate
        self.score = score
        self.sypnosis = sypnosis
        self.genres = genres
        self.authors = authors
        self.demographics = demographics
        self.themes = themes
        self.titleEnglish = titleEnglish
        self.background = background
        self.volumes = volumes
        self.chapters = chapters
        self.endDate = endDate
        self.mainPicture = mainPicture
        self.url = url
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case titleJapanese
        case status
        case startDate
        case score
        case sypnosis
        case genres
        case authors
        case demographics
        case themes
        case titleEnglish
        case background
        case volumes
        case chapters
        case endDate
        case mainPicture
        case url
        case mainPictureURL
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.titleJapanese = try container.decodeIfPresent(String.self, forKey: .titleJapanese)
        self.status = try container.decode(String.self, forKey: .status)
        self.startDate = try container.decodeIfPresent(Date.self, forKey: .startDate)
        self.score = try container.decode(Double.self, forKey: .score)
        self.sypnosis = try container.decodeIfPresent(String.self, forKey: .sypnosis)
        self.genres = try container.decode([Genre].self, forKey: .genres)
        self.authors = try container.decode([Author].self, forKey: .authors)
        self.demographics = try container.decode([Demographic].self, forKey: .demographics)
        self.themes = try container.decodeIfPresent([Theme].self, forKey: .themes)
        self.titleEnglish = try container.decodeIfPresent(String.self, forKey: .titleEnglish)
        self.background = try container.decodeIfPresent(String.self, forKey: .background)
        self.volumes = try container.decodeIfPresent(Int.self, forKey: .volumes)
        self.chapters = try container.decodeIfPresent(Int.self, forKey: .chapters)
        self.endDate = try container.decodeIfPresent(Date.self, forKey: .endDate)
        self.mainPicture = try container.decodeIfPresent(String.self, forKey: .mainPicture)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.mainPictureURL = try container.decodeIfPresent(URL.self, forKey: .mainPictureURL)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(titleJapanese, forKey: .titleJapanese)
        try container.encode(status, forKey: .status)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(score, forKey: .score)
        try container.encode(sypnosis, forKey: .sypnosis)
        try container.encode(genres, forKey: .genres)
        try container.encode(authors, forKey: .authors)
        try container.encode(demographics, forKey: .demographics)
        try container.encode(themes, forKey: .themes)
        try container.encode(titleEnglish, forKey: .titleEnglish)
        try container.encode(background, forKey: .background)
        try container.encode(volumes, forKey: .volumes)
        try container.encode(chapters, forKey: .chapters)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(mainPicture, forKey: .mainPicture)
        try container.encode(url, forKey: .url)
        try container.encode(mainPictureURL, forKey: .mainPictureURL)
    }
    
    static func == (lhs: Manga, rhs: Manga) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static var defaultManga: Manga {
        Manga(
            id: 309,
            title: "Ghost!",
            titleJapanese: "ゴースト！",
            status: "finished",
            startDate: Date(),
            score: 7.03,
            genres: [
                Genre(id: "F974BCB6-B002-44A6-A224-90D1E50595A2", genre: "Comedy"),
                Genre(id: "D974BCB6-B002-44A6-A224-90D1E50595A2", genre: "Drama")
            ],
            authors: [
                Author(id: "3B740F31-27F9-4559-8B24-3116803694C7", lastName: "Shuri", firstName: "Shiozu", role: "Story & Art"),
                Author(id: "TB740F31-27F9-4559-8B24-3116803694C7", lastName: "Author", firstName: "Other", role: "History")
            ],
            demographics: [
                Demographic(id: "C217B404-7691-4090-9775-9E63375EBF5B", demographic: "Shoujo"),
                Demographic(id: "A217B404-7691-4090-9775-9E63375EBF5B", demographic: "Other Demographic")
            ],
            sypnosis: "Mitsuo Shiozu is a lonely high school student who happens to be psychic. Spirits use his body and mind to communicate with the dead and to help the living. These ghostly apparitions use Mitsuo in order to put right things that were left undone in life, or to tie up ends that were left loose before they left the land of the living.\n\nIn the process, Mitsuo often finds that these 'visitations' change his own life in ways he could not predict. (Source: Tokyopop)",
            themes: [
                Theme(id: "0", theme: "Manga Themes"),
                Theme(id: "1", theme: "Other Theme")
            ],
            background: "BackGround Theme",
            volumes: 6,
            endDate: Date(),
            mainPicture: "https://cdn.myanimelist.net/images/manga/1/152314l.jpg",
            url: "https://www.google.com/?client=safari")
    }
}
