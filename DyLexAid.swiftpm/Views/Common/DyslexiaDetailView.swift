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
                        .padding(.bottom, 5)
                        .padding(.top, 12)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Divider()
                        .background(Color.gray)
                        .padding(.vertical, 5)
                    
                    Text(topic.detailedDescription)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                    
                    if !topic.bulletPoints.isEmpty {
                        BulletPointList(items: topic.bulletPoints)
                            .padding()
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct BulletPointList: View {
    let items: [(text: String, url: String?)]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(items, id: \.text) { item in
                HStack(alignment: .top, spacing: 8) {
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .opacity(0.4)
                        
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 12, height: 12)
                    }
                    .frame(width: 25, height: 25)
                    .clipShape(Circle())

                    if let url = item.url {
                        Link(item.text, destination: URL(string: url)!)
                            .font(.body)
                            .foregroundColor(.blue)
                            .underline()
                    } else {
                        Text(item.text)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
        }
    }
}


