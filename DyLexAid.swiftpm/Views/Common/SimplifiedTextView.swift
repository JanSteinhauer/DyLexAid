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
    
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Simplified Version:")
                .fontWeight(.semibold)
                .padding(.leading, 5)
            
            AttributedTextView(attributedString: buildHighlightedAttributedString())
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding(.horizontal, 5)
                .overlay(alignment: .topTrailing) {
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
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = CGFloat(settings.lineSpacing)
        
        let baseFont = UIFont(
            name: settings.fontName.rawValue,
            size: CGFloat(settings.fontSize)
        ) ?? UIFont.systemFont(ofSize: CGFloat(settings.fontSize))
        
        let baseAttributes: [NSAttributedString.Key: Any] = [
            .font: baseFont,
            .paragraphStyle: paragraphStyle
        ]
        
        attributed.addAttributes(
            baseAttributes,
            range: NSRange(location: 0, length: attributed.length)
        )
        
        if let range = speechManager.highlightedRange,
           range.location != NSNotFound,
           range.location + range.length <= attributed.length {
            let highlightedFont = UIFont(
                descriptor: baseFont.fontDescriptor.withSymbolicTraits(.traitBold)
                    ?? baseFont.fontDescriptor,
                size: baseFont.pointSize + 6
            )
            attributed.addAttributes([
                .backgroundColor: UIColor.yellow,
                .font: highlightedFont
            ], range: range)
        }
        
        return attributed
    }
}
