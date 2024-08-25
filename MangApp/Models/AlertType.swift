//
//  ToastMode.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-24.
//

import SwiftUI

enum AlertType {
    case warning
    case success
    case error
    
    var backgroundColor: Color {
        switch self {
        case .warning:
            return Color.yellow
        case .success:
            return Color.green
        case .error:
            return Color.red
        }
    }
}
