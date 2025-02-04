//
//  DocumentUploadView.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 1/28/25.
//

import SwiftUI
import PDFKit

struct DocumentUploadView: View {
    @StateObject private var viewModel = TextProcessingViewModel()
    @State private var isFilePickerPresented: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("DyLexAid - Text Simplification and Accessibility")
                .font(.custom("Arial", size: 24))
                .fontWeight(.semibold)
                .padding(.top, 20)

            Text("Upload your PDF below")
                .font(.custom("Arial", size: 18))
                .fontWeight(.semibold)

            // MARK: - PDF Upload Area
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.systemGray6))
                    .frame(maxWidth: .infinity, minHeight: 150)
                    .overlay(
                        VStack {
                            Image(systemName: "doc.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("Drag and drop your PDF here or tap to upload")
                                .font(.custom("Arial", size: 14))
                                .foregroundColor(.gray)
                        }
                    )
                    .onTapGesture {
                        isFilePickerPresented = true
                    }
                    .onDrop(of: [.fileURL], isTargeted: nil) { providers in
                        handleDrop(providers: providers)
                    }
            }
            .padding()

            // MARK: - Original Text
            Text("Original Text:")
                .font(.custom("Arial", size: 16))
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)

            // MARK: - Text Editor with "Paste from Clipboard"
            ZStack(alignment: .topTrailing) {
                TextEditor(text: $viewModel.userText)
                    .font(.custom("Arial", size: 14))
                    .lineSpacing(1.5)
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
                }
                .padding(10)
            }

            // MARK: - Toggles
            if viewModel.areTogglesVisible {
                HStack(spacing: 20) {
                    Spacer()
                    ToggleOption(title: "Lowercase", isEnabled: $viewModel.isLowercaseEnabled)
                    ToggleOption(title: "Replace Words", isEnabled: $viewModel.isReplaceDifficultWordsEnabled)
                    ToggleOption(title: "Summarize", isEnabled: $viewModel.isSummarizeEnabled)
                    Spacer()
                }
            }

            // MARK: - Action Buttons
            HStack(spacing: 20) {
                Button(action: {
                    // We call processText to create simplifiedText
                    viewModel.processText()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "wand.and.stars")
                            .font(.headline)
                        Text(viewModel.areTogglesVisible ? "Start" : "Simplify")
                            .font(.custom("Arial", size: 14))
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                }

                Button(action: {
                    viewModel.areTogglesVisible.toggle()
                    viewModel.processText()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "gear")
                            .font(.headline)
                        Text("Settings")
                            .font(.custom("Arial", size: 14))
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 10)

            // MARK: - Simplified Version
            Text("Simplified Version:")
                .font(.custom("Arial", size: 16))
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)

            ZStack(alignment: .topTrailing) {
                ScrollView {
                    Text(viewModel.simplifiedText)
                        .font(.custom("Arial", size: 14))
                        .lineSpacing(1.5)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .shadow(radius: 5)
                .frame(maxWidth: .infinity, minHeight: 180)
                .padding(.horizontal, 5)

                Button(action: {
                    UIPasteboard.general.string = viewModel.simplifiedText
                }) {
                    Image(systemName: "doc.on.doc")
                        .padding(10)
                        .background(Color.green.opacity(0.7))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding(15)
            }

            Spacer()
        }
        .padding()
        .fileImporter(isPresented: $isFilePickerPresented, allowedContentTypes: [.pdf]) { result in
            handleFileImport(result: result)
        }
    }

    // MARK: - PDF Handling
    private func handleFileImport(result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            if let text = PDFExtractor.extractText(from: url) {
                viewModel.userText = text
            }
        case .failure(let error):
            print("Failed to import file: \(error)")
        }
    }

    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier("public.file-url") {
                provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { item, _ in
                    if let urlData = item as? Data,
                       let url = URL(dataRepresentation: urlData, relativeTo: nil),
                       let text = PDFExtractor.extractText(from: url) {
                        
                        DispatchQueue.main.async {
                            viewModel.userText = text
                        }
                    }
                }
                return true
            }
        }
        return false
    }
}
