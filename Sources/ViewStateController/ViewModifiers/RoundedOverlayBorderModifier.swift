//
//  RoundedOverlayBorderModifier.swift
//  
//
//  Created by Manu on 11/04/2023.
//

import Foundation
import SwiftUI

/// Extension to apply a RoundedOverlayBorder modifier.
public extension View {
    /// Adds a rounded overlay border to the view.
    func roundedOverlayBorder(
        cornerRadius: CGFloat,
        color: Color = .gray,
        lineWidth: CGFloat = 1
    ) -> some View {
        modifier(
            RoundedOverlayBorderModifier(
                cornerRadius: cornerRadius,
                color: color,
                lineWidth: lineWidth
            )
        )
    }
}

/// A modifier that adds a `rounded rectangle` overlay border to the view.
struct RoundedOverlayBorderModifier: ViewModifier {
    private var cornerRadius: CGFloat
    private var color: Color
    private var lineWidth: CGFloat

    init(
        cornerRadius: CGFloat,
        color: Color,
        lineWidth: CGFloat = 1
    ) {
        self.cornerRadius = cornerRadius
        self.color = color
        self.lineWidth = lineWidth
    }

    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(color, lineWidth: lineWidth)
        )
    }
}
