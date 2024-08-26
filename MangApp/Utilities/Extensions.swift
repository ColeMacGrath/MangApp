//
//  Extensions.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import Foundation
import SwiftUI

let isOnPreview: Bool = {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}()

extension View {
    func applyButtonStyle(backgroundColor: Color = .pink, foregroundColor: Color = .white) -> some View {
        self.modifier(ButtonStyleModifier(backgroundColor: backgroundColor, foregroundColor: foregroundColor))
    }
    
    func myCustomValue(_ isOnPreview: Bool) -> some View {
        environment(\.isOnPreview, isOnPreview)
    }
    
    func loadingView(isPresented: Binding<Bool>, message: String? = nil, color: Color = .accentColor, fullScreen: Bool = false) -> some View {
        self.modifier(LoadingAlertModifier(isPresented: isPresented, message: message, color: color, fullscreen: fullScreen))
    }
    
    func alertView(isPresented: Binding<Bool>, message: String, mode: AlertType) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message, mode: mode))
    }
}

extension String {
    static var emptyString: String {
        return String()
    }
    
    var toURL: URL? {
        do {
            let regex = try Regex("[^a-zA-Z0-9-._~:/?#[@]!$&'()*+,;=%]")
            let cleanedString = self.replacing(regex, with: "")
            return URL(string: cleanedString)
        } catch {
            return nil
        }
        
    }
}

extension EnvironmentValues {
    @Entry var isOnPreview: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}


extension Date {
    func shortDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}

extension URL {
    static let login = APIConfig.baseURL?.appending(path: APIConfig.APIEndpoints.login.rawValue)
    static let renew = APIConfig.baseURL?.appending(path: APIConfig.APIEndpoints.renew.rawValue)
    static let mangas = APIConfig.baseURL?.appending(path: APIConfig.APIEndpoints.list.rawValue).appending(path: APIConfig.APIEndpoints.mangas.rawValue)
    static let bestMangas = APIConfig.baseURL?.appending(path: APIConfig.APIEndpoints.list.rawValue).appending(path: APIConfig.APIEndpoints.bestMangas.rawValue)
    static let authors = APIConfig.baseURL?.appending(path: APIConfig.APIEndpoints.list.rawValue).appending(path: APIConfig.APIEndpoints.authors.rawValue)
    static let demographics = APIConfig.baseURL?.appending(path: APIConfig.APIEndpoints.list.rawValue).appending(path: APIConfig.APIEndpoints.demographics.rawValue)
    static let genres = APIConfig.baseURL?.appending(path: APIConfig.APIEndpoints.list.rawValue).appending(path: APIConfig.APIEndpoints.genres.rawValue)
    static let themes = APIConfig.baseURL?.appending(path: APIConfig.APIEndpoints.list.rawValue).appending(path: APIConfig.APIEndpoints.themes.rawValue)
    static let users = APIConfig.baseURL?.appending(path: APIConfig.APIEndpoints.users.rawValue)
    static let ownManga = APIConfig.baseURL?.appending(path: APIConfig.APIEndpoints.collection.rawValue).appending(path: APIConfig.APIEndpoints.manga.rawValue)
    
    static func mangas(page: Int? = nil, per: Int? = nil, collectionType: CollectionViewType, queryPaths: [String]? = nil) -> URL? {
        guard var url = APIConfig.baseURL?.appending(path: APIConfig.APIEndpoints.list.rawValue) else { return nil }
        
        switch collectionType {
        case .mangas:
            url.append(path: APIConfig.APIEndpoints.mangas.rawValue)
        case .best:
            url.append(path: APIConfig.APIEndpoints.bestMangas.rawValue)
        case .author:
            url.append(path: APIConfig.APIEndpoints.author.rawValue)
        case .collection:
            if let colllectionURL = APIConfig.baseURL?.appending(path: APIConfig.APIEndpoints.collection.rawValue).appending(path: APIConfig.APIEndpoints.manga.rawValue) {
                url = colllectionURL
            }
        }
        
        queryPaths?.forEach { url.append(path: $0) }
        
        guard let page,
              let per else { return url }
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        components.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per", value: String(per))
        ]
        
        return components.url
    }
}

extension Array where Element == Manga {
    mutating func setMangaArray() {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return formatter
        }()
        
        guard let jsonData = loadJSONFromFile(named: "Mangas") else { return }
        
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
            return self = mangaList.mangas
        } catch { }
    }
}

extension Array where Element == Author {
    mutating func setAuthorsArray() {
        guard let jsonData = loadJSONFromFile(named: "Authors") else { return }
        do {
            let decoder = JSONDecoder()
            let authors = try decoder.decode([Author].self, from: jsonData)
            self = authors
        } catch { }
    }
}

extension Array where Element == Demographic {
    mutating func setDemographicsArray() {
        guard let data = loadJSONFromFile(named: "Demographics") else { return }
        
        do {
            let demographicStrings = try JSONDecoder().decode([String].self, from: data)
            let demographics = demographicStrings.map { Demographic(id: UUID().uuidString, demographic: $0) }
            self = demographics
        } catch { return }
    }
}

extension Array where Element == Genre {
    mutating func setGenresArray() {
        guard let data = loadJSONFromFile(named: "Genres") else { return }
        
        do {
            let genreStrings = try JSONDecoder().decode([String].self, from: data)
            let genres = genreStrings.map { Genre(id: UUID().uuidString, genre: $0) }
            self = genres
        } catch { return }
    }
}

extension Array where Element == Theme {
    mutating func setThemesArray() {
        guard let data = loadJSONFromFile(named: "Themes") else { return }
        
        do {
            let themeArray = try JSONDecoder().decode([String].self, from: data)
            let themes = themeArray.map { Theme(id: UUID().uuidString, theme: $0) }
            self = themes
        } catch { return }
    }
}

extension Array {
    private func loadJSONFromFile(named fileName: String) -> Data? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else { return nil }
        do {
            return try Data(contentsOf: url)
        } catch { return nil }
    }
}
