//
//  DyslexiaDetailView.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 2/7/25.
//

import SwiftUI

struct DyslexiaDetailView: View {
    @EnvironmentObject var settings: AppSettings
    
    let topic: DyslexiaTopic
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(topic.title)
                        .font(.system(size: CGFloat(settings.fontSize + 15)))
                        .fontWeight(.bold)
                    
                    Text(topic.detailedDescription)
                        
                }
                .padding()
            }
           
            
        }
    }
}
