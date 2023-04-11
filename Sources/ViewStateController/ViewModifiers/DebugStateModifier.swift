//
//  DebugStateModifier.swift
//  
//
//  Created by Manu on 11/04/2023.
//

import Foundation
import SwiftUI

/// Applies the debug state modifier to the view.
/// By tapping 3 times on the view, a modal will be displayed with options to debug
/// the state of the controller.
extension View {
    public func debugState<Info>(
        controller: Binding<ViewStateController<Info>>,
        mockInfo: Info
    ) -> some View {
        #if DEBUG
        // Only apply the debug state modifier in debug builds
        self.modifier(DebugStateModifier(controller: controller, mockInfo: mockInfo))
        #endif
    }
}

struct DebugStateModifier<Info>: ViewModifier {
    @Binding private var controller: ViewStateController<Info>
    private var mockInfo: Info
    @State private var isDisplayingModal: Bool = false

    init(controller: Binding<ViewStateController<Info>>, mockInfo: Info) {
        _controller = controller
        self.mockInfo = mockInfo
    }

    func body(content: Content) -> some View {
        content
            .roundedOverlayBorder(
                cornerRadius: 8,
                color: isDisplayingModal ? .red : .clear
            )
            .onTapGesture(count: 3) {
                isDisplayingModal = true
            }
            .sheet(isPresented: $isDisplayingModal) {
                VStack {
                    Text("Debug State")
                    buttons
                }
                // Set the presentation detents for the sheet
                .presentationDetents([.height(120)])
            }
    }

    var buttons: some View {
        HStack {
            // Button to set the controller to the loading state
            Button("Loading") { controller.setState(.loading) }
            // Button to set the controller to the loaded state with mock data
            Button("Loaded") { controller.setState(.loaded(mockInfo)) }
            // Button to set the controller to the error state with a mock error
            Button("Error") { controller.setState(.error(NSError(domain: "", code: 12))) }
            // Button to reset the controller to its initial state
            Button("Reset") { controller.reset() }
        }
        .buttonStyle(.bordered)
    }
}
