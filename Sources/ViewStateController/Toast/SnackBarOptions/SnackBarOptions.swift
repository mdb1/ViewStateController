//
//  SnackBarOptions.swift
//
//
//  Created by Manu on 02/03/2023.
//

import Foundation
import SwiftUI

/// Configuration object for the snack bar toasts.
public struct SnackBarOptions {
    public struct Message {
        let text: String
        let color: Color
        let font: Font

        public init(
            text: String,
            color: Color = .white,
            font: Font = .system(size: 16)
        ) {
            self.text = text
            self.color = color
            self.font = font
        }
    }

    public struct Image {
        let imageSystemName: String
        let color: Color
        let size: CGSize

        public init(
            imageSystemName: String = "checkmark.circle",
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
    let image: Image?
    let background: Background
    let internalPadding: EdgeInsets

    public init(
        message: Message,
        image: Image? = nil,
        background: Background = .init(),
        internalPadding: EdgeInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
    ) {
        self.message = message
        self.image = image
        self.background = background
        self.internalPadding = internalPadding
    }
}
