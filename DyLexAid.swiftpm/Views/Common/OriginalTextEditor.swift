//
//  OriginalTextEditor.swift
//
//
//  Created by Steinhauer, Jan on 2/4/25.
//

import SwiftUI
import PDFKit

struct OriginalTextEditor: View {
    @ObservedObject var viewModel: TextProcessingViewModel
    @State private var isShowingDocumentPicker = false
    @State private var isPickerLoading = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            TextEditor(text: $viewModel.userText)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .shadow(radius: 5)
                .frame(maxWidth: .infinity, minHeight: 200)
            
            HStack(spacing: 8) {
                Button(action: {
                    if let clipboardContent = UIPasteboard.general.string {
                        viewModel.userText = clipboardContent
                    }
                }) {
                    Image(systemName: "doc.on.clipboard")
                        .padding(10)
                        .background(Color.green.opacity(0.7))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                
                Button(action: {
                    isPickerLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isShowingDocumentPicker = true
                        isPickerLoading = false
                    }
                }) {
                    if isPickerLoading {
                        ProgressView()
                            .padding(10)
                            .background(Color.orange.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    } else {
                        Image(systemName: "arrow.up.doc")
                            .padding(10)
                            .background(Color.orange.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                }
            }
            .font(.system(size: 20))
            .padding(.top, 17)
            .padding(.trailing, 15)
        }
        .sheet(isPresented: $isShowingDocumentPicker) {
            DocumentPicker { url in
                if let text = PDFExtractor.extractText(from: url) {
                    viewModel.userText = text
                }
            }
        }
    }
}
