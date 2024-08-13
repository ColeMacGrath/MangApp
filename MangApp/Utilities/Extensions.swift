//
//  Extensions.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import Foundation
import SwiftUI

extension View {
    func applyButtonStyle(backgroundColor: Color = .pink, foregroundColor: Color = .white) -> some View {
        self.modifier(ButtonStyleModifier(backgroundColor: backgroundColor, foregroundColor: foregroundColor))
    }
    
    func myCustomValue(_ isOnPreview: Bool) -> some View {
        environment(\.isOnPreview, isOnPreview)
    }
}

extension String {
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
    static let mangas = APIConfig.baseURL?.appending(path: APIConfig.APIEndpoints.list.rawValue).appending(path: APIConfig.APIEndpoints.mangas.rawValue)
    static let bestMangas = APIConfig.baseURL?.appending(path: APIConfig.APIEndpoints.list.rawValue).appending(path: APIConfig.APIEndpoints.bestMangas.rawValue)
    
    static func mangas(page: Int, per: Int, collectionType: CollectionViewType) -> URL? {
        guard let url = APIConfig.baseURL?
            .appending(path: APIConfig.APIEndpoints.list.rawValue)
            .appending(path: collectionType == .mangas ? APIConfig.APIEndpoints.mangas.rawValue : APIConfig.APIEndpoints.bestMangas.rawValue) else { return nil }
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        components.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per", value: String(per))
        ]
        return components.url
    }
}
