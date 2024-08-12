//
//  ImageExtensions.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

extension Image {
    func mangaViewImageModifier() -> some View {
        self
            .resizable()
            .aspectRatio(0.66, contentMode: .fit)
            .mask(RoundedRectangle(cornerRadius: 10.0))
            .padding()
            
   }
}
