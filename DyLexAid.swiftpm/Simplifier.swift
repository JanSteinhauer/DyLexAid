//
//  Simplifier.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 1/27/25.
//

import Foundation
import NaturalLanguage


class Simplifier {
    
    private let customReplacements = CustomReplacements.replacements
    private let meaningThreshold: NLDistance = 0.35
    private let minWordLengthForSynonym = 7
    private let maxWordsPerChunk = 12
    
    private let allowedSimpleWords: Set<String> = []
    
    func simplify(text: String) -> String {
        let sentences = splitIntoSentences(text)
        
        let shorterSentences = sentences.flatMap { splitLongSentence($0, maxWords: maxWordsPerChunk) }
        
        let simplifiedChunks = shorterSentences.map { rewriteSentence($0) }
        
        return simplifiedChunks.joined(separator: ". ")
    }
    
    // MARK: - Sentence Splitting
    
    private func splitIntoSentences(_ text: String) -> [String] {
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        
        var sentences: [String] = []
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            let sentence = text[range].trimmingCharacters(in: .whitespacesAndNewlines)
            if !sentence.isEmpty {
                sentences.append(sentence)
            }
            return true
        }
        return sentences
    }
    
    private func splitLongSentence(_ sentence: String, maxWords: Int) -> [String] {
        let words = tokenizeWords(sentence)
        guard words.count > maxWords else { return [sentence] }
        
        var result: [String] = []
        var currentChunk: [String] = []
        
        for word in words {
            currentChunk.append(word)
            if currentChunk.count >= maxWords {
                result.append(currentChunk.joined(separator: " "))
                currentChunk.removeAll()
            }
        }
        
        if !currentChunk.isEmpty {
            result.append(currentChunk.joined(separator: " "))
        }
        
        return result
    }
    
    // MARK: - Sentence Rewriting
    private func rewriteSentence(_ sentence: String) -> String {
        guard let embedding = NLEmbedding.wordEmbedding(for: .english) else {
            return doDictionaryReplacements(in: sentence)
        }
        
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = sentence
        
        var rewrittenWords: [String] = []
        tokenizer.enumerateTokens(in: sentence.startIndex..<sentence.endIndex) { range, _ in
            let originalWord = String(sentence[range])
            
            if let directReplacement = dictionaryReplacement(for: originalWord) {
                rewrittenWords.append(directReplacement)
            }
            else {
                if let simpler = findSimplerSynonym(originalWord, embedding: embedding) {
                    rewrittenWords.append(simpler)
                } else {
                    rewrittenWords.append(originalWord)
                }
            }
            return true
        }
        
        return rewrittenWords.joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: - Dictionary Replacement
    
    /// Looks up `originalWord` in our `customReplacements` (case-insensitive).
    /// If found, returns a match-cased version. Otherwise, nil.
    private func dictionaryReplacement(for originalWord: String) -> String? {
        let lower = originalWord.lowercased()
        guard let replacement = customReplacements[lower] else {
            return nil
        }
        return matchCase(original: originalWord, replacement: replacement)
    }
    
    // MARK: - Embedding-based Synonyms
    private func findSimplerSynonym(_ original: String, embedding: NLEmbedding) -> String? {
        let lower = original.lowercased()
        
        guard isAlphabetic(lower),
              lower.count >= minWordLengthForSynonym,
              let vector = embedding.vector(for: lower)
        else {
            return nil
        }
        
        // Up to 30 neighbors, sorted by ascending distance
        let candidates = embedding.neighbors(for: vector, maximumCount: 30)
        
        // Filter out synonyms that don't meet our criteria
        let filtered = candidates.filter { (synonym, distance) in
            let synLower = synonym.lowercased()
            return synLower != lower
                && distance < meaningThreshold
                && isAlphabetic(synLower)
                && (allowedSimpleWords.isEmpty || allowedSimpleWords.contains(synLower))
                && synLower.count <= lower.count
        }
        
        // Pick the first (closest meaning)
        guard let bestMatch = filtered.first else { return nil }
        
        return matchCase(original: original, replacement: bestMatch.0)
    }
    
    // MARK: - Helpers
    
    private func doDictionaryReplacements(in sentence: String) -> String {
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = sentence
        
        var replacedWords: [String] = []
        tokenizer.enumerateTokens(in: sentence.startIndex..<sentence.endIndex) { range, _ in
            let originalWord = String(sentence[range])
            if let directReplacement = dictionaryReplacement(for: originalWord) {
                replacedWords.append(directReplacement)
            } else {
                replacedWords.append(originalWord)
            }
            return true
        }
        
        return replacedWords.joined(separator: " ")
    }
    
    private func tokenizeWords(_ text: String) -> [String] {
        var words: [String] = []
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = text
        
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            let token = String(text[range])
            if !token.isEmpty {
                words.append(token)
            }
            return true
        }
        return words
    }
    
    private func isAlphabetic(_ word: String) -> Bool {
        return word.range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
    
    private func matchCase(original: String, replacement: String) -> String {
        if let first = original.first, first.isUppercase {
            return replacement.capitalized
        }
        return replacement.lowercased()
    }
}
