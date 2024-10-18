//
//  Section.swift
//  Tier
//
//  Created by Denis Ravkin on 09.09.2024.
//

import UIKit
import SwiftUI

struct Section: Equatable {
    var id = UUID().uuidString
    var color = Color.random()
    var name: String
    var images: [IdentifiableImage]
}

struct IdentifiableImage: Identifiable, Equatable {
    let id = UUID()
    var image: UIImage
}

extension Section {
    init(object: SectionObject) {
        id = object.id
        color = .init(hex: object.color) ?? .random()
        name = object.name
        images = []
        for image in object.images {
            images.append(.init(image: UIImage(data: image) ?? UIImage()))
        }
    }
}
