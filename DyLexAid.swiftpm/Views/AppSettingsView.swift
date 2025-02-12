//
//  AppSettingsView.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 2/12/25.
//

import SwiftUI

struct AppSettingsView: View {
    
    @ObservedObject var settings: AppSettings

    var body: some View {
        VStack(spacing: 16) {
            HStack {
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
                
            }
            
            
            VStack(alignment: .leading, spacing: 8) {
                
                HStack {
                    Text("Choose Font")
                    Picker("Font", selection: $settings.fontName) {
                        ForEach(AppFont.allCases, id: \.self) { fontOption in
                            Text(fontOption.rawValue)
                                .font(.system(size: CGFloat(settings.fontSize)))
                                .tag(fontOption)
                        }
                    }
                    .pickerStyle(.menu)
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
    }
}
