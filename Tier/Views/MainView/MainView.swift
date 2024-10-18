//
//  MainView.swift
//  Tier
//
//  Created by Denis Ravkin on 09.09.2024.
//

import SwiftUI

struct MainView<ViewModel: MainViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach($viewModel.tierLists, id: \.id) { tierList in
                    NavigationLink {
                        screenFactory.makeTierListView(tierListId: tierList.wrappedValue.id, tierListName: tierList.name)
                            .navigationTitle(tierList.wrappedValue.name)
                    } label: {
                        MainViewRow(text: tierList.wrappedValue.name, isSaving: tierList.wrappedValue.isSaving)
                            .addSwipeAction(edge: .trailing) {
                                getRemoveSwipeActionButton(tierListId: tierList.wrappedValue.id)
                            }
                    }
                }
                
                Button {
                    viewModel.createNewTierList()
                } label: {
                    Text(viewModel.tierLists.isEmpty ? "+ Create " : "+ New")
                        .padding(10)
                }
            }
            .navigationTitle("Tier lists")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            if viewModel.shouldShowLoader {
                LoadingView()
            }
        }
    }
    
    private func getRemoveSwipeActionButton(tierListId: String) -> some View {
        Button {
            withAnimation(.spring()) {
                viewModel.deleteTierList(tierListId)
            }
        } label: {
            Image(systemName: "trash")
                .foregroundColor(.white)
        }
        .frame(width: 70)
        .frame(maxHeight: .infinity)
        .background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.trailing)
    }
}
