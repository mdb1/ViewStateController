//
//  ToastModifier.swift
//
//
//  Created by Manu on 01/03/2023.
//

import Foundation
import SwiftUI

public extension View {
    /// Adds the Toast modifier.
    func toast(
        isShowing: Binding<Bool>,
        type: ToastType,
        transitionOptions: ToastTransitionOptions = .init(),
        positionOptions: ToastPositionOptions = .init(),
        onTap: (() -> Void)? = nil
    ) -> some View {
        modifier(
            ToastModifier(
                isShowing: isShowing,
                type: type,
                transitionOptions: transitionOptions,
                positionOptions: positionOptions,
                onTap: onTap
            )
        )
    }
}

/// Display a toast message for some (configurable) seconds. Then disappears.
public struct ToastModifier: ViewModifier {
    @Binding public var isShowing: Bool
    private let type: ToastType
    private let transitionOptions: ToastTransitionOptions
    private let positionOptions: ToastPositionOptions
    private let onTap: (() -> Void)?

    public init(
        isShowing: Binding<Bool>,
        type: ToastType,
        transitionOptions: ToastTransitionOptions,
        positionOptions: ToastPositionOptions,
        onTap: (() -> Void)? = nil
    ) {
        _isShowing = isShowing
        self.type = type
        self.transitionOptions = transitionOptions
        self.positionOptions = positionOptions
        self.onTap = onTap
    }

    public func body(content: Content) -> some View {
        ZStack {
            content
            ZStack(alignment: positionOptions.position.alignment) {
                Color.clear
                toastView
                    .padding(.leading, positionOptions.padding.left)
                    .padding(.top, positionOptions.padding.top)
                    .padding(.trailing, positionOptions.padding.right)
                    .padding(.bottom, positionOptions.padding.bottom)
            }
        }
    }
}

private extension ToastModifier {
    @ViewBuilder
    var toastView: some View {
        if isShowing {
            Group {
                switch type {
                case let .default(options):
                    defaultToastView(options)
                case let .custom(view):
                    view
                }
            }
            .onTapGesture {
                if let action = onTap {
                    withAnimation {
                        action()
                    }
                } else {
                    // If no action is defined, tapping on any part of the toast will dismiss it
                    withAnimation {
                        isShowing = false
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + transitionOptions.duration) {
                    withAnimation {
                        isShowing = false
                    }
                }
            }
            .transition(
                transitionOptions.transition
                    .animation(transitionOptions.animation)
            )
        }
    }

    func defaultToastView(_ options: DefaultToastOptions) -> some View {
        HStack(alignment: .center) {
            VStack(alignment: options.message.alignment.horizontal) {
                messageView(options.message)
                if let secondaryMessage = options.secondaryMessage {
                    messageView(secondaryMessage)
                }
            }
            Spacer()
            if let button = options.trailingButton {
                Button {
                    withAnimation {
                        isShowing = false
                    }
                } label: {
                    Image(systemName: button.imageSystemName)
                        .resizable()
                        .frame(width: button.size.width, height: button.size.height)
                        .tint(button.color)
                }
            }
        }
        .padding(.leading, options.internalPadding.left)
        .padding(.top, options.internalPadding.top)
        .padding(.trailing, options.internalPadding.right)
        .padding(.bottom, options.internalPadding.bottom)
        .background(options.background.color)
        .cornerRadius(options.background.cornerRadius)
    }

    func messageView(_ message: DefaultToastOptions.Message) -> some View {
        Text(message.text)
            .foregroundColor(message.color)
            .font(message.font)
            .frame(alignment: message.alignment)
    }
}

/// Possible types of toasts.
public enum ToastType {
    /// The default toast, based on some configurable options.
    case `default`(options: DefaultToastOptions)
    /// Displays a custom view.
    case custom(_ view: AnyView)
}
