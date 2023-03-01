//
//  DemoLoadingToolbarOptionsView.swift
//  ViewStateController
//
//  Created by Manu on 27/02/2023.
//

import Foundation
import SwiftUI
import ViewStateController

struct DemoLoadingToolbarOptionsView: View {
    @Binding var loadingType: LoadingModifierType

    @State private var contentOpacity: CGFloat = 1
    @State private var disableInteraction: Bool = true

    var body: some View {
        HStack {
            HStack {
                Text("Content Opacity")
                Spacer()
            }
            Slider(value: $contentOpacity, in: 0.0...1, step: 0.1) { _ in
                applyToolbarState()
            }
            Text(Double(round(10 * contentOpacity) / 10).description)
        }

        Toggle(isOn: $disableInteraction) {
            Text("Disable Interaction?")
        }.onChange(of: disableInteraction) { newValue in
            applyToolbarState()
        }
        .padding(.trailing, 2)
        .tint(.accentColor)
    }

    func applyToolbarState() {
        loadingType = .toolbar(
            contentOpacity: contentOpacity,
            disableInteraction: disableInteraction
        )
    }
}
