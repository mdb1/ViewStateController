//
//  DemoDefaultToastOptionsView.swift
//  ControllerExampleApp
//
//  Created by Manu on 02/03/2023.
//

import Foundation
import SwiftUI
import ViewStateController

struct DemoDefaultToastOptionsView: View {
    @Binding var toastType: ToastType
    @Binding var positionOptions: ToastPositionOptions

    @State private var position: ToastPositionOptions.Position = .top
    @State private var tintColor: Color = .white
    @State private var backgroundColor: Color = .accentColor
    @State private var backgroundCornerRadius: CGFloat = 8
    @State private var displaySecondLine: Bool = false
    @State private var displayTrailingButton: Bool = true
    @State private var internalPadding: CGFloat = 16

    var body: some View {
        HStack {
            Text("Position")
                .frame(maxWidth: .infinity, alignment: .leading)
                .layoutPriority(900)
            Spacer()
            ZStack {
                Capsule()
                    .foregroundColor(.clear)
                    .background(Color.white.materialOverlay())
                Picker("Position", selection: $position) {
                    ForEach(
                        ToastPositionOptions.Position.allCases,
                        id: \.self
                    ) {
                        Text($0.rawValue)
                    }
                }.onChange(of: position) { _ in
                    updatePosition()
                }
            }
        }

        HStack {
            Text("Tint Color")
                .frame(maxWidth: .infinity, alignment: .leading)
                .layoutPriority(900)
            Spacer()
            ZStack {
                Capsule()
                    .foregroundColor(.clear)
                    .background(Color.white.materialOverlay())
                Picker("Color", selection: $tintColor) {
                    ForEach(
                        [Color.white, .red, .black, .indigo, .orange],
                        id: \.self
                    ) {
                        Text($0.description)
                    }
                }.onChange(of: tintColor) { _ in
                    updateState()
                }
            }
        }

        HStack {
            Text("Background Color")
                .frame(maxWidth: .infinity, alignment: .leading)
                .layoutPriority(900)
            Spacer()
            ZStack {
                Capsule()
                    .foregroundColor(.clear)
                    .background(Color.white.materialOverlay())
                Picker("Color", selection: $backgroundColor) {
                    ForEach(
                        [Color.accentColor, .red, .black, .indigo, .orange],
                        id: \.self
                    ) {
                        Text($0.description)
                    }
                }.onChange(of: backgroundColor) { _ in
                    updateState()
                }
            }
        }

        HStack {
            HStack {
                Text("Corner Radius")
                Spacer()
            }
            Slider(value: $backgroundCornerRadius, in: 0.0 ... 32.0, step: 1) { _ in
                updateState()
            }
            Text(backgroundCornerRadius.description)
        }

        Toggle(isOn: $displaySecondLine) {
            Text("Display Second Line?")
        }.onChange(of: displaySecondLine) { _ in
            updateState()
        }
        .padding(.trailing, 2)
        .tint(.accentColor)

        Toggle(isOn: $displayTrailingButton) {
            Text("Display Trailing Button?")
        }.onChange(of: displayTrailingButton) { _ in
            updateState()
        }
        .padding(.trailing, 2)
        .tint(.accentColor)

        HStack {
            HStack {
                Text("Inner Padding")
                Spacer()
            }
            Slider(value: $internalPadding, in: 0.0 ... 32.0, step: 1) { _ in
                updateState()
            }
            Text(internalPadding.description)
        }
    }

    func updatePosition() {
        positionOptions = .init(
            position: position
        )
    }

    func updateState() {
        toastType = .toast(
            options: .init(
                message: .init(
                    text: DemoToastOption.firstLineMessage,
                    color: tintColor
                ),
                secondaryMessage: displaySecondLine ?
                    .init(
                        text: DemoToastOption.secondLineMessage,
                        color: tintColor,
                        font: .caption
                    ) : nil,
                trailingButton: displayTrailingButton ?
                    .init(color: tintColor) : nil,
                background: .init(
                    color: backgroundColor,
                    cornerRadius: backgroundCornerRadius
                ),
                internalPadding: .init(
                    top: internalPadding,
                    left: internalPadding,
                    bottom: internalPadding,
                    right: internalPadding
                )
            )
        )
    }
}
