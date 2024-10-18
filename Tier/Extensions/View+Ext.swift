//
//  View+Ext.swift
//  Tier
//
//  Created by Denis Ravkin on 12.09.2024.
//

import SwiftUI

extension View {
    func gradientBorder(colors: [Color] = [.random(), .random(), .random()]) -> some View {
        self
            .border(LinearGradient(
                    colors: colors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing),
                    width: 3)
    }
}

extension View {
    @ViewBuilder
    func addSwipeAction<V1: View, V2: View>(menu: MenuType = .slided, @ViewBuilder _ content: @escaping () -> TupleView<(Leading<V1>, Trailing<V2>)>) -> some View {
        self.modifier(SwipeAction.init(menu: menu, content))
    }
    
    @ViewBuilder
    func addSwipeAction<V1: View>(menu: MenuType = .slided, edge: HorizontalAlignment, @ViewBuilder _ content: @escaping () -> V1) -> some View {
        switch edge {
        case .leading:
            self.modifier(SwipeAction<V1, EmptyView>.init(menu: menu, leading: content))
        default:
            self.modifier(SwipeAction<EmptyView, V1>.init(menu: menu, trailing: content))
        }
    }
    
    func measureSize(perform action: @escaping (CGSize) -> Void) -> some View {
        self.modifier(MeasureSizeModifier())
            .onPreferenceChange(SizePreferenceKey.self, perform: action)
    }
}

extension View {
    func snapshot() -> UIImage? {
        let controller = UIHostingController(rootView: self.ignoresSafeArea().fixedSize(horizontal: true, vertical: true))
        guard let view = controller.view else { return nil }
    
        let targetSize = view.intrinsicContentSize
        if targetSize.width <= 0 || targetSize.height <= 0 { return nil }
    
        view.bounds = CGRect(origin: .zero, size: targetSize)
        view.backgroundColor = .white
    
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { rendereContext in
            view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

extension View {
    func visualEffectBlur(blurStyle: UIBlurEffect.Style, cornerRadius: CGFloat = 0) -> some View {
        self.modifier(VisualEffectBlurModifier(blurStyle: blurStyle, cornerRadius: cornerRadius))
    }
}
