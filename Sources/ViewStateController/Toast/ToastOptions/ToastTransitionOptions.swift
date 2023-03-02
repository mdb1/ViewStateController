//
//  ToastTransitionOptions.swift
//
//
//  Created by Manu on 01/03/2023.
//

import Foundation
import SwiftUI

public struct ToastTransitionOptions {
    let duration: TimeInterval
    let transition: AnyTransition
    let animation: Animation

    public init(
        duration: TimeInterval = 4,
        transition: AnyTransition = .opacity.combined(with: .move(edge: .top)),
        animation: Animation = .default
    ) {
        self.duration = duration
        self.transition = transition
        self.animation = animation
    }
}
