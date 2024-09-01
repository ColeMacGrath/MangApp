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
    
    func loadingView(isPresented: Binding<Bool>, message: String? = nil, color: Color = .accentColor, fullScreen: Bool = false) -> some View {
        self.modifier(LoadingAlertModifier(isPresented: isPresented, message: message, color: color, fullscreen: fullScreen))
    }
    
    func alertView(isPresented: Binding<Bool>, message: String, mode: AlertType) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message, mode: mode))
    }
}

extension EnvironmentValues {
    @Entry var isOnPreview: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
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

