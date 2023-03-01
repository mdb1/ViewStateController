//
//  DemoLoadingHorizontalOptionsView.swift
//  ViewStateController
//
//  Created by Manu on 27/02/2023.
//

import Foundation
import SwiftUI
import ViewStateController

struct DemoLoadingHorizontalOptionsView: View {
    @Binding var loadingType: LoadingModifierType

    @State private var option: LoadingModifierType.HorizontalOption = .trailing
    @State private var indicatorPaddingValue: Double = 0
    @State private var contentOpacity: CGFloat = 1
    @State private var disableInteraction: Bool = true
    @State private var alignment: AlignmentDemoOption = .center
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
                        LoadingModifierType.HorizontalOption.allCases,
                        id: \.self
                    ) {
                        Text($0.rawValue)
                    }
                }.onChange(of: option) { newValue in
                    applyHorizontalState()
                }
            }
        }

        HStack {
            HStack {
                Text("Content Opacity")
                Spacer()
            }
            Slider(value: $contentOpacity, in: 0.0...1, step: 0.1) { _ in
                applyHorizontalState()
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
                    ForEach(AlignmentDemoOption.verticalCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }.onChange(of: alignment) { newValue in
                    applyHorizontalState()
                }
            }
        }

        Toggle(isOn: $disableInteraction) {
            Text("Disable Interaction?")
        }.onChange(of: disableInteraction) { newValue in
            applyHorizontalState()
        }
        .padding(.trailing, 2)
        .tint(.accentColor)

        HStack {
            HStack {
                Text("Spacing")
                Spacer()
            }
            Slider(value: $spacing, in: 0.0...32.0, step: 1) { _ in
                applyHorizontalState()
            }
            Text(spacing.description)
        }
    }

    func applyHorizontalState() {
        loadingType = .horizontal(
            option: option,
            contentOpacity: contentOpacity,
            disableInteraction: disableInteraction,
            alignment: alignment.alignment.vertical,
            spacing: spacing
        )
    }
}
