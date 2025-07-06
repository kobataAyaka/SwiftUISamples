//
//  SwiftUISamplesApp.swift
//  SwiftUISamples
//
//  Created by 小幡綾加 on 7/5/24.
//

import SwiftUI

@main
struct SwiftUISamplesApp: App {
    @StateObject private var navigationState = NavigationState()
    @StateObject private var languageState = LanguageState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationState)
                .environmentObject(languageState)
        }
    }
}
