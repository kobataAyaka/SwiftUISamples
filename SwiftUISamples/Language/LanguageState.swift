//
//  LanguageState.swift
//  SwiftUISamples
//
//  Created by 小幡綾加 on 7/6/25.
//

import SwiftUI

final class LanguageState: ObservableObject {
    @Published var type: LanguageType = .Default
}
