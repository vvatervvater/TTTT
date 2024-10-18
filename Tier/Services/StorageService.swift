//
//  StorageService.swift
//  Tier
//
//  Created by Denis Ravkin on 13.09.2024.
//

import Foundation
import RealmSwift
import Realm

final class StorageService {
    let storage: Realm?
    
    init(_ configuration: Realm.Configuration = Realm.Configuration()) {
        self.storage = try? Realm(configuration: configuration)
    }
    
    func saveOrUpdateObject(object: Object, completion: (() -> Void)? = nil) throws {
        guard let storage else { return }
        storage.writeAsync {
            storage.add(object, update: .all)
            completion?()
        }
    }
    
    func saveOrUpdateAllObjects(objects: [Object]) throws {
        try objects.forEach {
            try saveOrUpdateObject(object: $0)
        }
    }
    
    func delete(object: Object, cascanding: Bool) throws {
        guard let storage else { return }
        try storage.write {
            storage.delete(object, cascading: cascanding)
        }
    }
    
    func delete<T: Object>(of type: T.Type, forPrimaryKey: String, cascanding: Bool) throws {
        if let object = storage?.object(ofType: type.self, forPrimaryKey: forPrimaryKey) {
            try delete(object: object, cascanding: cascanding)
        }
    }
    
    func deleteAll() throws {
        guard let storage else { return }
        try storage.write {
            storage.deleteAll()
        }
    }
    
    func fetch<T: Object>(by type: T.Type) -> [T] {
        guard let storage else { return [] }
        return storage.objects(T.self).toArray()
    }
    
    func fetch<T: Object, KeyType>(by type: T.Type, key: KeyType) -> T? {
        guard let storage else { return nil }
        return storage.object(ofType: T.self, forPrimaryKey: key)
    }
    
    func fetchAsync<T: Object, KeyType>(by type: T.Type, key: KeyType, completion: @escaping (T) -> Void) {
        DispatchQueue.global().async {
            do {
                let realm = try Realm()
                guard let object = realm.object(ofType: T.self, forPrimaryKey: key) else { return }
                completion(object)
            } catch {
                print("Realm error: \(error)")
            }
        }
    }
}

// MARK: CascadeDeleting
extension Realm {
    func delete<Entity: Object>(_ entity: Entity, cascading: Bool) {
        if cascading {
            cascadeDelete(entity)
        } else {
            delete(entity)
        }
    }
    
    private func cascadeDelete(_ entity: RLMObjectBase) {
        guard let entity = entity as? Object else { return }
        var toBeDeleted = Set<RLMObjectBase>()
        toBeDeleted.insert(entity)
        while !toBeDeleted.isEmpty {
            guard let element = toBeDeleted.removeFirst() as? Object,
                  !element.isInvalidated else { continue }
            resolve(element: element, toBeDeleted: &toBeDeleted)
        }
    }
    
    private func resolve(element: Object, toBeDeleted: inout Set<RLMObjectBase>) {
        element.objectSchema.properties.forEach {
            guard let value = element.value(forKey: $0.name) else { return }
            if let entity = value as? RLMObjectBase {
                toBeDeleted.insert(entity)
            } else if let list = value as? RLMSwiftCollectionBase {
                for index in 0..<list._rlmCollection.count {
                    if let entity = list._rlmCollection.object(at: index) as? RLMObjectBase {
                        toBeDeleted.insert(entity)
                    }
                }
            }
        }
        delete(element)
    }
}

extension Results {
    func toArray() -> [Element] {
        .init(self)
    }
}
