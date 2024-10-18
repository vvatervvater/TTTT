//
//  BaseTextFieldView.swift
//  Tier
//
//  Created by Denis Ravkin on 12.09.2024.
//

import SwiftUI

struct BaseTextFieldView: View {
    @Binding var value: String
    let title: String?
    var foregroundColor = Color.blue.opacity(0.7)
    
    var body: some View {
        VStack(alignment: .leading) {
            if let title = title {
                Text(title)
            }
            
            TextField("T_T", text: $value)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .foregroundColor(foregroundColor)
                .overlay(borderView)
        }
        .font(.system(size: 16))
        .foregroundColor(Color.black)
    }
    
    private var borderView: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(foregroundColor, lineWidth: 1)
    }
}
