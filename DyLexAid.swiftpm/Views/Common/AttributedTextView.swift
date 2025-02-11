//
//  SwiftUIView.swift
//  
//
//  Created by Steinhauer, Jan on 2/4/25.
//

import SwiftUI

struct AttributedTextView: UIViewRepresentable {
    
    @EnvironmentObject var settings: AppSettings
    let attributedString: NSAttributedString

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedString
    }

    
    private func applyTextAttributes(to attributedString: NSAttributedString) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = CGFloat(settings.lineSpacing)
        
        let font = UIFont(name: settings.fontName.rawValue, size: CGFloat(settings.fontSize)) ?? UIFont.systemFont(ofSize: CGFloat(settings.fontSize))
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        
        mutableAttributedString.addAttributes(attributes, range: NSRange(location: 0, length: mutableAttributedString.length))
        return mutableAttributedString
    }
}

