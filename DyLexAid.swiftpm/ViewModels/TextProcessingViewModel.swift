//
//  SwiftUIView.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 2/3/25.
//

import Foundation
import SwiftUI

class TextProcessingViewModel: ObservableObject {
    @Published var userText: String = "Type here..."
    @Published var simplifiedText: String = ""
    @Published var isSimplifySelected: Bool = true
    @Published var isLowercaseEnabled: Bool = true
    @Published var isReplaceDifficultWordsEnabled: Bool = true
    @Published var isLongSentenceSplittingActive: Bool = false
    @Published var areTogglesVisible: Bool = false

    private let simplifier = Simplifier()
    
    func processText() {
        
        var output = userText
        
        
        if isSimplifySelected {
            output = simplifier.simplify(text: output)
        }
        
        if isLowercaseEnabled {
            output = output.lowercased()
        }
        if isReplaceDifficultWordsEnabled {
            output = output
                .split(separator: " ")
                .map { word in simplifier.dictionaryReplacement(for: String(word)) ?? String(word) }
                .joined(separator: " ")
        }
        
        if isLongSentenceSplittingActive {
            output = simplifier.splitSentences(text: output)
        }
        
        simplifiedText = output
    }
}

