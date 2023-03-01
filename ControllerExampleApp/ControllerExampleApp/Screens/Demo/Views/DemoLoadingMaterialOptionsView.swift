//
//  DemoLoadingMaterialOptionsView.swift
//  ViewStateController
//
//  Created by Manu on 27/02/2023.
//

import Foundation
import SwiftUI
import ViewStateController

struct DemoLoadingMaterialOptionsView: View {
    @Binding var loadingType: LoadingModifierType

    @State private var paddingValue: Double = 0
    @State private var displayIndicator: Bool = true
    @State private var indicatorPaddingValue: Double = 0
    @State private var cornerRadius: Double = 8
    @State private var alignment: AlignmentDemoOption = .center

    var body: some View {
        HStack {
            HStack {
                Text("Padding")
                Spacer()
            }
            Slider(value: $paddingValue, in: 0.0 ... 32.0, step: 1) { _ in
                applyMaterialState()
            }
            Text(paddingValue.description)
        }

        Toggle(isOn: $displayIndicator) {
            Text("Display Indicator?")
        }.onChange(of: displayIndicator) { _ in
            applyMaterialState()
        }
        .padding(.trailing, 2)
        .tint(.accentColor)

        HStack {
            HStack {
                Text("Indicator Padding")
                Spacer()
            }
            Slider(value: $indicatorPaddingValue, in: 0.0 ... 32.0, step: 1) { _ in
                applyMaterialState()
            }
            Text(indicatorPaddingValue.description)
        }

        HStack {
            HStack {
                Text("Material Corner Radius")
                Spacer()
            }
            Slider(value: $cornerRadius, in: 0.0 ... 50.0, step: 1) { _ in
                applyMaterialState()
            }
            Text(cornerRadius.description)
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
                    applyMaterialState()
                }
            }
        }
    }

    func applyMaterialState() {
        loadingType = .material(
            padding: paddingValue,
            displayIndicator: displayIndicator,
            indicatorPadding: indicatorPaddingValue,
            cornerRadius: cornerRadius,
            alignment: alignment.alignment
        )
    }
}
