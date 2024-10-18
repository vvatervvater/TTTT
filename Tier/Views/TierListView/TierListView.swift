//
//  TierListView.swift
//  Tier
//
//  Created by Denis Ravkin on 09.09.2024.
//

import SwiftUI

struct TierListView<ViewModel: TierListViewModel>: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var viewModel: ViewModel
    @State private var selectedSection: Section?
    @Binding private var tierListName: String
    
    init(tierListName: Binding<String>, viewModel: ViewModel) {
        self._tierListName = tierListName
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                scrollContent(hideSomeUIForScreenshot: false)
                NewSectionView(onTap: viewModel.createNewSection)
            }
        }
        .toolbar {
            editTierListNameButton
            shareTierListButton
        }
        .overlay(alignment: .center, content: {
            if viewModel.shouldShowLoader {
                LoadingView()
            }
        })
        .onAppear {
            viewModel.getTierList()
        }
        .onDisappear {
            viewModel.saveTierList()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                viewModel.saveTierList()
            }
        }
    }
    
    private var editTierListNameButton: some View {
        Button {
            viewModel.editTierListName(tierListName: $tierListName)
        } label: {
            Image(systemName: "pencil")
        }
    }
    
    private var shareTierListButton: some View {
        Button {
            shareImage()
        } label: {
            Image(systemName: "square.and.arrow.up")
        }
    }
    
    private func scrollContent(hideSomeUIForScreenshot: Bool) -> some View {
        VStack(spacing: 0) {
            ForEach($viewModel.tierList.sections, id: \.id) { section in
                SectionView(section: section, selectedSection: $selectedSection, sections: $viewModel.tierList.sections, hideSomeUIForScreenshot: hideSomeUIForScreenshot, editSectionName: viewModel.editSectionName)
                    .onTapGesture {
                        selectedSection = section.wrappedValue
                    }
                    .overlay(alignment: .bottomLeading) {
                        if selectedSection?.id == section.wrappedValue.id {
                            ColorPicker("", selection: section.color)
                                .padding(.bottom, 2)
                                .padding(.leading, 2)
                                .labelsHidden()
                        }
                    }
            }
        }
    }
    
    private func shareImage() {
        guard let screenshotImage = scrollContent(hideSomeUIForScreenshot: true).snapshot() else { return }
        let activityController = UIActivityViewController(
            activityItems: [screenshotImage], applicationActivities: nil)
        let vc = UIApplication.shared.keyWindow?.rootViewController
        vc?.present(activityController, animated: true)
    }
}
