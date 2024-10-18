//
//  EditTextPopupManager.swift
//  Tier
//
//  Created by Denis Ravkin on 12.09.2024.
//

import SwiftUI

class EditTextPopupManager: ObservableObject {    
    @Published var show = false
    var editedText: String = ""
    private var saveCompletion: (String) -> Void = { _ in }
                                            
    func showPopup(editedText: String, saveCompletion: @escaping (String) -> Void) {
        self.editedText = editedText
        self.saveCompletion = saveCompletion
        show = true
    }
    
    func cancel() {
        withAnimation {
            show = false
        }
    }
    
    func save() {
        saveCompletion(editedText)
        withAnimation {
            show = false
        }
    }
}
