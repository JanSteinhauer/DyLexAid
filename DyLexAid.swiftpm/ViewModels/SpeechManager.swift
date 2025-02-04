//
//  SwiftUIView.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 2/3/25.
//

import Foundation
import AVFoundation

class SpeechManager: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()

    func speakText(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        
        if let englishVoice = AVSpeechSynthesisVoice(language: "en-US") {
            utterance.voice = englishVoice
        } else if let fallbackVoice = AVSpeechSynthesisVoice.speechVoices().first {
            utterance.voice = fallbackVoice
        }
        
        synthesizer.speak(utterance)
    }
}

