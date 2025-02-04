//
//  OriginalTextEditor.swift
//
//
//  Created by Steinhauer, Jan on 2/4/25.
//

import SwiftUI


struct OriginalTextEditor: View {
    @ObservedObject var viewModel: TextProcessingViewModel
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            TextEditor(text: $viewModel.userText)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .shadow(radius: 5)
                .frame(maxWidth: .infinity, minHeight: 200)
            
            Button(action: {
                if let clipboardContent = UIPasteboard.general.string {
                    viewModel.userText = clipboardContent
                }
            }) {
                Image(systemName: "doc.on.clipboard")
                    .padding(10)
                    .background(Color.blue.opacity(0.7))
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .font(.system(size: 20))
            }
            .padding(10)
        }
    }
}
