//
//  SimplifiedTextView.swift
//
//
//  Created by Steinhauer, Jan on 2/4/25.
//

import SwiftUI

struct SimplifiedTextView: View {
    @ObservedObject var viewModel: TextProcessingViewModel
    @ObservedObject var speechManager: SpeechManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Simplified Version:")
                .fontWeight(.semibold)
                .padding(.leading, 5)
            
            ZStack(alignment: .topTrailing) {
                ScrollView {
                    AttributedTextView(attributedString: buildHighlightedAttributedString())
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .shadow(radius: 5)
                .frame(maxWidth: .infinity, minHeight: 180)
                .padding(.horizontal, 5)
                HStack(spacing: 8) {
                    Button(action: {
                        UIPasteboard.general.string = viewModel.simplifiedText
                    }) {
                        Image(systemName: "doc.on.doc")
                            .padding(10)
                            .background(Color.green.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    
                    Button(action: {
                        speechManager.speakText(viewModel.simplifiedText)
                    }) {
                        Image(systemName: "speaker.3")
                            .padding(10)
                            .background(Color.orange.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                }
                .font(.system(size: 20))
                .padding(.top, 17)
                .padding(.trailing, 15)
            }
        }
    }
    
    private func buildHighlightedAttributedString() -> NSAttributedString {
        let attributed = NSMutableAttributedString(string: viewModel.simplifiedText)
        
        if let range = speechManager.highlightedRange,
           range.location != NSNotFound,
           range.location + range.length <= attributed.length {
            
            attributed.addAttribute(.backgroundColor,
                                    value: UIColor.yellow,
                                    range: range)
            
            attributed.addAttribute(.font,
                                    value: UIFont.systemFont(ofSize: UIFont.systemFontSize + 5),
                                    range: range)
        }
        
        return attributed
    }
}
