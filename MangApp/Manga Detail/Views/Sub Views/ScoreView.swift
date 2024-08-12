//
//  ScoreView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import SwiftUI

struct ScoreView: View {
    var score: Double
    
    var body: some View {
        let components = starComponents(for: score)
        
        HStack(spacing: 2) {
            ForEach(0..<components.fullStars, id: \.self) { _ in
                Image(systemName: "star.fill")
                
            }
            if components.halfStars > 0 {
                Image(systemName: "star.lefthalf.fill")
            }
            ForEach(0..<components.emptyStars, id: \.self) { _ in
                Image(systemName: "star")
            }
        }
        .padding()
        .foregroundStyle(.accent)
        .font(.title)
        
        
    }
    
    private func starComponents(for score: Double) -> (fullStars: Int, halfStars: Int, emptyStars: Int) {
        let fullStars = Int(score / 2)
        let hasHalfStar = (score / 2).truncatingRemainder(dividingBy: 1) >= 0.5
        let halfStars = hasHalfStar ? 1 : 0
        let emptyStars = 5 - fullStars - halfStars
        
        return (fullStars, halfStars, emptyStars)
    }
}

#Preview {
    ScoreView(score: Manga.defaultManga.score)
    
}
