//
//  SwiftUIView.swift
//  
//
//  Created by Steinhauer, Jan on 2/4/25.
//

import SwiftUI

struct OnboardingPopupView: View {
    @EnvironmentObject var settings: AppSettings
    @EnvironmentObject var text_processing_model: TextProcessingViewModel
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 20) {
            Image("DyLexAidLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .scaleEffect(scale)
                .animation(
                    Animation.easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true),
                    value: scale
                )
                .onAppear {
                    scale = 1.2
                }
            Text("DyLexAid")
                .font(.system(size: 28, weight: .bold))
            
            Text("""
            DyLexAid simplifies reading for people with dyslexia with text-to-speech and accessible reading modes for pasted, scanned, or uploaded text while also promoting awareness and understanding of dyslexia.
            """)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .fixedSize(horizontal: false, vertical: true)
            .layoutPriority(1) 
            
            VStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text("Font Size: \(settings.fontSize)")
                    Slider(
                        value: Binding(
                            get: { Double(settings.fontSize) },
                            set: { settings.fontSize = Int($0) }
                        ),
                        in: 10...35,
                        step: 1
                    )
                }
                
                VStack(alignment: .leading) {
                    Text("Line Spacing: \(String(format: "%.1f", settings.lineSpacing))")
                    Slider(
                        value: $settings.lineSpacing,
                        in: 1.0...10.0,
                        step: 0.2
                    )
                }
                
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    HStack {
                        Menu {
                            ForEach(AppFont.allCases, id: \.self) { fontOption in
                                Button(action: {
                                    settings.fontName = fontOption
                                }) {
                                    Text(fontOption.rawValue)
                                        .font(.system(size: CGFloat(settings.fontSize)))
                                }
                            }
                        } label: {
                            HStack {
                                Text("Choose Font")
                                    .font(.system(size: CGFloat(settings.fontSize)))              
                                Text(settings.fontName.rawValue)
                                    .font(.system(size: CGFloat(settings.fontSize)))
                                    .padding()
                                    .background(Color(UIColor.secondarySystemFill))
                                    .cornerRadius(8)
                            }
                            .padding(8)
                            .foregroundColor(.black)
                            
                            Spacer()
                        }

                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            
            TogglesView(viewModel: text_processing_model)
                .padding(.horizontal)
            
            HStack {
                Spacer()
                Button(action: {
                    text_processing_model.areTogglesVisible = false
                    settings.firstTimeOpen = false
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing))
                        .cornerRadius(8)
                }
            }
        }.onAppear(perform: {
            text_processing_model.areTogglesVisible = true
        })
        
        
        .padding()
        Spacer()
    }
}
