//
//  GradientShadowModifier.swift
//  SwiftUISamples
//
//  Created by 小幡綾加 on 11/21/24.
//

import SwiftUI

public struct GradientShadow: ViewModifier {
    var colors: [Color]
    var offset: CGSize
    var cornerRadius: CGFloat

    public func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    gradient: Gradient(colors: colors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .offset(offset)
                .blur(radius: 10)
            )
    }
}

public extension View {
    func gradientShadow(colors: [Color], offset: CGSize, cornerRadius: CGFloat) -> some View {
        self.modifier(GradientShadow(colors: colors, offset: offset, cornerRadius: cornerRadius))
    }
}
