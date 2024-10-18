//
//  SelectMultipleImagesPicker.swift
//  Tier
//
//  Created by Denis Ravkin on 12.09.2024.
//

import SwiftUI
import PhotosUI

struct SelectMultipleImagesPicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    @Binding var shouldShowLoader: Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = .max
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
        let parent: SelectMultipleImagesPicker
        
        init(_ parent: SelectMultipleImagesPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            parent.shouldShowLoader = true
            loadImage(results: results, resultsIndex: 0)
        }
        
        func loadImage(results: [PHPickerResult], resultsIndex: Int) {
            guard results.indices.contains(resultsIndex) else {
                DispatchQueue.main.async { self.parent.shouldShowLoader = false }
                return
            }
            
            let provider = results[resultsIndex].itemProvider
            let nextResultsIndex = resultsIndex + 1
            
            guard provider.canLoadObject(ofClass: UIImage.self) else {
                loadImage(results: results, resultsIndex: nextResultsIndex)
                return
            }

            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    defer { self.loadImage(results: results, resultsIndex: nextResultsIndex) }
                    guard let image = image as? UIImage else { return }
                    self.parent.selectedImages.append(image)
                }
            }
        }
    }
}

