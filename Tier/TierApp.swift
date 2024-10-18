//
//  TierApp.swift
//  Tier
//
//  Created by Denis Ravkin on 09.09.2024.
//

import SwiftUI

@main
struct TierApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                screenFactory.makeMainView()
                screenFactory.makeConfigurableRootView()
            }
        }
    }
}

struct ConfigurableRootView: View {
    @ObservedObject var editTextPopupManager: EditTextPopupManager
    
    var body: some View {
        Color.clear
            .overlay { editTextPopupView }
    }
    
    @ViewBuilder
    var editTextPopupView: some View {
        if editTextPopupManager.show {
            EditTextPopupView(editTextPopupManager: editTextPopupManager)
        }
    }
}
