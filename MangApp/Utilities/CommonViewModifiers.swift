//
//  CommonViewModifiers.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-31.
//

import Foundation
import SwiftUI

struct SemiTransparentModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
#if os(iOS)
            .textFieldStyle(.roundedBorder)
#endif
            .opacity(0.7)
            .padding(.horizontal)
    }
}

struct DefaultImagePlaceholder: ViewModifier {
    var isLoader: Bool
    
    init(isLoader: Bool = false) {
        self.isLoader = isLoader
    }
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .foregroundStyle(.gray)
                .overlay {
                    if isLoader {
                        ProgressView()
                            .font(.largeTitle)
                    } else {
                        Image(systemName: "book.circle")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                    }
                }
        }
#if os(iOS)
        .aspectRatio(0.66, contentMode: .fit)
        .padding()
#else
        .frame(width: 300, height: 450)
#endif
    }
}
