//
//  BaseButtonView.swift
//  Tier
//
//  Created by Denis Ravkin on 12.09.2024.
//

import SwiftUI

struct BaseButtonView: View {
    let text: String
    var foregroundColor = Color.blue.opacity(0.7)
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundColor(foregroundColor)
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(foregroundColor, lineWidth: 1)
                }
        }
    }
}
