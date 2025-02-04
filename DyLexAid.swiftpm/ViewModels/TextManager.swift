//
//  TextManager.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 1/27/25.
//

struct TextManager {
    let summarizer = Summarizer()
    let simplifier = Simplifier()
    
    func getSummary(for text: String) -> String {
        summarizer.summarize(text: text)
    }
    
    func getSimplifiedText(for text: String) -> String {
        simplifier.simplify(text: text)
    }
}

