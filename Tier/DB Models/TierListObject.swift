//
//  TierListObject.swift
//  Tier
//
//  Created by Denis Ravkin on 13.09.2024.
//

import RealmSwift

final class TierListObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var sections: RealmSwift.List<SectionObject>
    
    convenience init(id: String, sections: List<SectionObject>, name: String) {
        self.init()
        self.id = id
        self.sections = sections
        self.name = name
    }
}
