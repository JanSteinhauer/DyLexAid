//
//  Summarizer.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 1/27/25.
//

import SwiftUI
import Foundation
import NaturalLanguage

// MARK: - Summarizer
class Summarizer {
    func summarize(text: String, numberOfSentences: Int = 2) -> String {
        let sentences = splitIntoSentences(text)
        guard !sentences.isEmpty else { return text }
        
        let sentenceScores = scoreSentences(sentences: sentences)
        
        let topSentences = sentenceScores
            .sorted { $0.score > $1.score }
            .prefix(numberOfSentences)
            .map { $0.sentence }
        
        let rewritten = topSentences.map { rewriteSentenceWithSynonyms($0) }
        
        return rewritten.joined(separator: " ")
    }
    
    // MARK: Helpers
    
    private func splitIntoSentences(_ text: String) -> [String] {
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        var sentences: [String] = []
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            let sentence = String(text[range]).trimmingCharacters(in: .whitespacesAndNewlines)
            if !sentence.isEmpty {
                sentences.append(sentence)
            }
            return true
        }
        return sentences
    }
    
    private func scoreSentences(sentences: [String]) -> [(sentence: String, score: Double)] {
        let allText = sentences.joined(separator: " ")
        let frequencyMap = buildFrequencyMap(text: allText)
        
        let overallEmbedding = averageEmbedding(for: allText)
        
        var results: [(String, Double)] = []
        
        for sentence in sentences {
            let freqScore = frequencyScore(sentence: sentence, frequencyMap: frequencyMap)
            let embeddingScore = semanticRelevanceScore(sentence: sentence, overallVector: overallEmbedding)
            
            let combined = freqScore * 0.7 + embeddingScore * 0.3
            results.append((sentence, combined))
        }
        
        return results
    }
    
    private func buildFrequencyMap(text: String) -> [String: Int] {
        var map: [String: Int] = [:]
        let words = tokenizeWords(text: text)
        for w in words {
            map[w, default: 0] += 1
        }
        return map
    }
    
    private func tokenizeWords(text: String) -> [String] {
        var words: [String] = []
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = text.lowercased()
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            let token = String(text[range]).lowercased()
            words.append(token)
            return true
        }
        return words
    }
    
    private func frequencyScore(sentence: String, frequencyMap: [String: Int]) -> Double {
        let words = tokenizeWords(text: sentence)
        let total = words.reduce(0) { $0 + Double(frequencyMap[$1] ?? 0) }
        return total / Double(words.count + 1)
    }
    
    private func semanticRelevanceScore(sentence: String, overallVector: [Double]) -> Double {
        guard !overallVector.isEmpty else { return 0.0 }
        
        let sentenceVector = averageEmbedding(for: sentence)
        guard !sentenceVector.isEmpty else { return 0.0 }
        
        return cosineSimilarity(vecA: sentenceVector, vecB: overallVector)
    }

    
    private func averageEmbedding(for text: String) -> [Double] {
        guard let embedding = NLEmbedding.wordEmbedding(for: .english) else { return [] }
        let words = tokenizeWords(text: text)
        
        var vectorSum: [Double] = []
        var count = 0
        
        for w in words {
            if let v = embedding.vector(for: w) {  // 'v' is [Double]
                if vectorSum.isEmpty {
                    vectorSum = v
                } else {
                    for i in 0..<vectorSum.count {
                        vectorSum[i] += v[i]
                    }
                }
                count += 1
            }
        }
        
        guard count > 0 else { return [] }
        for i in 0..<vectorSum.count {
            vectorSum[i] /= Double(count)
        }
        
        return vectorSum
    }

    
    private func cosineSimilarity(vecA: [Double], vecB: [Double]) -> Double {
        guard vecA.count == vecB.count, !vecA.isEmpty else { return 0.0 }
        
        var dot: Double = 0
        var magA: Double = 0
        var magB: Double = 0
        
        for i in 0..<vecA.count {
            dot += vecA[i] * vecB[i]
            magA += vecA[i] * vecA[i]
            magB += vecB[i] * vecB[i]
        }
        
        let denom = sqrt(magA) * sqrt(magB)
        guard denom != 0 else { return 0.0 }
        
        return dot / denom
    }

    
    private func rewriteSentenceWithSynonyms(_ sentence: String) -> String {
        guard let embedding = NLEmbedding.wordEmbedding(for: .english) else {
            return sentence
        }
        
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = sentence
        var rewrittenWords: [String] = []
        
        tokenizer.enumerateTokens(in: sentence.startIndex..<sentence.endIndex) { range, _ in
            let word = String(sentence[range])
            
            if word.count > 5, let vector = embedding.vector(for: word.lowercased()) {
                let synonyms = embedding.neighbors(for: vector, maximumCount: 3)

                if !synonyms.isEmpty {
              
                    if let alt = synonyms.first(where: { $0.0.lowercased() != word.lowercased() }) {
                        let replacement = matchCase(original: word, replacement: alt.0)
                        rewrittenWords.append(replacement)
                    } else {
                        rewrittenWords.append(word)
                    }
                } else {
                    rewrittenWords.append(word)
                }
            } else {
                rewrittenWords.append(word)
            }
            return true
        }
        
        return rewrittenWords.joined(separator: " ")
    }
    
    private func matchCase(original: String, replacement: String) -> String {
        if original.first?.isUppercase == true {
            return replacement.capitalized
        } else {
            return replacement
        }
    }
}



