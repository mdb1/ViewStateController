//
//  LoadingViewModifier.swift
//  ViewStateController
//
//  Created by Manu on 22/02/2023.
//

import SwiftUI

/// View Modifier to apply to views automatically while using `withViewStateModifier` method,
/// whenever a loading state needs to be shown.
public struct LoadingViewModifier<IndicatorView: View>: ViewModifier {
    private let type: LoadingModifierType
    private let indicatorView: IndicatorView

    /// Initializer
    /// - Parameters:
    ///   - type: The type to apply the style of the loading state.
    ///   - indicatorView: The indicator view to display.
    public init(
        type: LoadingModifierType,
        indicatorView: IndicatorView
    ) {
        self.type = type
        self.indicatorView = indicatorView
    }

    public func body(content: Content) -> some View {
        switch type {
        case .none:
            content
        case let .material(padding, displayIndicator, indicatorPadding, cornerRadius, alignment):
            materialView(
                with: padding,
                displayIndicator: displayIndicator,
                indicatorPadding: indicatorPadding,
                cornerRadius: cornerRadius,
                alignment: alignment,
                content: content
            )
        case let .overCurrentContent(
            padding, displayIndicator, indicatorPadding, contentOpacity, disableInteraction, alignment
        ):
            overCurrentContentView(
                with: padding,
                displayIndicator: displayIndicator,
                indicatorPadding: indicatorPadding,
                contentOpacity: contentOpacity,
                disableInteraction: disableInteraction,
                alignment: alignment,
                content: content
            )
        case let .horizontal(option, contentOpacity, disableInteraction, alignment, spacing):
            horizontalView(
                option: option,
                contentOpacity: contentOpacity,
                disableInteraction: disableInteraction,
                alignment: alignment,
                spacing: spacing,
                content: content
            )
        case let .vertical(option, contentOpacity, disableInteraction, alignment, spacing):
            verticalView(
                option: option,
                contentOpacity: contentOpacity,
                disableInteraction: disableInteraction,
                alignment: alignment,
                spacing: spacing,
                content: content
            )
        case let .toolbar(contentOpacity, disableInteraction):
            toolbarView(
                contentOpacity: contentOpacity,
                disableInteraction: disableInteraction,
                content: content
            )
        case let .custom(customView):
            customView
        }
    }
}

private extension LoadingViewModifier {
    func materialView(
        with padding: CGFloat,
        displayIndicator: Bool,
        indicatorPadding: CGFloat,
        cornerRadius: CGFloat,
        alignment: Alignment,
        content: Content
    ) -> some View {
        ZStack(alignment: alignment) {
            content
                .padding(padding)
                .materialOverlay(cornerRadius: cornerRadius)
            if displayIndicator {
                indicatorView
                    .padding(indicatorPadding)
            }
        }
    }

    func overCurrentContentView(
        with padding: CGFloat,
        displayIndicator: Bool,
        indicatorPadding: CGFloat,
        contentOpacity: CGFloat,
        disableInteraction: Bool,
        alignment: Alignment,
        content: Content
    ) -> some View {
        ZStack(alignment: alignment) {
            content
                .padding(padding)
                .opacity(contentOpacity)
                .disabled(disableInteraction)
            if displayIndicator {
                indicatorView
                    .padding(indicatorPadding)
            }
        }
    }

    @ViewBuilder
    func horizontalView(
        option: LoadingModifierType.HorizontalOption,
        contentOpacity: CGFloat,
        disableInteraction: Bool,
        alignment: VerticalAlignment,
        spacing: CGFloat,
        content: Content
    ) -> some View {
        if option == .leading {
            HStack(alignment: alignment, spacing: spacing) {
                indicatorView
                content
                    .opacity(contentOpacity)
                    .disabled(disableInteraction)
            }
        } else if option == .trailing {
            HStack(alignment: alignment, spacing: spacing) {
                content
                    .opacity(contentOpacity)
                    .disabled(disableInteraction)
                indicatorView
            }
        }
    }

    @ViewBuilder
    func verticalView(
        option: LoadingModifierType.VerticalOption,
        contentOpacity: CGFloat,
        disableInteraction: Bool,
        alignment: HorizontalAlignment,
        spacing: CGFloat,
        content: Content
    ) -> some View {
        if option == .top {
            VStack(alignment: alignment, spacing: spacing) {
                indicatorView
                content
                    .opacity(contentOpacity)
                    .disabled(disableInteraction)
            }
        } else if option == .bottom {
            VStack(alignment: alignment, spacing: spacing) {
                content
                    .opacity(contentOpacity)
                    .disabled(disableInteraction)
                indicatorView
            }
        }
    }

    func toolbarView(
        contentOpacity: CGFloat,
        disableInteraction: Bool,
        content: Content
    ) -> some View {
        content
            .opacity(contentOpacity)
            .disabled(disableInteraction)
            .toolbar {
                ToolbarItem {
                    indicatorView
                }
            }
    }
}

/// Possible styles of loading views.
public enum LoadingModifierType {
    /// Doesn't display anything.
    case none
    /// Displays a `material` overlay on top of the current content.
    /// - Parameters:
    ///   - padding: The padding to apply to the view.
    ///   - displayIndicator: Whether or not a loading indicator should be shown.
    ///   - indicatorPadding: The padding to apply to the loading indicator.
    ///   - cornerRadius: The corner radius to apply to the material background.
    ///   - alignment: The alignment to use in the ZStack.
    case material(
        padding: CGFloat = 0,
        displayIndicator: Bool = true,
        indicatorPadding: CGFloat = 8,
        cornerRadius: CGFloat = 8,
        alignment: Alignment = .center
    )
    /// Displays a `Color` (can be `clear`) background overlay on top of the current content.
    /// - Parameters:
    ///   - padding: The padding to apply to the view.
    ///   - displayIndicator: Whether or not a loading indicator should be shown.
    ///   - indicatorPadding: The padding to apply to the loading indicator.
    ///   - contentOpacity: The opacity to apply to the original content.
    ///   - disableInteraction: Boolean representing if the content will be disabled or not.
    ///   - alignment: The alignment to use in the ZStack.
    case overCurrentContent(
        padding: CGFloat = 0,
        displayIndicator: Bool = true,
        indicatorPadding: CGFloat = 8,
        contentOpacity: CGFloat = 1,
        disableInteraction: Bool = true,
        alignment: Alignment = .trailing
    )
    /// Displays a loading indicator in an HStack (can be trailing or leading).
    /// - Parameters:
    ///   - option: Horizontal positioning option (leading or trailing).
    ///   - contentOpacity: The opacity to apply to the original content.
    ///   - disableInteraction: Boolean representing if the content will be disabled or not.
    ///   - alignment: The alignment to use in the HStack.
    ///   - spacing: The spacing value to use in the HStack.
    case horizontal(
        option: HorizontalOption = .trailing,
        contentOpacity: CGFloat = 1,
        disableInteraction: Bool = true,
        alignment: VerticalAlignment = .center,
        spacing: CGFloat = 8
    )
    /// Displays a loading indicator in a VStack (can be top or bottom).
    /// - Parameters:
    ///   - option: Vertical positioning option (top or bottom).
    ///   - contentOpacity: The opacity to apply to the original content.
    ///   - disableInteraction: Boolean representing if the content will be disabled or not.
    ///   - alignment: The alignment to use in the VStack.
    ///   - spacing: The spacing value to use in the VStack.
    case vertical(
        option: VerticalOption = .bottom,
        contentOpacity: CGFloat = 1,
        disableInteraction: Bool = true,
        alignment: HorizontalAlignment = .leading,
        spacing: CGFloat = 8
    )
    /// Displays a loading indicator in the toolbar.
    /// - Parameters:
    ///   - contentOpacity: The opacity to apply to the original content.
    ///   - disableInteraction: Boolean representing if the content will be disabled or not.
    case toolbar(
        contentOpacity: CGFloat = 1,
        disableInteraction: Bool = true
    )
    /// Displays a custom view.
    case custom(_ view: AnyView)

    public enum HorizontalOption: String, CaseIterable {
        /// Leading Horizontal Option.
        case leading
        /// Trailing Horizontal Option.
        case trailing
    }

    public enum VerticalOption: String, CaseIterable {
        /// Bottom Vertical Option.
        case bottom
        /// Top Vertical Option.
        case top
    }
}
