//
//  SwiftUIView.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 2/5/25.
//DyslexiaInfoView

import SwiftUI

struct DyslexiaInfoView: View {
    @State private var selectedTopic: DyslexiaTopic?
    @EnvironmentObject var settings: AppSettings

    var body: some View {
            ScrollView {
                VStack(spacing: 0) {
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .opacity(0.4)
                        .frame(height: 150)
                        .ignoresSafeArea(edges: .top)

                        HStack {
                            Spacer()
                            VStack {
                                Text("Accessibility & Dyslexia")
                                    .font(.system(size: CGFloat(settings.fontSize + 15)))
                                    .fontWeight(.bold)
                                    .padding(.top)

                                Text("Understanding dyslexia and how to make reading more accessible for everyone.")
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                    }
                    
                    VStack(alignment: .leading){
                        HStack{
                            Text("Overview")
                                .font(.system(size: CGFloat(settings.fontSize + 8)))
                                .fontWeight(.semibold)
                                .padding(.top)
                                
                            
                            Spacer()
                        }
                        
                        Text("Dyslexia affects reading and language processing but isn't linked to intelligence. It stems from how the brain interprets words. With the right support, individuals can improve their reading skills.")
                            .multilineTextAlignment(.leading)


                    }
                    .padding()

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 20) {
                        ForEach(DyslexiaTopic.allCases, id: \.self) { topic in
                            DyslexiaSection(topic: topic, selectedTopic: $selectedTopic)
                        }
                    }
                    .padding()
                }
            }
        
        .sheet(item: $selectedTopic) { topic in
            DyslexiaDetailView(topic: topic)
        }
    }
}

enum DyslexiaTopic: String, CaseIterable, Identifiable {
    case whatIsDyslexia, commonSymptoms, howToHelp, appFeatures, additionalResources
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .whatIsDyslexia:       return "What is Dyslexia?"
        case .commonSymptoms:       return "Common Symptoms"
        case .howToHelp:            return "How to Help?"
        case .appFeatures:          return "How DyLexAid Helps"
        case .additionalResources:  return "Additional Resources"
        }
    }
    
    var image: String {
        switch self {
        case .whatIsDyslexia:       return "WhatDyslexia"
        case .commonSymptoms:       return "CommonSyptoms"
        case .howToHelp:            return "HowCanYouHelp"
        case .appFeatures:          return "DyLexAidHelps"
        case .additionalResources:  return "AdditionalResources"
        }
    }
    
    var description: String {
        switch self {
        case .whatIsDyslexia:       return "Learn about dyslexia and how it affects reading."
        case .commonSymptoms:       return "Recognize the signs and symptoms of dyslexia."
        case .howToHelp:            return "Ways to support someone with dyslexia."
        case .appFeatures:          return "Assistive tools for improving reading accessibility."
        case .additionalResources:  return "Find more information and support for dyslexia."
        }
    }
    
    /// The main paragraph or paragraphs describing the topic in detail.
    var detailedDescription: String {
        switch self {
        case .whatIsDyslexia:
            return """
            Dyslexia is a condition that affects how the brain processes written and spoken language. It is not related to intelligence but impacts reading fluency, spelling, and comprehension.
            """
        case .commonSymptoms:
            return """
            Symptoms of dyslexia can vary by age and severity. Common indicators include difficulty recognizing or decoding words, slow or inaccurate reading, frequent spelling mistakes, difficulty with reading comprehension, and struggles with following multi-step instructions.
            """
        case .howToHelp:
            return """
            There are many ways to support individuals with dyslexia. Some effective strategies include using multi-sensory learning techniques, encouraging audiobooks, speech-to-text tools, and providing extra time for reading and assignments.
            """
        case .appFeatures:
            return """
            DyLexAid is designed to enhance reading accessibility through assistive tools that reduce the cognitive load, help decode words, and ensure a more comfortable reading experience.
            """
        case .additionalResources:
            return """
            For further learning and support, consider these trusted resources or local dyslexia support groups and specialists. Ongoing research and advocacy help improve strategies and technologies for dyslexia.
            """
        }
    }
    
    var bulletPoints: [(text: String, url: String?)] {
        switch self {
        case .whatIsDyslexia:
            return [
                ("Affects up to 10% of the population worldwide", nil),
                ("Often hereditary and linked to specific brain differences", nil),
                ("Early intervention and support strategies can greatly help", nil)
            ]
        case .commonSymptoms:
            return [
                ("Difficulty recognizing or decoding words", nil),
                ("Slow or inaccurate reading", nil),
                ("Frequent spelling mistakes", nil),
                ("Reading comprehension challenges", nil),
                ("Struggles with following multi-step instructions", nil)
            ]
        case .howToHelp:
            return [
                ("Use multi-sensory learning techniques", nil),
                ("Encourage audiobooks or speech-to-text tools", nil),
                ("Provide extra time for reading and assignments", nil),
                ("Break tasks into manageable steps", nil),
                ("Use dyslexia-friendly fonts and formatting", nil)
            ]
        case .appFeatures:
            return [
                ("Text-to-Speech for auditory learning", nil),
                ("Dyslexia-friendly fonts for better readability", nil),
                ("Customizable text formatting", nil),
                ("Word highlighting to improve focus", nil),
                ("Personalized settings for user comfort", nil)
            ]
        case .additionalResources:
            return [
                ("International Dyslexia Association", "https://dyslexiaida.org"),
                ("British Dyslexia Association", "https://www.bdadyslexia.org.uk"),
                ("Understood.org", "https://www.understood.org"),
            ]
        }
    }
}


