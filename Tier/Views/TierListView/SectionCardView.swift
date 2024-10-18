//
//  SectionCardView.swift
//  Tier
//
//  Created by Denis Ravkin on 09.09.2024.
//

import SwiftUI

struct SectionCardView: View {
    static var heightWidth: CGFloat = {
        UIScreen.main.bounds.width / CGFloat(SectionView.rowElementsCount + 1)
    }()
    @Binding var image: UIImage
    @Binding var section: Section
    let color: Color
    let isSelected: Bool
    
    var body: some View {
        GeometryReader { proxy in
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipped()
        }
    }
}
