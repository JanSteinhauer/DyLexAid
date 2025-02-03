//
//  DocumentUploadView.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 1/28/25.
//

import SwiftUI
import PDFKit

struct DocumentUploadView: View {
    @State private var userText: String = ""
    @State private var simplifiedText: String = ""
    @State private var isLowercaseEnabled: Bool = false
    @State private var isReplaceDifficultWordsEnabled: Bool = false
    @State private var isSimplifySelected: Bool = true
    @State private var isSummarizeEnabled: Bool = false
    @State private var isFilePickerPresented: Bool = false
    @State private var areTogglesVisible: Bool = false

    private let simplifier = Simplifier()

    var body: some View {
        VStack(spacing: 20) {
            Text("DyLexAid - Text Simplification and Accessibility")
                .font(.custom("Arial", size: 24))
                .fontWeight(.semibold)
                .padding(.top, 20)

            Text("Upload your PDF below")
                .font(.custom("Arial", size: 18))
                .fontWeight(.semibold)

            // PDF Upload Area
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

            // Text Editor
            Text("Original Text:")
                .font(.custom("Arial", size: 16))
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)

            ZStack(alignment: .topTrailing) {
                TextEditor(text: $userText)
                    .font(.custom("Arial", size: 14))
                    .lineSpacing(1.5)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .frame(maxWidth: .infinity, minHeight: 200)

                Button(action: {
                    if let clipboardContent = UIPasteboard.general.string {
                        userText = clipboardContent
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

            if areTogglesVisible {
                HStack(spacing: 20) {
                    Spacer()

                    ToggleOption(title: "Lowercase", isEnabled: $isLowercaseEnabled)
                    ToggleOption(title: "Replace Words", isEnabled: $isReplaceDifficultWordsEnabled)
                    ToggleOption(title: "Summarize", isEnabled: $isSummarizeEnabled)

                    Spacer()
                }
            }

            HStack(spacing: 20) {
                Button(action: {
                    simplifiedText = simplifier.simplify(text: userText)
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "wand.and.stars")
                            .font(.headline)
                        Text(areTogglesVisible ? "Start" : "Simplify")
                            .font(.custom("Arial", size: 14))
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                }

                Button(action: {
                    areTogglesVisible.toggle()
                    processText()
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
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 10)

            Text("Simplified Version:")
                .font(.custom("Arial", size: 16))
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)

            ZStack(alignment: .topTrailing) {
                ScrollView {
                    Text(simplifiedText)
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
                    UIPasteboard.general.string = simplifiedText
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

    private func handleFileImport(result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            if let text = extractTextFromPDF(url: url) {
                userText = text
            }
        case .failure(let error):
            print("Failed to import file: \(error)")
        }
    }

    private func extractTextFromPDF(url: URL) -> String? {
        guard let document = PDFDocument(url: url) else { return nil }
        var extractedText = ""
        for pageIndex in 0..<document.pageCount {
            if let page = document.page(at: pageIndex), let pageContent = page.string {
                extractedText += pageContent
            }
        }
        return extractedText
    }

    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier("public.file-url") {
                provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { item, _ in
                    if let urlData = item as? Data, let url = URL(dataRepresentation: urlData, relativeTo: nil) {
                        if let text = extractTextFromPDF(url: url) {
                            DispatchQueue.main.async {
                                userText = text
                            }
                        }
                    }
                }
                return true
            }
        }
        return false
    }

    private func processText() {
        var text = userText
        if isLowercaseEnabled {
            text = text.lowercased()
        }
        if isReplaceDifficultWordsEnabled {
            // text = simplifier.replaceDifficultWords(text: text)
        }
        if isSummarizeEnabled {
            // text = simplifier.summarize(text: text)
        }
        simplifiedText = text
    }
}

struct ToggleOption: View {
    let title: String
    @Binding var isEnabled: Bool

    var body: some View {
        HStack(spacing: 10) {
            Text(title)
                .font(.custom("Arial", size: 14))
            Toggle("", isOn: $isEnabled)
                .labelsHidden()
        }
    }
}
