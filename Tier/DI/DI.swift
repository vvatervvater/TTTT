//
//  DI.swift
//  Tier
//
//  Created by Denis Ravkin on 18.10.2024.
//

import Foundation
import SwiftUI

let screenFactory = ScreenFactory()

final class ScreenFactory {
    fileprivate let applicationFactory = ApplicationFactory()
    fileprivate init(){}
    
    func makeMainView() -> MainView<MainViewModelImpl> {
        return MainView(viewModel: applicationFactory.mainViewModel)
    }
    
    func makeTierListView(tierListId: String, tierListName: Binding<String>) -> TierListView<TierListViewModelImpl> {
        return TierListView(tierListName: tierListName,
                            viewModel: applicationFactory.tierListViewModel(tierListId: tierListId))
    }
    
    func makeConfigurableRootView() -> ConfigurableRootView {
        ConfigurableRootView(editTextPopupManager: applicationFactory.editTextPopupManager)
    }
}

final class ApplicationFactory {
    fileprivate let editTextPopupManager: EditTextPopupManager
    fileprivate let tierListsRepositoryImpl: TierListsRepositoryImpl
    fileprivate let storageService: StorageService
    
    fileprivate var mainViewModel: MainViewModelImpl {
        return .init(tierListsRepositoryImpl: tierListsRepositoryImpl,
                     editTextPopupManager: editTextPopupManager)
    }
    
    func tierListViewModel(tierListId: String) -> TierListViewModelImpl {
        return .init(tierListsRepositoryImpl: tierListsRepositoryImpl,
                     editTextPopupManager: editTextPopupManager,
                     tierListId: tierListId)
    }
    
    init() {
        editTextPopupManager = EditTextPopupManager()
        storageService = .init()
        tierListsRepositoryImpl = .init(storage: storageService)
    }
}
