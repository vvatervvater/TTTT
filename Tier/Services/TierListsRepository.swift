//
//  TierListsRepository.swift
//  Tier
//
//  Created by Denis Ravkin on 13.09.2024.
//

import Foundation
import RealmSwift

protocol TierListsRepository {
    func getTierListsBasicInfo() -> [TierListBasicInfo]
    func getTierList(id: String, completion: @escaping (TierListObject) -> Void)
    func saveTierList(_ data: TierList)
    func deleteTierList(_ id: String)
}

final class TierListsRepositoryImpl: TierListsRepository {
    private let storage: StorageService
    
    init(storage: StorageService) {
        self.storage = storage
    }
    
    func getTierListsBasicInfo() -> [TierListBasicInfo] {
        let data = storage.fetch(by: TierListObject.self)
        return data.map { .init(id: $0.id, name: $0.name) }
    }
    
    func getTierList(id: String, completion: @escaping (TierListObject) -> Void) {
        storage.fetchAsync(by: TierListObject.self, key: id, completion: completion)
    }
    
    func saveTierList(_ data: TierList) {
        let object = mapTierListObject(tierList: data)
        try? storage.saveOrUpdateObject(object: object, completion: {
            NotificationCenter.postTierListSavingNotification(tierListId: data.id, saving: false)
        })
    }
    
    func deleteTierList(_ id: String) {
        do {
            try storage.delete(of: TierListObject.self, forPrimaryKey: id, cascanding: true)
        } catch {
            print(error)
        }
    }
}

// MARK: Mapping
extension TierListsRepositoryImpl {
    private func mapTierListObject(tierList: TierList) -> TierListObject {
        let sectionObjects = tierList.sections.map {
            let dataList = List<Data>()
            dataList.append(objectsIn: $0.images.map { $0.image.jpegData(compressionQuality: 0.5) ?? $0.image.pngData() ?? Data() })
            return SectionObject.init(id: $0.id, name: $0.name, images: dataList, color: $0.color.toHex() ?? "")
        }
        let sectionObjectsList = List<SectionObject>()
        sectionObjectsList.append(objectsIn: sectionObjects)
        return TierListObject(id: tierList.id, sections: sectionObjectsList, name: tierList.name)
    }
}
