//
//  DefaultToastOptions.swift
//
//
//  Created by Manu on 01/03/2023.
//

import Foundation
import SwiftUI

/// Configuration object for the toasts.
public struct DefaultToastOptions {
    public struct Message {
        let text: String
        let color: Color
        let font: Font
        let alignment: Alignment

        public init(
            text: String,
            color: Color = .white,
            font: Font = .system(size: 16),
            alignment: Alignment = .leading
        ) {
            self.text = text
            self.color = color
            self.font = font
            self.alignment = alignment
        }
    }

    public struct TrailingButton {
        let imageSystemName: String
        let color: Color
        let size: CGSize

        public init(
            imageSystemName: String = "xmark",
            color: Color = .white,
            size: CGSize = .init(width: 12, height: 12)
        ) {
            self.imageSystemName = imageSystemName
            self.color = color
            self.size = size
        }
    }

    public struct Background {
        let color: Color
        let cornerRadius: CGFloat

        public init(
            color: Color = .accentColor,
            cornerRadius: CGFloat = 8
        ) {
            self.color = color
            self.cornerRadius = cornerRadius
        }
    }

    let message: Message
    let secondaryMessage: Message?
    let trailingButton: TrailingButton?
    let background: Background
    let internalPadding: UIEdgeInsets

    public init(
        message: Message,
        secondaryMessage: Message? = nil,
        trailingButton: TrailingButton? = .init(),
        background: Background = .init(),
        internalPadding: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    ) {
        self.message = message
        self.secondaryMessage = secondaryMessage
        self.trailingButton = trailingButton
        self.background = background
        self.internalPadding = internalPadding
    }
}
