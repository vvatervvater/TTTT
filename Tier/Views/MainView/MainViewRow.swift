//
//  MainViewRow.swift
//  Tier
//
//  Created by Denis Ravkin on 13.09.2024.
//

import SwiftUI

struct MainViewRow: View {
    let text: String
    let isSaving: Bool
    
    var body: some View {
        Text(text)
            .font(.system(size: 19))
            .frame(maxWidth: .infinity)
            .frame(minHeight: 60)
            .padding(5)
            .overlay {
                if isSaving {
                    LoadingView()
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.blue.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal)
    }
}
