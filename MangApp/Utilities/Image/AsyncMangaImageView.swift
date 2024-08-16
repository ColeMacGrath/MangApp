//
//  AsyncMangaImageView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

struct AsyncMangaImageView: View {
    var geometry: GeometryProxy
#if !os(macOS)
    var motionManager = MotionManager()
#endif
    var url: URL?
    @Environment(\.horizontalSizeClass) private var horizontalSize
    @State private var angle: Double = 0
    
    var body: some View {
        if isOnPreview {
            Image(.mangaCover)
                .mangaViewImageModifier()
        } else if let url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .mangaViewImageModifier()
#if !os(macOS)
                        .rotation3DEffect(.degrees(angle + motionManager.yRotation), axis: (x: 0, y: 1, z: 0))
#endif
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    let width = horizontalSize == .compact ? geometry.size.width : geometry.size.width / 2
                                    let dragAmount = gesture.translation.width / width
                                    let sensitivity = 30.0
                                    angle = Double(dragAmount * sensitivity)
                                }
                                .onEnded { _ in
                                    withAnimation(.spring()) {
                                        angle = 0
                                    }
                                }
                        )
                case .empty:
                    RoundedRectangle(cornerRadius: 8)
                        .modifier(DefaultImagePlaceholder(isLoader: true))
                default:
                    RoundedRectangle(cornerRadius: 8)
                        .modifier(DefaultImagePlaceholder())
                }
            }
        } else {
            RoundedRectangle(cornerRadius: 8)
                .modifier(DefaultImagePlaceholder())
        }
    }
}
