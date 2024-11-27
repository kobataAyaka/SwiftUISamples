//
//  CustomButtonStyle.swift
//  SwiftUISamples
//
//  Created by 小幡綾加 on 11/25/24.
//

import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {
        
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .padding()
            .background(LinearGradient.actionButton)
            .foregroundColor(.white)
            .font(.body.bold())
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .shadow( color: .black.opacity(0.2), radius: 5, x: 5, y: 5)
    }
}

fileprivate extension LinearGradient {
    static let actionButton = LinearGradient(gradient: Gradient(colors: [.orange, .purple]),
                                             startPoint: .topLeading,
                                             endPoint: .bottomTrailing)
}
