//
//  MeasureSizeModifier.swift
//  Tier
//
//  Created by Denis Ravkin on 18.10.2024.
//

import Foundation
import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct MeasureSizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.background(GeometryReader { proxy in
            Color.clear.preference(key: SizePreferenceKey.self,
                                   value: proxy.size)
        })
    }
}
