//
//  VisualEffectBlurModifier.swift
//  Tier
//
//  Created by Denis Ravkin on 18.10.2024.
//

import Foundation
import SwiftUI

struct VisualEffectBlurModifier: ViewModifier {
    var blurStyle: UIBlurEffect.Style
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                VisualEffectBlur(blurStyle: blurStyle, cornerRadius: cornerRadius)
            )
    }
}

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    var cornerRadius: CGFloat = 0
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
