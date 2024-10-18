//
//  LoadingView.swift
//  Tier
//
//  Created by Denis Ravkin on 18.10.2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .blue.opacity(0.3)))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
    }
}

#Preview {
    LoadingView()
}
