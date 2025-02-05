//
//  InfoCard.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 2/5/25.
//

import SwiftUI

struct InfoCard<Content: View>: View {
    let title: String
    var icon: String
    var text: String?
    var content: () -> Content
    
    init(title: String, icon: String, text: String? = nil, @ViewBuilder content: @escaping () -> Content = { EmptyView() }) {
        self.title = title
        self.icon = icon
        self.text = text
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .imageScale(.large)
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                Spacer()
            }
            
            
            if let text = text {
                Text(text)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            
            content()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.systemGray6))
        
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

