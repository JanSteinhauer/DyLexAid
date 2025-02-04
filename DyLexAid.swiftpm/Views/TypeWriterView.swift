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
            
            // MARK: - Original Text Editor
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
                    viewModel.processText()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "wand.and.stars")
                        Text(viewModel.areTogglesVisible ? "Start" : "Simplify")
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
                        Text("Settings")
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

            // MARK: - Simplified Text Title
            HStack {
                Text("Simplified Version:")
                    .fontWeight(.semibold)
                    .padding(.leading, 5)
                Spacer()
            }

            // MARK: - Simplified Text + Copy & Speak Buttons
            ZStack(alignment: .topTrailing) {
                ScrollView {
                    Text(viewModel.simplifiedText)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .shadow(radius: 5)
                .frame(maxWidth: .infinity, minHeight: 180)
                .padding(.horizontal, 5)

                HStack(spacing: 8) {
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

                    Button(action: {
                        speechManager.speakText(viewModel.simplifiedText)
                    }) {
                        Image(systemName: "speaker.3")
                            .padding(10)
                            .background(Color.orange.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                }
                .font(.system(size: 20))
                .padding(.top, 17)
                .padding(.trailing, 15)
            }

            Spacer()
        }
        .padding()
    }
}
