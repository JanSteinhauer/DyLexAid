//
//  ToggleOption.swift
//  DyLexAid
//
//  Created by Steinhauer, Jan on 2/3/25.
//

import SwiftUI

struct ToggleOption: View {
    let title: String
    @Binding var isEnabled: Bool

    var body: some View {
        HStack(spacing: 10) {
            Text(title)
                .font(.custom("Arial", size: 14))
            Toggle("", isOn: $isEnabled)
                .labelsHidden()
        }
    }
}

