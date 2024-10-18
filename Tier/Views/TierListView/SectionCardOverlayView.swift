//
//  SectionCardOverlayView.swift
//  Tier
//
//  Created by Denis Ravkin on 12.09.2024.
//

import SwiftUI

struct SectionCardOverlayView: View {
    @State private var showImagePicker: Bool = false
    @Binding var selectedImage: UIImage?
    @Binding var section: Section
    @Binding var image: UIImage
    let buttonsSize: CGFloat
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                changeImageButton
                Spacer()
                deleteImageButton
            }
            VStack {
                Spacer()
                cancelButton
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .leading) { arrowButton(imageName: "arrow.left", offSetBy: -1) }
        .overlay(alignment: .trailing) { arrowButton(imageName: "arrow.right", offSetBy: 1) }
        .overlay(alignment: .bottom) { arrowButton(imageName: "arrow.down", offSetBy: SectionView.rowElementsCount) }
        .overlay(alignment: .top) { arrowButton(imageName: "arrow.up", offSetBy: -SectionView.rowElementsCount) }
        .overlay(
            Rectangle()
                .stroke(.white, lineWidth: 2)
                .padding(1)
        )
        .foregroundStyle(.white)
        .sheet(isPresented: $showImagePicker) {
            SelectImagePicker(selectedImage: $image, shouldShowLoader: .constant(false))
                .ignoresSafeArea()
        }
    }
    
    private var deleteImageButton: some View {
        actionButton(imageName: "trash") {
            section.images.removeAll {
                $0.image === image
            }
        }
    }
    
    private var cancelButton: some View {
        actionButton(imageName: "xmark") {
            selectedImage = nil
        }
    }
    
    private var changeImageButton: some View {
        actionButton(imageName: "pencil") {
            showImagePicker = true
        }
    }
    
    private func actionButton(imageName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: imageName)
                .frame(width: buttonsSize, height: buttonsSize)
                .visualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
        }
    }
    
    private func arrowButton(imageName: String, offSetBy: Int) -> some View {
        Image(systemName: imageName)
            .frame(width: buttonsSize, height: buttonsSize)
            .visualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
            .onTapGesture {
                guard let currentIndex = section.images.firstIndex(where: { $0.image == image }) else { return }
                let newIndex = section.images.index(currentIndex, offsetBy: offSetBy)
                guard section.images.indices.contains(newIndex) else { return }
                section.images.swapAt(currentIndex, newIndex)
            }
    }
}
