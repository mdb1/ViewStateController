//
//  ErrorView.swift
//  ViewStateController
//
//  Created by Manu on 26/02/2023.
//

import Foundation
import SwiftUI

/// Customizable error view with different types.
public struct ErrorView: View {
    private let type: ErrorViewType

    /// Initializer
    /// - Parameters:
    ///   - type: The type to apply the style of the error state.
    public init(type: ErrorViewType) {
        self.type = type
    }

    /// Convenience initializer that applies the default error state.
    /// - Parameter retryAction: The retry action for the button.
    public init(retryAction: @escaping () -> Void) {
        type = .vertical(
            style: .init(
                buttonOptions: .init(action: retryAction),
                frameAlignment: .center
            ),
            alignment: .center
        )
    }

    public var body: some View {
        switch type {
        case .emptyView:
            EmptyView()
        case let .vertical(style, alignment):
            verticalView(style: style, alignment: alignment)
        case let .horizontal(style, alignment):
            horizontalView(style: style, alignment: alignment)
        case let .custom(customView):
            customView
        }
    }
}

private extension ErrorView {
    @ViewBuilder
    func verticalView(
        style: ErrorViewStyle,
        alignment: HorizontalAlignment
    ) -> some View {
        VStack(alignment: alignment) {
            view(for: style)
        }
        .frame(maxWidth: .infinity, alignment: style.frameAlignment)
    }

    @ViewBuilder
    func horizontalView(
        style: ErrorViewStyle,
        alignment: VerticalAlignment
    ) -> some View {
        HStack(alignment: alignment) {
            view(for: style)
        }
        .frame(maxWidth: .infinity, alignment: style.frameAlignment)
    }

    @ViewBuilder
    func view(for style: ErrorViewStyle) -> some View {
        if let imageOptions = style.imageOptions {
            Image(systemName: imageOptions.systemName)
                .resizable()
                .frame(
                    width: imageOptions.frame.width,
                    height: imageOptions.frame.height
                )
                .foregroundColor(imageOptions.foregroundColor)
        }
        if let titleOptions = style.titleOptions {
            Text(titleOptions.text)
                .font(titleOptions.font)
                .foregroundColor(titleOptions.foregroundColor)
        }
        if let buttonOptions = style.buttonOptions {
            Button(buttonOptions.text) {
                buttonOptions.action()
            }
            .tint(buttonOptions.tintColor)
            .foregroundColor(buttonOptions.foregroundColor)
            .buttonStyle(.borderedProminent)
            .font(buttonOptions.font)
        }
    }
}

/// Possible types of error view.
public enum ErrorViewType {
    /// Displays an EmptyView.
    case emptyView
    /// Displays a vertical stack with some customizable options:
    /// Image (system name, color, frame)
    /// Title (text, color, font)
    /// Retry button (text, foreground/background color, font, action)
    case vertical(
        style: ErrorViewStyle,
        alignment: HorizontalAlignment
    )
    /// Displays an horizontal stack with some customizable options:
    /// Image (system name, color, frame)
    /// Title (text, color, font)
    /// Retry button (text, foreground/background color, font, action)
    case horizontal(
        style: ErrorViewStyle,
        alignment: VerticalAlignment
    )
    /// Displays a custom view.
    case custom(_ view: AnyView)
}

public struct ErrorViewStyle {
    public struct ImageOptions {
        let systemName: String
        let foregroundColor: Color
        let frame: CGSize

        public init(
            systemName: String = "xmark.circle.fill",
            foregroundColor: Color = .red,
            frame: CGSize = .init(width: 50, height: 50)
        ) {
            self.systemName = systemName
            self.foregroundColor = foregroundColor
            self.frame = frame
        }
    }

    public struct TitleOptions {
        let text: String
        let foregroundColor: Color
        let font: Font

        public init(
            text: String = "Something went wrong",
            foregroundColor: Color = .primary,
            font: Font = .callout
        ) {
            self.text = text
            self.foregroundColor = foregroundColor
            self.font = font
        }
    }

    public struct ButtonOptions {
        let text: String
        let foregroundColor: Color
        let tintColor: Color
        let font: Font
        let action: () -> Void

        public init(
            text: String = "Retry",
            foregroundColor: Color = .white,
            tintColor: Color = .accentColor,
            font: Font = .callout,
            action: @escaping () -> Void
        ) {
            self.text = text
            self.foregroundColor = foregroundColor
            self.tintColor = tintColor
            self.font = font
            self.action = action
        }
    }

    let imageOptions: ImageOptions?
    let titleOptions: TitleOptions?
    let buttonOptions: ButtonOptions?
    let frameAlignment: Alignment

    public init(
        imageOptions: ImageOptions? = .init(),
        titleOptions: TitleOptions? = .init(),
        buttonOptions: ButtonOptions?,
        frameAlignment: Alignment = .center
    ) {
        self.imageOptions = imageOptions
        self.titleOptions = titleOptions
        self.buttonOptions = buttonOptions
        self.frameAlignment = frameAlignment
    }
}
