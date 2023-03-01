//
//  AlignmentDemoOption.swift
//  ViewStateController
//
//  Created by Manu on 23/02/2023.
//

import Foundation
import SwiftUI

enum AlignmentDemoOption: String, CaseIterable {
    case bottom, bottomLeading, bottomTrailing, center, top, topTrailing, topLeading, trailing, leading

    var alignment: Alignment {
        switch self {
        case .bottom:
            return .bottom
        case .bottomLeading:
            return .bottomLeading
        case .bottomTrailing:
            return .bottomTrailing
        case .center:
            return .center
        case .top:
            return .top
        case .topTrailing:
            return .topTrailing
        case .topLeading:
            return .topLeading
        case .trailing:
            return .trailing
        case .leading:
            return .leading
        }
    }

    static var verticalCases: [AlignmentDemoOption] {
        [.center, .bottom, .top]
    }

    static var horizontalCases: [AlignmentDemoOption] {
        [.center, .leading, .trailing]
    }
}
