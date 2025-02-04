//
//  AppSettings.swift
//
//
//  Created by Steinhauer, Jan on 2/4/25.
//

import SwiftUI

enum AppFont: String, CaseIterable {
    case arial = "Arial"
    case helvetica = "Helvetica"
    case timesNewRoman = "Times New Roman"
    case courierNew = "Courier New"
    case verdana = "Verdana"
    case georgia = "Georgia"
    
    static var defaultFont: AppFont { .arial }
}

class AppSettings: ObservableObject {
    @AppStorage("first_time_open") var firstTimeOpen: Bool = true
    @AppStorage("font_size") var fontSize: Int = 24
    @AppStorage("line_spacing") var lineSpacing: Double = 1.5
    @AppStorage("playback_speed") var playbackSpeed: Double = 1.0
    @AppStorage("font_name") private var fontNameRaw: String = AppFont.defaultFont.rawValue

    var fontName: AppFont {
        get { AppFont(rawValue: fontNameRaw) ?? .arial }
        set { fontNameRaw = newValue.rawValue } 
    }
}
