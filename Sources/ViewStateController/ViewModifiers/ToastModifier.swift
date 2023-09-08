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
    @State private var cancelableAction: DispatchWorkItem?
    @State private var elapsedSeconds: Int = 0
    @State private var timer: Timer? = nil
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
        self.timer?.invalidate()
    }

    public func body(content: Content) -> some View {
        ZStack {
            content
            ZStack(alignment: positionOptions.position.alignment) {
                Color.clear
                toastView
                    .padding(.leading, positionOptions.padding.leading)
                    .padding(.top, positionOptions.padding.top)
                    .padding(.trailing, positionOptions.padding.trailing)
                    .padding(.bottom, positionOptions.padding.bottom)
            }
        }
        .onChange(of: isShowing) { newValue in
            if newValue {
                setUpTimer()
            } else {
                self.timer?.invalidate()
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
                case let .toast(options):
                    toastView(options)
                case let .snackBar(options):
                    snackBarView(options)
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
            .transition(
                transitionOptions.transition
                    .animation(transitionOptions.animation)
            )
        }
    }

    func toastView(_ options: ToastOptions) -> some View {
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
        .padding(.leading, options.internalPadding.leading)
        .padding(.top, options.internalPadding.top)
        .padding(.trailing, options.internalPadding.trailing)
        .padding(.bottom, options.internalPadding.bottom)
        .background(options.background.color)
        .cornerRadius(options.background.cornerRadius)
    }

    func messageView(_ message: ToastOptions.Message) -> some View {
        Text(message.text)
            .foregroundColor(message.color)
            .font(message.font)
            .frame(alignment: message.alignment)
    }

    func snackBarView(_ options: SnackBarOptions) -> some View {
        HStack(alignment: .center) {
            Text(options.message.text)
                .foregroundColor(options.message.color)
                .font(options.message.font)

            if let image = options.image {
                Image(systemName: image.imageSystemName)
                    .resizable()
                    .frame(width: image.size.width, height: image.size.height)
                    .tint(image.color)
                    .foregroundColor(image.color)
            }
        }
        .padding(.leading, options.internalPadding.leading)
        .padding(.top, options.internalPadding.top)
        .padding(.trailing, options.internalPadding.trailing)
        .padding(.bottom, options.internalPadding.bottom)
        .background(options.background.color)
        .cornerRadius(options.background.cornerRadius)
    }

    func setUpTimer() {
        // Reset the timer and elapsed seconds
        self.timer?.invalidate()
        elapsedSeconds = 0

        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if isShowing {
                elapsedSeconds += 1
//                print("😄 Timer tick. Elapsed seconds: \(elapsedSeconds)")
                if elapsedSeconds >= Int(transitionOptions.duration) {
                    withAnimation {
                        isShowing = false
                    }
                }
            } else {
                // Reset the elapsed time
                elapsedSeconds = 0
            }
        }
    }
}
