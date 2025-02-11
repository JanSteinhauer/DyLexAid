//
//  TypewriteView.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 1/28/25.
//

import SwiftUI
import AVFoundation

struct TypeWriterView: View {
    @StateObject private var speechManager = SpeechManager()
    
    @EnvironmentObject var viewModel: TextProcessingViewModel
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    Text("Text Simplification and Accessibility")
                        .font(.system(size: CGFloat(settings.fontSize + 15)))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                    
                    OriginalTextEditor(viewModel: viewModel)
                        .frame(height: geometry.size.height / 2.7)
                    
                    TogglesView(viewModel: viewModel)
                    
                    ActionButtons(viewModel: viewModel)
                    
                    SimplifiedTextView(viewModel: viewModel, speechManager: speechManager)
                    
                    Spacer()
                }
                .padding()
                .frame(width: geometry.size.width, height: geometry.size.height)
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
           
        }
      
    }
}
