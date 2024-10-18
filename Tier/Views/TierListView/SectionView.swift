//
//  SectionView.swift
//  Tier
//
//  Created by Denis Ravkin on 09.09.2024.
//

import SwiftUI

struct SectionView: View {
    static let rowElementsCount = 3
    private var columns: [GridItem] = .init(repeating: .init(spacing: 0), count: rowElementsCount)
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @Binding private var section: Section
    @Binding private var selectedSection: Section?
    @Binding private var sections: [Section]
    private let hideSomeUIForScreenshot: Bool
    private let editSectionName: (Binding<String>) -> Void
    
    init(section: Binding<Section>, selectedSection: Binding<Section?>, sections: Binding<[Section]>, hideSomeUIForScreenshot: Bool, editSectionName: @escaping (Binding<String>) -> Void) {
        self._section = section
        self._selectedSection = selectedSection
        self._sections = sections
        self.hideSomeUIForScreenshot = hideSomeUIForScreenshot
        self.editSectionName = editSectionName
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            sectionHeader
            sectionCards
                .frame(maxWidth: .infinity)
        }
    }
    
    private var sectionHeader: some View {
        VStack {
            Text(section.name)
                .padding(5)
        }
        .frame(width: SectionCardView.heightWidth)
        .frame(minHeight: SectionCardView.heightWidth, maxHeight: .infinity)
        .background(section.color)
        .overlay {
            if selectedSection?.id == section.id && !hideSomeUIForScreenshot {
                SectionHeaderOverlayView(sections: $sections, section: $section, selectedSection: $selectedSection, editSectionName: editSectionName, buttonsSize: SectionCardView.heightWidth / 3)
            }
        }
    }
    
    private var sectionCards: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 0) {
            ForEach($section.images, id: \.id) { card in
                Button {
                    selectedImage = card.wrappedValue.image
                } label: {
                    SectionCardView(image: card.image, section: $section, color: .white, isSelected: card.wrappedValue.image == selectedImage)
                        .frame(width: SectionCardView.heightWidth, height: SectionCardView.heightWidth)
                }
                .overlay {
                    if card.wrappedValue.image == selectedImage && !hideSomeUIForScreenshot {
                        SectionCardOverlayView(selectedImage: $selectedImage, section: $section, image: card.image, buttonsSize: SectionCardView.heightWidth / 3)
                    }
                }
            }
            
            if !hideSomeUIForScreenshot {
                Button {
                    showImagePicker = true
                } label: {
                    Image(systemName: "plus")
                        .frame(width: SectionCardView.heightWidth, height: SectionCardView.heightWidth)
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            SelectMultipleImagesPicker(selectedImages: .init(get: {
                .init()
            }, set: {
                section.images += $0.map({ .init(image: $0) })
            }), shouldShowLoader: .constant(false))
            .ignoresSafeArea()
        }
    }
}
