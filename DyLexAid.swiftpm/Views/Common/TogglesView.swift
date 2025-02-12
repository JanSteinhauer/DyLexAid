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
            GeometryReader { geometry in
                let isCompact = geometry.size.width < 600
                if isCompact {
                   
                    HStack{
                        VStack(alignment: .leading, spacing: 10) {
                            HStack{
                                ToggleOption(title: "Simplify", isEnabled: $viewModel.isSimplifySelected)
                                ToggleOption(title: "Lowercase", isEnabled: $viewModel.isLowercaseEnabled)
                            }
                            ToggleOption(title: "Replace Words", isEnabled: $viewModel.isReplaceDifficultWordsEnabled)
                        }
                        Spacer()
                    }
                    .padding(.leading)
                  
                    .frame(maxWidth: .infinity)
                } else {
                    // Use horizontal layout when there's enough space
                    HStack(spacing: 20) {
                        ToggleOption(title: "Simplify", isEnabled: $viewModel.isSimplifySelected)
                        ToggleOption(title: "Lowercase", isEnabled: $viewModel.isLowercaseEnabled)
                        ToggleOption(title: "Replace Words", isEnabled: $viewModel.isReplaceDifficultWordsEnabled)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 50) // Ensures the view does not collapse
        }
    }
}
