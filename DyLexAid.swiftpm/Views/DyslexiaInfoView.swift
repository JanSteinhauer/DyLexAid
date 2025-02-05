//
//  SwiftUIView.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 2/5/25.
//

import SwiftUI

struct DyslexiaInfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(spacing: 8) {
                    Text("Understanding Dyslexia")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Learn more about dyslexia and how DyLexAid can help.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
                
                InfoCard(title: "What is Dyslexia?", icon: "book.closed", text: "Dyslexia is a learning difference that affects reading, writing, and spelling. It is not linked to intelligence but to how the brain processes language. With the right support, people with dyslexia can succeed in any field.")
                
                InfoCard(title: "Common Symptoms", icon: "text.magnifyingglass", content: {
                    BulletListView(items: [
                        "Difficulty recognizing words quickly",
                        "Challenges with spelling and writing",
                        "Slow reading speed",
                        "Struggles with reading comprehension",
                        "Avoidance of reading-related tasks"
                    ])
                })
                
                InfoCard(title: "How Can You Help?", icon: "hand.raised", content: {
                    BulletListView(items: [
                        "Be patient and supportive",
                        "Use multi-sensory learning methods",
                        "Encourage assistive technologies",
                        "Provide additional time for reading tasks",
                        "Break tasks into manageable steps"
                    ])
                })
                
                VStack(spacing: 12) {
                    VStack{
                        Text("Empower Learning with DyLexAid")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("DyLexAid enhances reading by offering text-to-speech, optimized fonts, and structured formatting to improve accessibility. Designed to help individuals with dyslexia, DyLexAid makes reading smoother and more engaging.")
                            .font(.body)
                    }
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                    
                    Button(action: {
                    }) {
                        Label("Explore DyLexAid", systemImage: "arrow.forward.circle.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                                                       startPoint: .topLeading,
                                                       endPoint: .bottomTrailing))
                            .cornerRadius(12)
                            .shadow(radius: 4)
                    }
                    .padding(.horizontal)
                }
                
                InfoCard(title: "Learn More", icon: "link.circle", content: {
                    VStack(alignment: .leading, spacing: 8) {
                        Link("International Dyslexia Association", destination: URL(string: "https://dyslexiaida.org")!)
                        Link("British Dyslexia Association", destination: URL(string: "https://www.bdadyslexia.org.uk")!)
                        Link("Mayo Clinic - Dyslexia", destination: URL(string: "https://www.mayoclinic.org/diseases-conditions/dyslexia/symptoms-causes/syc-20353552")!)
                    }
                    .font(.body)
                    .foregroundColor(.blue)
                })
                
            }
            .padding()
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            
    }
}
