//
//  SelectImagePicker.swift
//  Tier
//
//  Created by Denis Ravkin on 09.09.2024.
//

import SwiftUI
import PhotosUI

struct SelectImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage
    @Binding var shouldShowLoader: Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: PHPickerViewControllerDelegate {
        let parent: SelectImagePicker

        init(_ parent: SelectImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else { return }
            self.parent.shouldShowLoader = true
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                defer { self.parent.shouldShowLoader = false }
                guard let image = image as? UIImage else { return }
                DispatchQueue.main.async {
                    self.parent.selectedImage = image
                }
            }
        }
    }
}


