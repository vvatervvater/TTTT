//
//  TierList.swift
//  Tier
//
//  Created by Denis Ravkin on 09.09.2024.
//

import Foundation

struct TierList {
    let id: String
    var name: String
    var sections: [Section]
}

extension TierList {
    init(object: TierListObject) {
        id = object.id
        name = object.name
        sections = []
        for section in object.sections {
            sections.append(.init(object: section))
        }
    }
}
