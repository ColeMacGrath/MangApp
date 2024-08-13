//
//  MangasModels.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import Foundation
//import SwiftData

class Manga: Codable, Identifiable, Hashable {
    var id: Int
    var title: String
    var titleJapanese: String?
    var status: String
    var startDate: Date?
    var score: Double
    var sypnosis: String?
    var genres: [Genre]
    var authors: [Author]
    var demographics: [Demographic]
    var themes: [Theme]?
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
            volumes: 5,
            endDate: Date(),
            mainPicture: "https://cdn.myanimelist.net/images/manga/1/152314l.jpg",
            url: "https://www.google.com/?client=safari")
    }
    
    static func == (lhs: Manga, rhs: Manga) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class Genre: Codable, Hashable, Identifiable {
    var id: String
    var genre: String
    
    init(id: String, genre: String) {
        self.id = id
        self.genre = genre
    }
    
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class Author: Codable, Hashable, Identifiable {
    var id: String
    var lastName: String
    var firstName: String
    var role: String
    
    init(id: String, lastName: String, firstName: String, role: String) {
        self.id = id
        self.lastName = lastName
        self.firstName = firstName
        self.role = role
    }
    
    static func == (lhs: Author, rhs: Author) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
class Theme: Codable, Hashable, Identifiable {
    var id: String
    var theme: String
    
    init(id: String, theme: String) {
        self.id = id
        self.theme = theme
    }
    
    static func == (lhs: Theme, rhs: Theme) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class Demographic: Codable, Hashable, Identifiable {
    var id: String
    var demographic: String
    
    init(id: String, demographic: String) {
        self.id = id
        self.demographic = demographic
    }
    
    static func == (lhs: Demographic, rhs: Demographic) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct MangaList: Decodable {
    let mangas: [Manga]
    
    private enum RootKeys: String, CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        self.mangas = try container.decode([Manga].self, forKey: .items)
    }
}

extension Array {
    func getMangaArray() -> [Manga] {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return formatter
        }()
        
        guard let jsonData = loadJSONFromFile(named: "Mangas") else { return [] }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.dataDecodingStrategy = .custom { decoder -> Data in
            let container = try decoder.singleValueContainer()
            let urlString = try container.decode(String.self).trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            if let url = URL(string: urlString), let data = url.absoluteString.data(using: .utf8) {
                return data
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid URL string.")
            }
        }
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        do {
            let mangaList = try decoder.decode(MangaList.self, from: jsonData)
            return mangaList.mangas
        } catch {
            return []
        }
    }
    
    func getAuthorsArray() -> [Author] {
        guard let jsonData = loadJSONFromFile(named: "Authors") else { return [] }
        do {
            let decoder = JSONDecoder()
            let authors = try decoder.decode([Author].self, from: jsonData)
            return authors
        } catch {
            return []
        }
    }
    
    func getDemographicsArray() -> [Demographic] {
        guard let data = loadJSONFromFile(named: "Demographics") else { return [] }
        
        do {
            let demographicStrings = try JSONDecoder().decode([String].self, from: data)
            let demographics = demographicStrings.map { Demographic(id: UUID().uuidString, demographic: $0) }
            
            return demographics
        } catch { return [] }
    }
    
    func getGenresArray() -> [Genre] {
        guard let data = loadJSONFromFile(named: "Genres") else { return [] }
        
        do {
            let genreStrings = try JSONDecoder().decode([String].self, from: data)
            let genres = genreStrings.map { Genre(id: UUID().uuidString, genre: $0) }
            
            return genres
        } catch { return [] }
    }
    
    func getThemesArray() -> [Theme] {
        guard let data = loadJSONFromFile(named: "Themes") else { return [] }
        
        do {
            let themeArray = try JSONDecoder().decode([String].self, from: data)
            let themes = themeArray.map { Theme(id: UUID().uuidString, theme: $0) }
            
            return themes
        } catch { return [] }
    }
    
    private func loadJSONFromFile(named fileName: String) -> Data? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else { return nil }
        do {
            return try Data(contentsOf: url)
        } catch { return nil }
    }
}

//Mark: Swift Data classes
/*@Model
 final class Manga {
 @Attribute(.unique)
 var id: Int
 var title: String
 var titleJapanese: String
 var status: String
 var startDate: String
 var score: Double
 var sypnosis: String
 var genres: [Genre]
 var authors: [Author]
 var demographics: [Demographic]
 var themes: [Theme]?
 var titleEnglish: String?
 var background: String?
 var volumes: Int?
 var chapters: Int?
 var endDate: String?
 var mainPicture: String?
 var url: String?
 
 init(
 id: Int,
 title: String,
 titleJapanese: String,
 status: String,
 startDate: String,
 score: Double,
 sypnosis: String,
 genres: [Genre],
 authors: [Author],
 demographics: [Demographic],
 themes: [Theme]? = nil,
 titleEnglish: String? = nil,
 background: String? = nil,
 volumes: Int? = nil,
 chapters: Int? = nil,
 endDate: String? = nil,
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
 }
 
 @Model
 final class Genre {
 @Attribute(.unique)
 var id: String
 var genre: String
 
 init(id: String, genre: String) {
 self.id = id
 self.genre = genre
 }
 }
 
 @Model
 final class Author {
 @Attribute(.unique)
 var id: String
 var lastName: String
 var firstName: String
 var role: String
 
 init(id: String, lastName: String, firstName: String, role: String) {
 self.id = id
 self.lastName = lastName
 self.firstName = firstName
 self.role = role
 }
 }
 
 @Model
 final class Theme {
 @Attribute(.unique)
 var id: String
 var theme: String
 
 init(id: String, theme: String) {
 self.id = id
 self.theme = theme
 }
 }
 
 @Model
 final class Demographic {
 @Attribute(.unique)
 var id: String
 var demographic: String
 
 init(id: String, demographic: String) {
 self.id = id
 self.demographic = demographic
 }
 }
 */
