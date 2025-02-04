//
//  TypewriteView.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 1/28/25.
//

import SwiftUI
import AVFoundation

struct TypeWriterView: View {
    @StateObject private var viewModel = TextProcessingViewModel()
    @StateObject private var speechManager = SpeechManager()
    
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        VStack(spacing: 20) {
            Text("DyLexAid - Text Simplification and Accessibility")
                .font(.system(size: 35, weight: .semibold))
                .padding(.top, 20)
            
            OriginalTextEditor(viewModel: viewModel)
            
            TogglesView(viewModel: viewModel)
            
            ActionButtons(viewModel: viewModel)
            
            SimplifiedTextView(viewModel: viewModel, speechManager: speechManager)
            
            Spacer()
        }
        .padding()
    }
}
