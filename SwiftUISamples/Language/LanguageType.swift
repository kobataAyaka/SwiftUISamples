//
//  LanguageType.swift
//  SwiftUISamples
//
//  Created by 小幡綾加 on 7/6/25.
//

import Foundation

enum LanguageType: String, CaseIterable {
    case Korean
    case English
    case Japanese
    case Default
    
    var locale: Locale {
        switch self {
        case .Korean:
            return Locale(identifier: "ko")
        case .English:
            return Locale(identifier: "en")
        case .Japanese:
            return Locale(identifier: "ja")
        case .Default:
            return Locale.current
        }
    }
}
