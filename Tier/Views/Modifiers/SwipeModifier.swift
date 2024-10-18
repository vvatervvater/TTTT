//
//  SwipeModifier.swift
//  Tier
//
//  Created by Denis Ravkin on 13.09.2024.
//

import SwiftUI

typealias Leading<V> = Group<V> where V: View
typealias Trailing<V> = Group<V> where V: View

enum MenuType {
    case slided
    case swiped
}

struct SwipeAction<V1: View, V2: View>: ViewModifier {
    enum VisibleButton {
        case none
        case left
        case right
    }
    
    @State private var offset: CGFloat = 0
    @State private var oldOffset: CGFloat = 0
    @State private var visibleButton: VisibleButton = .none
    
    private let trailingIndent: CGFloat = 0
    
    @GestureState private var dragGestureActive: Bool = false
    
    @State private var maxLeadingOffset: CGFloat = .zero
    @State private var minTrailingOffset: CGFloat = .zero
    
    @State private var maxLeadingOffsetIsCounted: Bool = false
    @State private var minTrailingOffsetIsCounted: Bool = false
    
    private let menuType: MenuType
    private let leadingSwipeView: Group<V1>?
    private let trailingSwipeView: Group<V2>?
    
    init(menu: MenuType, @ViewBuilder _ content: @escaping () -> TupleView<(Leading<V1>, Trailing<V2>)>) {
        menuType = menu
        leadingSwipeView = content().value.0
        trailingSwipeView = content().value.1
    }
    
    init(menu: MenuType, @ViewBuilder leading: @escaping () -> V1) {
        menuType = menu
        leadingSwipeView = Group { leading() }
        trailingSwipeView = nil
    }
    
    init(menu: MenuType, @ViewBuilder trailing: @escaping () -> V2) {
        menuType = menu
        trailingSwipeView = Group { trailing() }
        leadingSwipeView = nil
    }
    
    func reset() {
        visibleButton = .none
        offset = 0
        oldOffset = 0
    }
    
    var leadingView: some View {
        leadingSwipeView
            .measureSize {
                if !maxLeadingOffsetIsCounted {
                    maxLeadingOffset = maxLeadingOffset + $0.width
                }
            }
            .onAppear {
                maxLeadingOffsetIsCounted = true
            }
    }
    
    var trailingView: some View {
        trailingSwipeView
            .measureSize {
                if !minTrailingOffsetIsCounted {
                    minTrailingOffset = ((abs(minTrailingOffset) + $0.width) * -1) - trailingIndent
                }
            }
            .onAppear {
                minTrailingOffsetIsCounted = true
            }
    }
    
    var swipedMenu: some View {
        HStack(spacing: 0) {
            leadingView
            Spacer()
            trailingView
        }
    }
    
    var slidedMenu: some View {
        HStack(spacing: 0) {
            leadingView
                .offset(x: (-1 * maxLeadingOffset) + offset)
            Spacer()
            trailingView
                .offset(x: (-1 * minTrailingOffset) + offset)
        }
    }
    
    func gesturedContent(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .offset(x: offset)
            .gesture(
                DragGesture(minimumDistance: 16, coordinateSpace: .local)
                    .updating($dragGestureActive) { value, state, transaction in
                        state = true
                    }
                    .onChanged { value in
                        let totalSlide = value.translation.width + oldOffset
                        
                        if  (0...Int(maxLeadingOffset) ~= Int(totalSlide)) || (Int(minTrailingOffset)...0 ~= Int(totalSlide)) {
                            withAnimation {
                                offset = totalSlide
                            }
                        }
                    }.onEnded { value in
                        withAnimation {
                            if visibleButton == .left && value.translation.width < -16 {
                                reset()
                            } else if visibleButton == .right && value.translation.width > 16 {
                                reset()
                            } else if offset > 16 || offset < -16 {
                                if offset > 0 {
                                    visibleButton = .left
                                    offset = maxLeadingOffset
                                } else {
                                    visibleButton = .right
                                    offset = minTrailingOffset
                                }
                                oldOffset = offset
                            } else {
                                reset()
                            }
                        }
                    })
            .onChange(of: dragGestureActive)  { newIsActiveValue in
                if newIsActiveValue == false {
                    withAnimation {
                        if visibleButton == .none {
                            reset()
                        }
                    }
                }
            }
    }
    
    public func body(content: Content) -> some View {
        switch menuType {
        case .slided:
            ZStack {
                gesturedContent(content: content)
                slidedMenu
            }
        case .swiped:
            ZStack {
                swipedMenu
                gesturedContent(content: content)
            }
        }
    }
}
