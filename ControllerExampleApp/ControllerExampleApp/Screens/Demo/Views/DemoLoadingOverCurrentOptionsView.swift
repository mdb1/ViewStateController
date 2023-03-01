//
//  DemoLoadingOverCurrentOptionsView.swift
//  ViewStateController
//
//  Created by Manu on 27/02/2023.
//

import Foundation
import SwiftUI
import ViewStateController

struct DemoLoadingOverCurrentOptionsView: View {
    @Binding var loadingType: LoadingModifierType

    @State private var paddingValue: Double = 0
    @State private var indicatorPaddingValue: Double = 0
    @State private var contentOpacity: CGFloat = 1
    @State private var alignment: AlignmentDemoOption = .trailing
    @State private var displayIndicator: Bool = true
    @State private var disableInteraction: Bool = true

    var body: some View {
        HStack {
            HStack {
                Text("Padding")
                Spacer()
            }
            Slider(value: $paddingValue, in: 0.0 ... 32.0, step: 1) { _ in
                applyOverCurrentState()
            }
            Text(paddingValue.description)
        }

        HStack {
            HStack {
                Text("Indicator Padding")
                Spacer()
            }
            Slider(value: $indicatorPaddingValue, in: 0.0 ... 32.0, step: 1) { _ in
                applyOverCurrentState()
            }
            Text(indicatorPaddingValue.description)
        }

        HStack {
            HStack {
                Text("Content Opacity")
                Spacer()
            }
            Slider(value: $contentOpacity, in: 0.0 ... 1, step: 0.1) { _ in
                applyOverCurrentState()
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
                    ForEach(AlignmentDemoOption.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }.onChange(of: alignment) { _ in
                    applyOverCurrentState()
                }
            }
        }

        Toggle(isOn: $displayIndicator) {
            Text("Display Indicator?")
        }.onChange(of: displayIndicator) { _ in
            applyOverCurrentState()
        }
        .padding(.trailing, 2)
        .tint(.accentColor)

        Toggle(isOn: $disableInteraction) {
            Text("Disable Interaction?")
        }.onChange(of: disableInteraction) { _ in
            applyOverCurrentState()
        }
        .padding(.trailing, 2)
        .tint(.accentColor)
    }

    func applyOverCurrentState() {
        loadingType = .overCurrentContent(
            padding: paddingValue,
            displayIndicator: displayIndicator,
            indicatorPadding: indicatorPaddingValue,
            contentOpacity: contentOpacity,
            disableInteraction: disableInteraction,
            alignment: alignment.alignment
        )
    }
}
