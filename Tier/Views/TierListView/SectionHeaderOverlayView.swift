//
//  SectionHeaderOverlayView.swift
//  Tier
//
//  Created by Denis Ravkin on 12.09.2024.
//

import SwiftUI

struct SectionHeaderOverlayView: View {
    @Binding var sections: [Section]
    @Binding var section: Section
    @Binding var selectedSection: Section?
    let editSectionName: (Binding<String>) -> Void
    let buttonsSize: CGFloat
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                changeTextButton
                Spacer()
                deleteSectionButton
            }
            VStack {
                Spacer()
                cancelButton
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottom) { arrowButton(imageName: "arrow.down", offSetBy: 1) }
        .overlay(alignment: .top) { arrowButton(imageName: "arrow.up", offSetBy: -1) }
        .foregroundStyle(.white)
        .overlay(
            Rectangle()
                .stroke(.white, lineWidth: 2)
                .padding(1)
        )
    }
    
    private var cancelButton: some View {
        Button {
            selectedSection = nil
        } label: {
            Image(systemName: "xmark")
                .frame(width: buttonsSize, height: buttonsSize)
                .visualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
        }
    }
    
    private var changeTextButton: some View {
        Button {
            editSectionName($section.name)
        } label: {
            Image(systemName: "pencil")
                .frame(width: buttonsSize, height: buttonsSize)
                .visualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
        }
    }
    
    private var deleteSectionButton: some View {
        Button {
            sections.removeAll { $0.id == section.id }
        } label: {
            Image(systemName: "trash")
                .frame(width: buttonsSize, height: buttonsSize)
                .visualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
        }
    }
    
    private func arrowButton(imageName: String, offSetBy: Int) -> some View {
        Image(systemName: imageName)
            .frame(width: buttonsSize, height: buttonsSize)
            .visualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
            .onTapGesture {
                guard let currentIndex = sections.firstIndex(of: section) else { return }
                let newIndex = sections.index(currentIndex, offsetBy: offSetBy)
                guard sections.indices.contains(newIndex) else { return }
                sections.swapAt(currentIndex, newIndex)
            }
    }
}

