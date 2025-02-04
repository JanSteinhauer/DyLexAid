//
//  AppSettings.swift
//
//
//  Created by Steinhauer, Jan on 2/4/25.
//

import SwiftUI

class AppSettings: ObservableObject {
    @AppStorage("first_time_open") var firstTimeOpen: Bool = true
    @AppStorage("font_size") var fontSize: Int = 14
    @AppStorage("font_name") var fontName: String = "Arial"
    @AppStorage("line_spacing") var lineSpacing: Double = 1.5
}
