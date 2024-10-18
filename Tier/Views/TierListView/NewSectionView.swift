//
//  NewSectionView.swift
//  Tier
//
//  Created by Denis Ravkin on 10.09.2024.
//

import SwiftUI

struct NewSectionView: View {
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                onTap()
            } label: {
                Image(systemName: "plus")
                    .frame(width: SectionCardView.heightWidth, height: SectionCardView.heightWidth)
                    .overlay {
                        Rectangle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    }
            }
            Spacer()
        }
    }
}
