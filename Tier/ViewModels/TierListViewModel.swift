//
//  TierListViewModel.swift
//  Tier
//
//  Created by Denis Ravkin on 14.10.2024.
//

import Foundation
import SwiftUI
import RealmSwift

protocol TierListViewModel: BaseViewModel {
    var tierList: TierList { get set }
    func getTierList()
    func saveTierList()
    func createNewSection()
    func editTierListName(tierListName: Binding<String>)
    func editSectionName(sectionName: Binding<String>)
}

class TierListViewModelImpl: BaseViewModel, TierListViewModel {
    private let editTextPopupManager: EditTextPopupManager
    private let tierListsRepositoryImpl: TierListsRepositoryImpl
    private let tierListId: String
    @Published var tierList: TierList = .init(id: "", name: "", sections: [])
    
    init(tierListsRepositoryImpl: TierListsRepositoryImpl, editTextPopupManager: EditTextPopupManager, tierListId: String) {
        self.editTextPopupManager = editTextPopupManager
        self.tierListsRepositoryImpl = tierListsRepositoryImpl
        self.tierListId = tierListId
    }
    
    func getTierList() {
        shouldShowLoader = true
        tierListsRepositoryImpl.getTierList(id: tierListId) { object in
            let tierList = TierList(object: object)
            DispatchQueue.main.async {
                self.tierList = tierList
                self.shouldShowLoader = false
            }
        }
    }
    
    func saveTierList() {
        NotificationCenter.postTierListSavingNotification(tierListId: tierList.id, saving: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [self] in
            tierListsRepositoryImpl.saveTierList(tierList)
        }
    }
    
    func createNewSection() {
        editTextPopupManager.showPopup(editedText: "") { [self] savedText in
            tierList.sections.append(.init(name: savedText, images: []))
        }
    }
    
    func editTierListName(tierListName: Binding<String>) {
        editTextPopupManager.showPopup(editedText: tierList.name) { [self] savedText in
            tierList.name = savedText
            tierListName.wrappedValue = savedText
        }
    }
    
    func editSectionName(sectionName: Binding<String>) {
        editTextPopupManager.showPopup(editedText: sectionName.wrappedValue) { savedText in
            sectionName.wrappedValue = savedText
        }
    }
}
