//
//  TogglesView.swift
//
//
//  Created by Steinhauer, Jan on 2/4/25.
//

import SwiftUI

struct TogglesView: View {
    @ObservedObject var viewModel: TextProcessingViewModel
    
    var body: some View {
        if viewModel.areTogglesVisible {
            HStack(spacing: 20) {
                Spacer()
                ToggleOption(title: "Lowercase", isEnabled: $viewModel.isLowercaseEnabled)
                ToggleOption(title: "Replace Words", isEnabled: $viewModel.isReplaceDifficultWordsEnabled)
                ToggleOption(title: "Summarize", isEnabled: $viewModel.isSummarizeEnabled)
                Spacer()
            }
        }
    }
}
