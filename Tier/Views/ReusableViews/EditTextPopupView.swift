//
//  EditTextPopupView.swift
//  Tier
//
//  Created by Denis Ravkin on 12.09.2024.
//

import SwiftUI

struct EditTextPopupView: View {
    @ObservedObject var editTextPopupManager: EditTextPopupManager
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 0) {
                BaseTextFieldView(value: $editTextPopupManager.editedText, title: nil)
                    .focused($isFocused)
                    .padding(.vertical)
                
                HStack(spacing: 16) {
                    BaseButtonView(text: "Cancel") {
                        isFocused = false
                        editTextPopupManager.cancel()
                    }
                    
                    BaseButtonView(text: "Save") {
                        isFocused = false
                        editTextPopupManager.save()
                    }
                }
                .padding(.bottom)
            }
            .padding(.horizontal)
            .background(.white)
            .cornerRadius(10)
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .background(VStack { }
            .frame(width: UIScreen.width, height: UIScreen.height * 2)
            .background(.black.opacity(0.4))
            .ignoresSafeArea()
        )
        .onAppear {
            isFocused = true
        }
    }
}
