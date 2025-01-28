//
//  TypewriteView.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 1/28/25.
//

import SwiftUI

struct TypeWriterView: View {
    @State private var userText: String = "Type here..."
    @State private var simplifiedText: String = ""
    @State private var isSimplifySelected: Bool = true
    @State private var isLowercaseEnabled: Bool = false
    @State private var isReplaceDifficultWordsEnabled: Bool = false
    @State private var isSummarizeEnabled: Bool = false
    @State private var areTogglesVisible: Bool = false

    private let simplifier = Simplifier()

    var body: some View {
        VStack(spacing: 20) {
            Text("DyLexAid - Text Simplification and Accessibility")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.top, 20)

            ZStack(alignment: .topTrailing) {
                TextEditor(text: $userText)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .font(.body)

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
                    
                    HStack(spacing: 10) {
                        Text("Lowercase")
                            .font(.body)
                        Toggle("", isOn: $isLowercaseEnabled)
                            .labelsHidden()
                    }

                    HStack(spacing: 10) {
                        Text("Replace Words")
                            .font(.body)
                        Toggle("", isOn: $isReplaceDifficultWordsEnabled)
                            .labelsHidden()
                    }

                    HStack(spacing: 10) {
                        Text("Summarize")
                            .font(.body)
                        Toggle("", isOn: $isSummarizeEnabled)
                            .labelsHidden()
                    }

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
                    if isSimplifySelected {
                        simplifiedText = simplifier.simplify(text: userText)
                    }
                    if isLowercaseEnabled {
                        simplifiedText = simplifiedText.lowercased()
                    }
                    if isReplaceDifficultWordsEnabled {
                        // TODO: Implement replaceDifficultWords
                        // simplifiedText = simplifier.replaceDifficultWords(text: simplifiedText)
                    }
                    if isSummarizeEnabled {
                        // TODO: add the func to just summarize
                        // simplifiedText = simplifier.summarize(text: simplifiedText)
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "gear")
                            .font(.headline)
                        Text("Settings")
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

            HStack{
                Text("Simplified Version:")
                    .fontWeight(.semibold)
                    .padding(.leading, 5)
                Spacer()
            }
 

            ZStack(alignment: .topTrailing) {
                ScrollView {
                    Text(simplifiedText)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
