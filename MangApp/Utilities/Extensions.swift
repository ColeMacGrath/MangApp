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
}
