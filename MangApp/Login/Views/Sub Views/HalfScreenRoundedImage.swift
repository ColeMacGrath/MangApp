//
//  HalfScreenRoundedImage.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

struct HalfScreenRoundedImage: View {
    var image: Image
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width / 2, height: height)
            .cornerRadius(10.0)
            .padding(.horizontal)
    }
}

#Preview {
    GeometryReader { geometry in
        HalfScreenRoundedImage(image: Image(.login), width: geometry.size.width, height: geometry.size.height)
    }
}
