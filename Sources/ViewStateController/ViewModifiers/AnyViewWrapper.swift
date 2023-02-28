//
//  AnyViewWrapper.swift
//  ViewStateController
//
//  Created by Manu on 23/02/2023.
//

import SwiftUI

public extension View {
    /// Embeds the current view inside an AnyView.
    func asAnyView() -> AnyView {
        AnyView(self)
    }
}
