//
//  ToastPositionOptions.swift
//
//
//  Created by Manu on 01/03/2023.
//

import Foundation
import SwiftUI

public struct ToastPositionOptions {
    public enum Position: String, CaseIterable {
        case bottom, top

        var alignment: Alignment {
            switch self {
            case .bottom: return .bottom
            case .top: return .top
            }
        }
    }

    let position: Position
    let padding: EdgeInsets

    public init(
        position: Position = .top,
        padding: EdgeInsets = .init()
    ) {
        self.position = position
        self.padding = padding
    }
}
