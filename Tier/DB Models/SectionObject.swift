//
//  SectionObject.swift
//  Tier
//
//  Created by Denis Ravkin on 13.09.2024.
//

import RealmSwift
import UIKit
import SwiftUI

final class SectionObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var images: RealmSwift.List<Data>
    @Persisted var color: String
    
    convenience init(id: String, name: String, images: RealmSwift.List<Data>, color: String) {
        self.init()
        self.id = id
        self.name = name
        self.images = images
        self.color = color
    }
}
