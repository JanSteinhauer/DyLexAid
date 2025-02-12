//
//  ActionButtons.swift
//
//
//  Created by Steinhauer, Jan on 2/4/25.
//

import SwiftUI

struct ActionButtons: View {
    @ObservedObject var viewModel: TextProcessingViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                viewModel.processText()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "wand.and.stars")
                    Text(viewModel.areTogglesVisible ? "Start" : "Start")
                        .fontWeight(.semibold)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing))
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(radius: 5)
            }
            
            Button(action: {
                viewModel.areTogglesVisible.toggle()
                viewModel.processText()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing))
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(radius: 5)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 10)
    }
}
