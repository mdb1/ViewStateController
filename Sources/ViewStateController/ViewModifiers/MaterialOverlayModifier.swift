//
//  MaterialOverlayModifier.swift
//  ViewStateController
//
//  Created by Manu on 23/02/2023.
//

import Foundation
import SwiftUI

public extension View {
    /// Adds a material overlay on top of the current view.
    /// Used principally for placeholder views.
    /// Tip: You could achieve a similar result using the `.redacted(reason: .placeholder)` method.
    func materialOverlay(cornerRadius: CGFloat = 8) -> some View {
        modifier(MaterialOverlayModifier(cornerRadius: cornerRadius))
    }
}

struct MaterialOverlayModifier: ViewModifier {
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content.overlay(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
