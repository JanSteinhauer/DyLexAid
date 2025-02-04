//
//  SwiftUIView.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 2/3/25.
//

import AVFoundation
import Combine
import SwiftUI

class SpeechManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    
    @Published var highlightedRange: NSRange? = nil
    
    private var currentText: String = ""
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func speakText(_ text: String) {
        highlightedRange = nil
        currentText = text
        
        let utterance = AVSpeechUtterance(string: text)
        
        if let englishVoice = AVSpeechSynthesisVoice(language: "en-US") {
            utterance.voice = englishVoice
        } else if let fallbackVoice = AVSpeechSynthesisVoice.speechVoices().first {
            utterance.voice = fallbackVoice
        }
        
        synthesizer.speak(utterance)
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           willSpeakRangeOfSpeechString characterRange: NSRange,
                           utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.highlightedRange = characterRange
        }
    }
}


