//
//  SwiftUIView.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 2/3/25.
//

import SwiftUI
import PDFKit

struct PDFExtractor {
    static func extractText(from url: URL) -> String? {
        guard let document = PDFDocument(url: url) else { return nil }
        var extractedText = ""
        for pageIndex in 0..<document.pageCount {
            if let page = document.page(at: pageIndex), let pageContent = page.string {
                extractedText += pageContent
            }
        }
        return extractedText
    }
}

