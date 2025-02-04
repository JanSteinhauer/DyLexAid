//
//  SwiftUIView.swift
//  
//
//  Created by Steinhauer, Jan on 2/4/25.
//

import SwiftUI

struct OnboardingPopupView: View {
    @EnvironmentObject var settings: AppSettings

    
    var body: some View {
        VStack(spacing: 20) {
            Image("DyLexAidLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text("DyLexAid")
                .font(.system(size: 28, weight: .bold))
            
            Text("""
DyLexAid is an app that helps people with dyslexia read text more easily.
You can paste, scan, or upload text, then use text-to-speech and simplified reading modes.
""")
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            
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
                
                VStack(alignment: .leading) {
                    Text("Playback Speed: \(String(format: "%.1fx", settings.playbackSpeed))")
                    Slider(
                        value: $settings.playbackSpeed,
                        in: 0.5...2.0,
                        step: 0.1
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    HStack {
                        Text("Choose Font").font(.headline)
                        Picker("Font", selection: $settings.fontName) {
                            ForEach(AppFont.allCases, id: \.self) { fontOption in
                                Text(fontOption.rawValue)
                                    .font(Font.custom(fontOption.rawValue, size: 16))
                                    .tag(fontOption)
                            }
                        }
                        .pickerStyle(.menu)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            
            HStack {
                Spacer()
                Button(action: {
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
        }
        
        .padding()
        Spacer()
    }
}
