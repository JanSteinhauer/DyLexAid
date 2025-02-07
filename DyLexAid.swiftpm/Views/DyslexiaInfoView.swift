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
        case .whatIsDyslexia: return "What is Dyslexia?"
        case .commonSymptoms: return "Common Symptoms"
        case .howToHelp: return "How to Help?"
        case .appFeatures: return "How DyLexAid Helps"
        case .additionalResources: return "Additional Resources"
        }
    }
    
    var description: String {
        switch self {
        case .whatIsDyslexia: return "Learn about dyslexia and how it affects reading."
        case .commonSymptoms: return "Recognize the signs and symptoms of dyslexia."
        case .howToHelp: return "Ways to support someone with dyslexia."
        case .appFeatures: return "Assistive tools for improving reading accessibility."
        case .additionalResources: return "Find more information and support for dyslexia."
        }
    }
    
    var detailedDescription: String {
        switch self {
        case .whatIsDyslexia: return "Dyslexia is a neurological learning difference affecting reading, writing, and spelling. It does not reflect a lack of intelligence or effort."
        case .commonSymptoms: return "Symptoms include difficulty recognizing words, spelling issues, slow reading speed, and comprehension challenges."
        case .howToHelp: return "Support strategies include patience, multi-sensory learning, assistive technology, extra time, and breaking tasks into smaller steps."
        case .appFeatures: return "DyLexAid offers text-to-speech, dyslexia-friendly fonts, structured formatting, and more for better reading accessibility."
        case .additionalResources: return "Resources like the International Dyslexia Association and British Dyslexia Association offer support, training, and advocacy."
        }
    }
}


