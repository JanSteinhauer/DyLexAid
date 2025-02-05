//
//  BulletListView.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 2/5/25.
//

import SwiftUI

struct BulletListView: View {
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .foregroundColor(.blue)
                    Text(item)
                        .font(.body)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}
