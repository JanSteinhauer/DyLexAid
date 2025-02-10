//
//  DyslexiaSection.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 2/7/25.
//

import SwiftUI

struct DyslexiaSection: View {
    let topic: DyslexiaTopic
    @Binding var selectedTopic: DyslexiaTopic?
    @EnvironmentObject var settings: AppSettings

    
    var body: some View {
        
            
            VStack {
                Image(topic.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text(topic.title)
                            .fontWeight(.bold)
                            
                        Text(topic.description)
                        
                        Button(action: { selectedTopic = topic }) {
                            Text("Learn More")
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.blue)
                        .font(.system(size: CGFloat(settings.fontSize - 3)))
                    }
                    
                    Spacer()
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
        
    }
}
