//
//  UIImage+Ext.swift
//  Tier
//
//  Created by Denis Ravkin on 09.09.2024.
//

import UIKit

extension UIImage {
    func compressImageIfNeeded(originalSizeInBytes: Int, maxSizeInBytes: Int) async -> UIImage? {
        guard let currentImageSize = self.jpegData(compressionQuality: 1.0)?.count else { return nil }
        if currentImageSize <= maxSizeInBytes {
            return self
        }
        return await compress(to: originalSizeInBytes)
    }
    
    func compress(to maxByte: Int) async -> UIImage? {
        let compressTask = Task(priority: .userInitiated) { () -> UIImage? in
            guard let currentImageSize = self.jpegData(compressionQuality: 1.0)?.count else { return nil }

            var iterationImage: UIImage? = self
            var iterationImageSize = currentImageSize
            var iterationCompression: CGFloat = 1.0
            
            while iterationImageSize > maxByte && iterationCompression > 0.01 {
                let percentageDecrease = getPercentageToDecreaseTo(forDataCount: iterationImageSize)
                let canvasSize = CGSize(width: size.width * iterationCompression, height: size.height * iterationCompression)
                
                UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
                defer { UIGraphicsEndImageContext() }
                draw(in: CGRect(origin: .zero, size: canvasSize))
                iterationImage = UIGraphicsGetImageFromCurrentImageContext()
                
                guard let newImageSize = iterationImage?.jpegData(compressionQuality: 1.0)?.count else {
                    return nil
                }
                iterationImageSize = newImageSize
                iterationCompression -= percentageDecrease
            }
            
            return iterationImage
        }
        return await compressTask.value
    }
    
    private func getPercentageToDecreaseTo(forDataCount dataCount: Int) -> CGFloat {
        switch dataCount {
        case 0..<3000000: return 0.05
        case 3000000..<10000000: return 0.1
        default: return 0.2
        }
    }
}
