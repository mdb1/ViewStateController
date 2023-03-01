//
//  DemoLoadingVerticalOptionsView.swift
//  ViewStateController
//
//  Created by Manu on 27/02/2023.
//

import Foundation
import SwiftUI
import ViewStateController

struct DemoLoadingVerticalOptionsView: View {
    @Binding var loadingType: LoadingModifierType

    @State private var option: LoadingModifierType.VerticalOption = .bottom
    @State private var indicatorPaddingValue: Double = 0
    @State private var contentOpacity: CGFloat = 1
    @State private var disableInteraction: Bool = true
    @State private var alignment: AlignmentDemoOption = .leading
    @State private var spacing: CGFloat = 8

    var body: some View {
        HStack {
            Text("Option")
                .frame(maxWidth: .infinity, alignment: .leading)
                .layoutPriority(900)
            Spacer()
            ZStack {
                Capsule()
                    .foregroundColor(.clear)
                    .background(Color.white.materialOverlay())
                Picker("Option", selection: $option) {
                    ForEach(
                        LoadingModifierType.VerticalOption.allCases,
                        id: \.self
                    ) {
                        Text($0.rawValue)
                    }
                }.onChange(of: option) { newValue in
                    applyVerticalState()
                }
            }
        }

        HStack {
            HStack {
                Text("Content Opacity")
                Spacer()
            }
            Slider(value: $contentOpacity, in: 0.0...1, step: 0.1) { _ in
                applyVerticalState()
            }
            Text(Double(round(10 * contentOpacity) / 10).description)
        }

        HStack {
            Text("Alignment")
                .frame(maxWidth: .infinity, alignment: .leading)
                .layoutPriority(900)
            Spacer()
            ZStack {
                Capsule()
                    .foregroundColor(.clear)
                    .background(Color.white.materialOverlay())
                Picker("Alignment", selection: $alignment) {
                    ForEach(AlignmentDemoOption.horizontalCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }.onChange(of: alignment) { newValue in
                    applyVerticalState()
                }
            }
        }

        Toggle(isOn: $disableInteraction) {
            Text("Disable Interaction?")
        }.onChange(of: disableInteraction) { newValue in
            applyVerticalState()
        }
        .padding(.trailing, 2)
        .tint(.accentColor)

        HStack {
            HStack {
                Text("Spacing")
                Spacer()
            }
            Slider(value: $spacing, in: 0.0...32.0, step: 1) { _ in
                applyVerticalState()
            }
            Text(spacing.description)
        }
    }

    func applyVerticalState() {
        loadingType = .vertical(
            option: option,
            contentOpacity: contentOpacity,
            disableInteraction: disableInteraction,
            alignment: alignment.alignment.horizontal,
            spacing: spacing
        )
    }
}
