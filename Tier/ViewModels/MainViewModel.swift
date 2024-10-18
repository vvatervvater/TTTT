//
//  MainViewModel.swift
//  Tier
//
//  Created by Denis Ravkin on 09.09.2024.
//

import Foundation
import RealmSwift

protocol MainViewModel: BaseViewModel {
    func getTierListsBasicInfo()
    func deleteTierList(_ tierListId: String)
    func createNewTierList()
    var tierLists: [TierListBasicInfo] { get set }
}

class MainViewModelImpl: BaseViewModel, MainViewModel {
    private let editTextPopupManager: EditTextPopupManager
    private let tierListsRepositoryImpl: TierListsRepositoryImpl
    @Published var tierLists: [TierListBasicInfo] = [] {
        didSet {
            shouldShowLoader = false
        }
    }
    
    init(tierListsRepositoryImpl: TierListsRepositoryImpl, editTextPopupManager: EditTextPopupManager) {
        self.tierListsRepositoryImpl = tierListsRepositoryImpl
        self.editTextPopupManager = editTextPopupManager
        super.init()
        getTierListsBasicInfo()
        observeNotifications()
    }
    
    func getTierListsBasicInfo() {
        shouldShowLoader = true
        tierLists = tierListsRepositoryImpl.getTierListsBasicInfo()
    }
    
    func deleteTierList(_ tierListId: String) {
        tierLists.removeAll { $0.id == tierListId }
        tierListsRepositoryImpl.deleteTierList(tierListId)
    }
    
    func createNewTierList() {
        editTextPopupManager.showPopup(editedText: "") { [self] savedText in
            let newTierList = TierListBasicInfo(id: UUID().uuidString, name: savedText)
            tierLists.append(newTierList)
            tierListsRepositoryImpl.saveTierList(.init(id: newTierList.id, name: newTierList.name, sections: []))
        }
    }
    
    private func observeNotifications() {
        NotificationCenter.observeTierListSavingNotification { [weak self] (tierListId, isSaving) in
            guard let index = self?.tierLists.firstIndex(where: { $0.id == tierListId }) else { return }
            self?.tierLists[index].isSaving = isSaving
        }
    }
}
